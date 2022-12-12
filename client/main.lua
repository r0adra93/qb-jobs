-- Variables
QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs
local player = QBCore.Functions.GetPlayerData()
local DutyBlips,PlayerJob
local vehiclesAssigned = {}
local pedList = {}
local PublicBlips = {}
local onDuty = false
local vehCount = {}
-- Functions
local function CurrentJob()
    local function jobPop()
        player = QBCore.Functions.GetPlayerData()
        PlayerJob = player.job
    end
    if not PlayerJob then
        while not PlayerJob do
            jobPop()
            Wait(5000)
        end
    else
        jobPop()
    end
end
exports('CurrentJob',CurrentJob)
local function vehDelProc(plate)
    local data = {};
    data.plate = plate
    data.vehicle = vehiclesAssigned[plate].vehicle
    data.netid = vehiclesAssigned[plate].netid
    data.veh = vehiclesAssigned[plate].veh
    if not data.noRefund and Config.Jobs[PlayerJob.name].VehicleConfig.depositFees and Config.Jobs[PlayerJob.name].Vehicles[data.vehicle].depositPrice then
        TriggerServerEvent('qb-jobs:server:vehicleProcDelete', data)
    end
    DeleteVehicle(data.netid)
    vehiclesAssigned[data.plate] = nil
    QBCore.Functions.TriggerCallback('qb-jobs:server:subtractVehCount',function(result)
        vehCount = result
        QBCore.Functions.Notify(Lang:t("info.keysReturned"))
    end,data)
end
local function receiveGaragedVehicles(data)
    QBCore.Functions.TriggerCallback('qb-jobs:server:sendGaragedVehicles',function(result)
        if Config.Jobs[PlayerJob.name].VehicleConfig.assignVehicles and next(vehiclesAssigned) then
            vehDelProc()
        end
        result.returnVehicle = vehiclesAssigned;
        result.uiColors = Config.Jobs[PlayerJob.name].uiColors
--        QBCore.Debug(json.encode(result)) -- this is to obtain the json object for testing UI.
        SendNUIMessage({
            vehList = result
        })
        SetNuiFocus(true,true)
    end, data.id)
end
-- Control Listener
local function Listen4Control(data)
    ControlListen = true
    CreateThread(function()
        while ControlListen do
            if IsControlJustReleased(0, 38) then
                if data.event == "receiveGaragedVehicles" then
                    receiveGaragedVehicles(data)
                end
            end
            Wait(1)
        end
    end)
end
local function TakeOutVehicle(result)
    QBCore.Debug(result)
    if not Config.Jobs[PlayerJob.name].Vehicles[result[2]] then
        QBCore.Functions.Notify(Lang:t("denied.noVehicle"))
        return
    end
    if Config.Jobs[PlayerJob.name].VehicleConfig.maxVehicles > 0 and Config.Jobs[PlayerJob.name].VehicleConfig.maxVehicles <= vehCount[PlayerJob.name] then
        QBCore.Functions.Notify(Lang:t("info.vehicleLimitReached"))
        return false
    end
    local coords
    local data = {
        ["garage"] = result[1],
        ["vehicle"] = result[2],
        ["selGar"] = result[3]
    }
    local cbData = {
        ["selGar"] = data.selGar,
    }
    if result[4] then cbData["plate"] = result[4] end
    local function vehicleExtras(veh,extras)
        for i = 0,13 do
            if DoesExtraExist(veh,i) then
                if extras[i] then SetVehicleExtra(veh, i, extras[i])
                else SetVehicleExtra(veh, i, 1) end
            end
        end
    end
    for _,v in pairs(Config.Jobs[PlayerJob.name].Locations.garages[data.garage].spawnPoint) do
        if v.type == Config.Jobs[PlayerJob.name].Vehicles[result[2]].type and not IsAnyVehicleNearPoint(vector3(v.coords.x,v.coords.y,v.coords.z), 2.5) then
            coords = v.coords
            break
        end
    end
    QBCore.Functions.TriggerCallback("qb-jobs:server:vehiclePlateCheck",function(plate)
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
                if not Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle] then
                    if not Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras then
                        vehicleExtras(data.netid, Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras)
                        --QBCore.Shared.SetDefaultVehicleExtras(data.netid, Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras)
                    end
                    if Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].livery ~= nil then
                        SetVehicleLivery(data.netid, Config.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].livery)
                    end
                end
                TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", data.plate)
                if Config.Jobs[PlayerJob.name].Items and (Config.Jobs[PlayerJob.name].Items.trunk or Config.Jobs[PlayerJob.name].Items.glovebox) then
                    local tseData = {}
                    tseData.vehicle = data.vehicle
                    tseData.plate = data.plate
                    TriggerServerEvent('qb-jobs:server:addVehItems',tseData)
                end
                vehiclesAssigned[data.plate] = {
                    ["netid"] = data.netid,
                    ["vehicle"] = data.vehicle,
                    ["veh"] = data.veh
                }
                if (data.selGar) then
                    QBCore.Functions.TriggerCallback("qb-jobs:server:vehicleProc", function(result)
                        if not result then
                            data.noRefund = true
                            vehDelProc(data)
                            return
                        end
                    end,data)
                else
                    data.noRefund = true
                    vehDelProc(data)
                    QBCore.Functions.Notify(Lang:t("denied.noGarageSelected"))
                    return
                end
            end, data.vehicle, coords, false)
            QBCore.Functions.TriggerCallback('qb-jobs:server:addVehCount',function(result)
                vehCount = result
            end)
        end
    end,cbData)
