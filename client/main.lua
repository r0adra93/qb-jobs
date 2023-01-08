-- Variables
--- populates QBCore table
QBCore = exports['qb-core']:GetCoreObject()
--- names variables and tables to be used throughout the script
local player,playerJob,DutyBlips,pedsSpawned,locationsSet,vehExtras,mgrBtnList
--- list of vehicles assigned to the player
local vehiclesAssigned = {}
--- list of peds that are spawned for an active job
local pedList = {}
--- list of public duty blips
local publicBlips = {}
--- player's duty status
local onDuty = false
--- list of job related map blips
local blipList = {}
--- list of location polys
local polyLocList = {}
--- list of Jobs key = job name | value = job label
local jobsList = {}
-- Functions
--- sets the player's player and playerJob tables
local function setCurrentJob()
    local function jobPop()
        player = QBCore.Functions.GetPlayerData()
        playerJob = player.job
    end
    if not playerJob then
        while not playerJob do
            jobPop()
            Wait(5000)
        end
    else
        jobPop()
    end
end
exports('CurrentJob',CurrentJob)
--- sets the jobsList
local function buildJobsList()
    for k,v in pairs(Config.Jobs) do
        jobsList[k] = v.label
    end
end
--- deletes spawned vehicles and refunds deposits
local function deleteVehicleProcess(plate)
    local data = {};
    data.plate = plate
    data.vehicle = vehiclesAssigned[plate].vehicle
    data.netid = vehiclesAssigned[plate].netid
    data.veh = vehiclesAssigned[plate].veh
    TriggerServerEvent('qb-jobs:server:deleteVehicleProcess', data)
    DeleteVehicle(data.netid)
    vehiclesAssigned[data.plate] = nil
    QBCore.Functions.Notify(Lang:t("info.keysReturned"))
end
--- clears any spawned vehicles after logoff
local function clearVehicles()
    if next(vehiclesAssigned) then
        for k in pairs(vehiclesAssigned) do
            deleteVehicleProcess(k)
        end
    end
end
--- receives the vehicle list from server and opens the menu
local function receiveGaragedVehicles(data)
    QBCore.Functions.TriggerCallback('qb-jobs:server:sendGaragedVehicles',function(result)
        if Config.Jobs[playerJob.name].VehicleConfig.assignVehicles and next(vehiclesAssigned) then
            deleteVehicleProcess()
        end
        result.returnVehicle = vehiclesAssigned;
        result.uiColors = Config.Jobs[playerJob.name].uiColors
--        QBCore.Debug(json.encode(result)) -- this is to obtain the json object for testing UI.
        SendNUIMessage({
            action = "garage",
            btnList = result
        })
        SetNuiFocus(true,true)
    end, data.id)
end
--- creates the button list for the boss menu
local function processButtonList(res)
    mgrBtnList = {
        ["header"] = Config.Jobs[playerJob.name].label .. Lang:t('headings.management'),
        ["currentJob"] = playerJob.name,
        ["currentJobName"] = Config.Jobs[playerJob.name].label,
        ["icons"] = Config.Jobs[playerJob.name].management.icons,
        ["status"] = Config.Jobs[playerJob.name].management.status,
        ["awards"] = Config.Jobs[playerJob.name].management.awards,
        ["reprimands"] = Config.Jobs[playerJob.name].management.reprimands,
        ["jobsList"] = jobsList
    }
    if Config.Jobs[playerJob.name].uiColors then mgrBtnList.uiColors = Config.Jobs[playerJob.name].uiColors end
    for k,v in pairs(res) do
        mgrBtnList[k] = v
    end
end
--- receives data for the boss menu from the server and opens the boss menu
local function receiveManagementData(data)
    QBCore.Functions.TriggerCallback('qb-jobs:server:sendManagementData',function(res)
        processButtonList(res)
--        QBCore.Debug(json.encode(mgrBtnList)) -- this is to obtain the json object for testing UI.
        SendNUIMessage({
            action = "management",
            btnList = mgrBtnList
        })
        SetNuiFocus(true,true)
    end, data.id)
end
--- Opens clothing menu
local function openOutfits()
    exports['qb-clothing']:getOutfits(playerJob.grade.level, Config.Jobs[playerJob.name].Outfits)