end
local function spawnPeds()
   while not PlayerJob do CurrentJob() Wait(5000) end
   local index = 1
    for k,v in pairs(Config.Jobs[PlayerJob.name].Locations) do
        local pedSet = {}
        if k == "duty" then
            pedSet.event = "qb-jobs:client:ToggleDuty"
            pedSet.label = Lang:t('info.onoff_duty')
            pedSet.dataPass = false
        elseif k == "management" and PlayerJob.isboss then
            pedSet.event = "qb-bossmenu:client:OpenMenu"
            pedSet.label = Lang:t('info.enter_management')
            pedSet.dataPass = false
            pedSet.clntSvr = client
        elseif k == "garages" then
-- I don't know yet            pedSet.inGarageRange = true
            pedSet.event = "receiveGaragedVehicles"
            pedSet.label = Lang:t('info.enter_garage')
            pedSet.dataPass = true
            pedSet.clntSvr = client
        elseif k == "stashes" then
            pedSet.event = "qb-jobs:server:openStash"
            pedSet.label = Lang:t('info.stash_enter')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "armories" then
            pedSet.event = "qb-jobs:server:openArmory"
            pedSet.label = Lang:t('info.enter_armory')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "trash" then
            pedSet.event = "qb-jobs:server:openTrash"
            pedSet.label = Lang:t('info.trash_enter')
            pedSet.dataPass = false
            pedSet.clntSvr = server
        elseif k == "outfits" then
            pedSet.event = "qb-jobs:client:openOutfits"
            pedSet.label = Lang:t('info.enter_outfit')
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
                    current.model = type(current.model) == 'string' and GetHashKey(current.model) or current.model
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
    local pedsSpawned = true
end
local function killPeds()
    for _,v in pairs(pedList) do
        DeleteEntity(v)
    end
end
local function SetBlip(conf)
    local blip = AddBlipForCoord(conf.coords.x, conf.coords.y, conf.coords.z)
    SetBlipSprite(blip, conf.blipNumber)
    SetBlipAsShortRange(blip, conf.blipNumber)
    SetBlipScale(blip, conf.blipScale)
    SetBlipColour(blip, conf.blipColor)
    SetBlipDisplay(blip, conf.blipDisplay)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(conf.blipName)
    EndTextCommandSetBlipName(blip)
end
local function CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    if not Config.Jobs[playerJob].DutyBlips.enable then return end
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
    if not DoesBlipExist(blip) and Config.Jobs[playerJob].DutyBlips then
        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end
        SetBlipSprite(blip, Config.Jobs[playerJob].DutyBlips.blipSprite)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, Config.Jobs[playerJob].DutyBlips.blipScale)
        SetBlipColour(blip, Config.Jobs[playerJob].DutyBlips.blipSpriteColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        if Config.Jobs[playerJob].DutyBlips.type == "service" then DutyBlips[#DutyBlips+1] = blip
        elseif Config.Jobs[playerJob].DutyBlips.type == "public" then PublicBlips[#PublicBlips+1] = blip end
    end
    if GetBlipFromEntity(PlayerPedId()) == blip then
        RemoveBlip(blip) -- removes player's blip from their map
    end
end
local function BlipsRemover()
    if PlayerJob then
        if DutyBlips then
            for _, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
    if PublicBlips then
        if PublicBlips then
            for _, v in pairs(PublicBlips) do
                RemoveBlip(v)
            end
        end
        PublicBlips = {}
    end
end
local function AddJobs()
    return Config.Jobs
end
exports('AddJobs',AddJobs)
local function setLocations()
    for k,v in pairs(Config.Jobs) do
        if v.Locations and v.Locations.stations then
            for _,v1 in pairs(v.Locations.stations) do
                if k == PlayerJob.name or v.type == PlayerJob.type or v1.public then SetBlip(v1) end
            end
        end
    end
end
local function kickOff()
    CreateThread(function()
        QBCore.Functions.TriggerCallback("qb-jobs:server:vehCount", function(data)
            vehCount = data
        end)
        CurrentJob()
        Config.Jobs = AddJobs()
        spawnPeds()
        setLocations()
        TriggerServerEvent('qb-jobs:server:vehTrackInitilization')
    end)
end
-- Events
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    if JobInfo.onduty then
        TriggerEvent("qb-jobs:client:ToggleDuty")
        onDuty = false
    end
    killPeds()
    BlipsRemover()
    PlayerJob = JobInfo
    TriggerEvent("qb-jobs:client:ToggleDuty")
    onDuty = true
    spawnPeds()
    TriggerServerEvent("qb-jobs:server:UpdateBlips")
end)
RegisterNetEvent('QBCore:Client:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore = exports['qb-core']:GetCoreObject()
    BlipsRemover()
    TriggerServerEvent("qb-jobs:server:UpdateBlips")
    onDuty = PlayerJob.onduty
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent('qb-jobs:server:UpdateBlips')
    onDuty = false
    killPeds()
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
    BlipsRemover()
end)
RegisterNetEvent('qb-jobs:client:ToggleDuty', function()
    onDuty = not onDuty
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerServerEvent("qb-jobs:server:UpdateBlips")
    if PlayerJob.type == "leo" then
        TriggerServerEvent("police:server:UpdateCurrentCops")
    elseif PlayerJob.type == "ambulance" then
        TriggerServerEvent("hospital:server:UpdateCurrentDoctors")
    end
end)
RegisterNetEvent('qb-jobs:client:UpdateBlips', function(dutyPlayers, publicPlayers)
    BlipsRemover()
    for _,v in pairs(Config.Jobs) do
        if v.DutyBlips and v.DutyBlips.enable then
            if v.DutyBlips.type == "service" and onDuty and dutyPlayers then
                for _, data in pairs(dutyPlayers) do
                    local id = GetPlayerFromServerId(data.source)
                    CreateDutyBlips(id, data.label, data.job, data.location)
                end
            elseif v.DutyBlips.type == "public" and publicPlayers then
                for _, data in pairs(publicPlayers) do
                    local id = GetPlayerFromServerId(data.source)
                    CreateDutyBlips(id, data.label, data.job, data.location)
                end
            end
        end
    end
end)
RegisterNetEvent('qb-jobs:client:openOutfits', function()
    exports['qb-clothing']:getOutfits(PlayerJob.grade.level, Config.Jobs[PlayerJob.name].Outfits)
end)
-- NUI Callbacks
RegisterNUICallback('qbJobsCloseMenu', function()
    SetNuiFocus(false,false)
end)
RegisterNUICallback('qbJobsSelectedVehicle', function(data,cb)
    TakeOutVehicle(data)
    cb("ok")
end)
RegisterNUICallback('qbJobsDelVeh', function(result,cb)
    vehDelProc(result)
    cb(vehiclesAssigned)
end)
kickOff()