end
--- Opens the motorworks aka qb-customs menu
local function openMotorworks(res)
    local location = Config.Jobs[playerJob.name].MotorworksConfig
    local data = {
        ["spot"] = location.settings.label,
        ["coords"] = vector3(location.zones[res.id].coords.x, location.zones[res.id].coords.y, location.zones[res.id].coords.z),
        ["heading"] = location.zones[res.id].heading,
        ["drawtextui"]  = location.drawtextui.text
    }
    data.location = {}
    data.location[playerJob.name] = location
    data.pj = playerJob.name
    data.jobs = true
    local restrictions = exports["qb-customs"]:CheckRestrictions(playerJob.name)
    if restrictions then exports["qb-customs"]:processExports(data) end
end
--- checks out vehicle from the motorpool
local function takeOutVehicle(result)
    if not Config.Jobs[playerJob.name].Vehicles[result[2]] then
        QBCore.Functions.Notify(Lang:t("denied.noVehicle"))
        return false
    end
    QBCore.Functions.TriggerCallback("qb-jobs:server:verifyMaxVehicles", function(vehCheck)
        if not vehCheck then return false end
        local function vehicleExtras(veh,extras)
            local ex
            for i = 0,20 do
                if DoesExtraExist(veh,i) then
                    ex = 1
                    if extras[i] then ex = extras[i] end
                    SetVehicleExtra(veh, i, ex)
                end
            end
        end
        local coords
        local data = {
            ["garage"] = result[garage],
            ["vehicle"] = result[vehicle],
            ["selGar"] = result[selGar]
        }
        local cbData = { ["selGar"] = data.selGar }
        if result[4] then cbData["plate"] = result[4] end
        for _,v in pairs(Config.Jobs[playerJob.name].Locations.garages[data.garage].spawnPoint) do
            if v.type == Config.Jobs[playerJob.name].Vehicles[result[2]].type and not IsAnyVehicleNearPoint(vector3(v.coords.x,v.coords.y,v.coords.z), 2.5) then
                coords = v.coords
                break
            end
        end
        QBCore.Functions.TriggerCallback("qb-jobs:server:vehiclePlateCheck",function(plate,vehicleProps)
            if not plate then return false end
            data.plate = plate
            if coords and data.plate then
                QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(veh)
                    data.veh = veh
                    data.netid = NetToVeh(veh)
                    SetVehicleEngineOn(data.netid, false, true)
                    SetVehicleNumberPlateText(data.netid, data.plate)
                    data.plate = QBCore.Functions.GetPlate(data.netid)
                    SetEntityHeading(data.netid, coords.w)
                    exports[Config.qbjobs.fuel]:SetFuel(data.netid, 100.0)
                    SetVehicleFixed(data.netid)
                    SetEntityAsMissionEntity(data.netid, true, true)
                    SetVehicleDoorsLocked(data.netid, 2)
                    if Config.Jobs[playerJob.name].VehicleSettings[data.vehicle] then
                        vehExtras = Config.Jobs[playerJob.name].VehicleSettings[data.vehicle].extras
                        if vehExtras and vehExtras.grades[playerJob.grades.level] then
                            vehicleExtras(data.netid, vehExtras)
                            --QBCore.Shared.SetDefaultVehicleExtras(data.netid, Config.Jobs[playerJob.name].VehicleSettings[data.vehicle].extras)
                        end
                        if Config.Jobs[playerJob.name].VehicleSettings[data.vehicle].livery then
                            SetVehicleLivery(data.netid, Config.Jobs[playerJob.name].VehicleSettings[data.vehicle].livery)
                        end
                    end
                    if properties then QBCore.Functions.SetVehicleProperties(data.netid, vehicleProps) end
                    TriggerServerEvent(Config.qbjobs.keys, data.plate)
                    if Config.Jobs[playerJob.name].Items and (Config.Jobs[playerJob.name].Items.trunk or Config.Jobs[playerJob.name].Items.glovebox) then
                        local tseData = {}
                        tseData.vehicle = data.vehicle
                        tseData.plate = data.plate
                        TriggerServerEvent('qb-jobs:server:addVehItems',tseData)
                    end
                    vehiclesAssigned[data.plate] = {
                        ["netid"] = data.netid,
                        ["vehicle"] = data.vehicle,
                        ["veh"] = data.veh,
                        ["selGar"] = data.selGar
                    }
                    if not (data.selGar) then
                        data.noRefund = true
                        deleteVehicleProcess(data)
                        QBCore.Functions.Notify(Lang:t("denied.noGarageSelected"))
                        return
                    end
                    QBCore.Functions.TriggerCallback("qb-jobs:server:spawnVehicleProcessor", function(res)
                        if not res then
                            data.noRefund = true
                            deleteVehicleProcess(data)
                            return
                        end
                    end,data)
                end, data.vehicle, coords, false)
                TriggerServerEvent('qb-jobs:server:addVehicle')
            end
        end,cbData)
    end)
end
--- toggles duty status
local function toggleDuty()
    onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("qb-jobs:server:updateBlips")
    if playerJob.type == "leo" then
        TriggerServerEvent("police:server:UpdateCurrentCops")
    elseif playerJob.type == "ambulance" then
        TriggerServerEvent("hospital:server:UpdateCurrentDoctors")
    end
end
--- Listens for actions to interact with job peds
local function Listen4Control(data)
    ControlListen = true
    CreateThread(function()
        while ControlListen do
            if IsControlJustReleased(0, 38) then
                if data.event == "toggleDuty" then
                    toggleDuty()
                elseif data.event == "openBossMenu" then
                    receiveManagementData(data)
                elseif data.event == "openOldBossMenu" then
                    TriggerEvent("qb-bossmenu:client:OpenMenu")
                elseif data.event == "receiveGaragedVehicles" then
                    receiveGaragedVehicles(data)
                elseif data.event == "openStash" then
                    TriggerServerEvent("qb-jobs:server:openStash")
                elseif data.event == "openArmory" then
                    TriggerServerEvent("qb-jobs:server:openArmory")
                elseif data.event == "openTrash" then
                    TriggerServerEvent("qb-jobs:server:openTrash")
                elseif data.event == "openOutfits" then
                    openOutfits()
                elseif data.event == "openMotorworks" then
                    openMotorworks(data)
                end
            end
            Wait(1)
        end
    end)
end
--- spawns the peds for all the job locations
local function spawnPeds()
    while not playerJob do setCurrentJob() Wait(5000) end
    if not Config.Jobs[playerJob.name].Locations then return end
    local index = 1
    for k,v in pairs(Config.Jobs[playerJob.name].Locations) do
        local pedSet = {}
        if k == "duty" then
            pedSet.event = "toggleDuty"
            pedSet.label = Lang:t('info.onoff_duty')
            pedSet.dataPass = false
        elseif k == "management" and Config.Jobs.ambulance.jobBosses[player.citizenid] then
            pedSet.event = "openBossMenu"
            pedSet.label = Lang:t('info.enter_management')
            pedSet.dataPass = false
            pedSet.clntSvr = client
        elseif k == "oldManagement" and Config.Jobs.ambulance.jobBosses[player.citizenid] then
            pedSet.event = "openOldBossMenu"
            pedSet.label = "enter Old Management"
            pedSet.dataPass = false
            pedSet.clntSvr = client
        elseif k == "garages" then
-- I don't know yet            pedSet.inGarageRange = true
            pedSet.event = "receiveGaragedVehicles"
            pedSet.label = Lang:t('info.enter_garage')
            pedSet.dataPass = true
            pedSet.clntSvr = client
        elseif k == "stashes" then
            pedSet.event = "openStash"
            pedSet.label = Lang:t('info.stash_enter')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "armories" then
            pedSet.event = "openArmory"
            pedSet.label = Lang:t('info.enter_armory')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "trash" then
            pedSet.event = "openTrash"
            pedSet.label = Lang:t('info.trash_enter')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "outfits" then
            pedSet.event = "openOutfits"
            pedSet.label = Lang:t('info.enter_outfit')
            pedSet.dataPass = false
            pedSet.clntSvr = client
        elseif k == "motorworks" then
            pedSet.event = "openMotorworks"
            pedSet.label = Lang:t('info.enter_motorworks')
            pedSet.dataPass = false
            pedSet.clntSvr = client
        elseif k == "stations" then
            pedSet = {}
        end
        if pedSet then
            for k1,v1 in pairs(v) do
                if v1.ped then
                    local current = v1.ped
                    current.id = k1;
                    current.model = type(current.model) == 'string' and joaat(current.model) or current.model
                    RequestModel(current.model)
                    while not HasModelLoaded(current.model) do
                        Wait(0)
                    end
                    local ped = CreatePed(0, current.model, current.coords.x, current.coords.y, current.coords.z -1,false, false)
                    pedList[index] = ped
                    SetEntityHeading(ped,  current.coords.w)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    current.pedHandle = ped
                    current.location = k
                    current.event = pedSet.event
                    current.dataPass = pedSet.dataPass
                    current.clntSvr = pedSet.clntSvr
                    if pedSet then
                        if Config.UseTarget then
                            exports['qb-target']:AddTargetEntity(ped, {
                                options = {
                                    {
                                        type = "client",
                                        event = pedSet.event,
                                        label = pedSet.label,
                                        data = current
                                    }
                                },
                                distance = current.ped.drawDistance
                            })
                        else
                            if current.zoneOptions then
                                local zone = BoxZone:Create(current.coords.xyz, current.zoneOptions.length, current.zoneOptions.width, {
                                    name = "zone_qbjobs_" .. ped,
                                    heading = current.coords.w,
                                    minZ = current.coords.z - 1,
                                    maxZ = current.coords.z + 1,
                                    debugPoly = Config.qbjobs.DebugPoly
                                })
                                polyLocList[zone] = zone
                                zone:onPlayerInOut(function(inside)
                                    if onDuty or k == "duty" then
                                        if inside then
                                            exports['qb-core']:DrawText(pedSet.label, 'left')
                                            Listen4Control(current)
                                        else
                                            ControlListen = false
                                            exports['qb-core']:HideText()
                                        end
                                    end
                                end)
                            end
                        end
                        index = index + 1
                    end
                end
            end
        end
    end
    pedsSpawned = true
end
--- destroys all spawned job peds
local function killPeds()
    for _,v in pairs(pedList) do
        DeleteEntity(v)
    end
    pedsSpawned = false
end
--- configures all the map blip locations
local function setBlip(conf)
    local blip = AddBlipForCoord(conf.coords.x, conf.coords.y, conf.coords.z)
    SetBlipSprite(blip, conf.blipNumber)
    SetBlipAsShortRange(blip, conf.blipNumber)
    SetBlipScale(blip, conf.blipScale)
    SetBlipColour(blip, conf.blipColor)
    SetBlipDisplay(blip, conf.blipDisplay)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(conf.blipName)
    EndTextCommandSetBlipName(blip)
    blipList[blip] = blip
end
--- deletes all map blip locations
local function removeBlips()
    for k in pairs(blipList) do
        RemoveBlip(k)
    end
end
--- creates the duty blips on the minimap
local function createDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    if not Config.Jobs[playerJob].DutyBlips.enable then return end
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
    if not DoesBlipExist(blip) and Config.Jobs[playerJob].DutyBlips then
        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end
        SetBlipSprite(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteOnFoot)
        ShowHeadingIndicatorOnBlip(blip, true)
        if IsPedInAnyVehicle(ped) then
            SetBlipSprite(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteInVehicle)
            ShowHeadingIndicatorOnBlip(blip, false)
        end
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, Config.Jobs[playerJob].DutyBlips.blipScale)
        SetBlipColour(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        if Config.Jobs[playerJob].DutyBlips.type == "service" then DutyBlips[#DutyBlips+1] = blip
        elseif Config.Jobs[playerJob].DutyBlips.type == "public" then publicBlips[#publicBlips+1] = blip end
    end
    if GetBlipFromEntity(PlayerPedId()) == blip then
        RemoveBlip(blip) -- removes player's blip from their map
    end
end
--- destroys the duty blips on the minimap
local function removeDutyBlips()
    if playerJob then
        if DutyBlips then
            for _, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
    if publicBlips then
        if publicBlips then
            for _, v in pairs(publicBlips) do
                RemoveBlip(v)
            end
        end
        publicBlips = {}
    end
end
--- creates minimap locations for current job
local function setLocations()
    for k,v in pairs(Config.Jobs) do
        if v.Locations and v.Locations.stations then
            for _,v1 in pairs(v.Locations.stations) do
                if k == playerJob.name or v.type == playerJob.type or v1.public then setBlip(v1) end
            end
        end
    end
    locationsSet = true
end
--- creates vehicle parking locations for qb-customs
local function setCustomsLocations()
    local location = {}
    location[playerJob.name] = Config.Jobs[playerJob.name].MotorworksConfig
    location["pj"] = playerJob.name
    exports["qb-customs"]:buildLocations(location)
end
--- all start up functions, tables and threads
local function kickOff()
    CreateThread(function()
        TriggerServerEvent("qb-jobs:server:BuildJobHistory")
        TriggerServerEvent("qb-jobs:server:populateJobs")
        TriggerServerEvent("qb-jobs:server:countVehicle")
        setCurrentJob()
        if not pedsSpawned then
            spawnPeds()
        end
        if not locationsSet then
            setLocations()
        end
        setCustomsLocations()
        onDuty = playerJob.onduty
        buildJobsList()
        TriggerServerEvent('qb-jobs:server:initilizeVehicleTracker')
    end)
end
--- list of functions, tables and threads to run at logout, job change, etc
local function wrapUp()
    killPeds()
    clearVehicles()
    removeBlips()
end
-- Events
--- fivem native for restart start
AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        kickOff()
    end
end)
--- fivem native for restart stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        wrapUp()
    end
end)
--- qbcore native for jobUpdate
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.onduty then
        toggleDuty()
        onDuty = false
    else
        toggleDuty()
        onDuty = true
    end
    wrapUp()
    playerJob = JobInfo
    kickOff()
    TriggerServerEvent("qb-jobs:server:updateBlips")
end)
--- qbcore native for object updates
RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)
--- qbcore native for on player loaded
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore = exports['qb-core']:GetCoreObject()
    wrapUp()
    TriggerServerEvent("qb-jobs:server:updateBlips")
    kickOff()
end)
--- qbcore native for on player unloaded
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('qb-jobs:server:updateBlips')
    onDuty = false
    wrapUp()
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)
--- qb-jobs toggle duty event
RegisterNetEvent('qb-jobs:client:toggleDuty', function()
    toggleDuty()
end)
--- qb-jobs blip update event
RegisterNetEvent('qb-jobs:client:updateBlips', function(dutyPlayers, publicPlayers)
    removeDutyBlips()
    for _,v in pairs(Config.Jobs) do
        if v.DutyBlips and v.DutyBlips.enable then
            if v.DutyBlips.type == "service" and onDuty and dutyPlayers then
                for _, data in pairs(dutyPlayers) do
                    local id = GetPlayerFromServerId(data.source)
                    createDutyBlips(id, data.label, data.job, data.location)
                end
            elseif v.DutyBlips.type == "public" and publicPlayers then
                for _, data in pairs(publicPlayers) do
                    local id = GetPlayerFromServerId(data.source)
                    createDutyBlips(id, data.label, data.job, data.location)
                end
            end
        end
    end
end)
-- NUI Callbacks
--- closes the menu
RegisterNUICallback('closeMenu', function(data,cb)
    data = true
    SetNuiFocus(false,false)
    cb(data)
end)
--- begins the process to spawn the selected vehicle
RegisterNUICallback('selectedVehicle', function(data,cb)
    takeOutVehicle(data)
    cb("ok")
end)
--- begins the process to delete a vehicle
RegisterNUICallback('delVeh', function(result,cb)
    deleteVehicleProcess(result)
    cb(vehiclesAssigned)
end)
--- boss menu button actions processor
RegisterNUICallback('managementSubMenuActions', function(res,cb)
    local data = {}
    QBCore.Functions.TriggerCallback('qb-jobs:server:processManagementSubMenuActions',function(res1)
        processButtonList(res1)
        data.btnList = mgrBtnList
        cb(data)
    end,res)
end)
