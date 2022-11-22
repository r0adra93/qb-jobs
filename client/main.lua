-- Variables
QBCore = exports['qb-core']:GetCoreObject()
QBCore.Shared.Jobs = Config.Jobs
local player = QBCore.Functions.GetPlayerData()
local currentGarage,DutyBlips,inGarage,markers,PlayerJob
local pedList = {}
local PublicBlips = {}
local sleep
local dutylisten = false
local inArmory = false
local inManagement = false
local inOutfit = false
local inStash = false
local inTrash = false
local onDuty = false
-- Functions
local function CurrentJob()
    function fuckoff()
        player = QBCore.Functions.GetPlayerData()
        PlayerJob = player.job
    end
    if not PlayerJob then
        while not PlayerJob do
            fuckoff()
            Wait(5000)
        end
    else
        fuckoff()
    end
end
exports('CurrentJob',CurrentJob)
-- Control Listener
local function Listen4Control(data)
    ControlListen = true
    CreateThread(function()
        while ControlListen do
            if IsControlJustReleased(0, 38) then
                if data.clntSvr == "client" then
                    if data.dataPass then
                        TriggerEvent(data.event,data)
                    else
                        TriggerEvent(data.event)
                    end
                else
                    if data.dataPass then
                        TriggerServerEvent(data.event,data)
                    else
                        TriggerServerEvent(data.event)
                    end
                end
            end
            Wait(1)
        end
    end)
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
            pedSet.event = "qb-jobs:server:sendGaragedVehicles"
            pedSet.label = Lang:t('info.enter_garage')
            pedSet.dataPass = false
            pedSet.clntSvr = server
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
local function MenuGarage(currentSelection)
    setCityhallPageState(false, false)
end
local function closeMenuFull()
    exports['qb-menu']:closeMenu()
end
local function vehicleExtras(veh,extras)
    for i = 0,13 do
        if DoesExtraExist(veh,i) then
            if extras[i] then SetVehicleExtra(veh, i, extras[i])
            else SetVehicleExtra(veh, i, 1) end
        end
    end
end
local function TakeOutVehicle(data)
    local coords = QBCore.Shared.Jobs[PlayerJob.name].Locations.garages[data.currentSelection].spawnPoint
    if coords then
        QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
            data.netid = NetToVeh(netId)
            SetVehicleNumberPlateText(data.netid, QBCore.Shared.Jobs[PlayerJob.name].plate .. tostring(math.random(1000, 9999)))
            SetEntityHeading(data.netid, coords.w)
            exports[Config.qbjobs.fuel]:SetFuel(data.netid, 100.0)
            closeMenuFull()
            data.plate = QBCore.Functions.GetPlate(data.netid)
            if QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle] ~= nil then
                if QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras ~= nil then
                    vehicleExtras(data.netid, QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras)
			        --QBCore.Shared.SetDefaultVehicleExtras(data.netid, QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].extras)
    		    end
    		    if QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].livery ~= nil then
    		        SetVehicleLivery(data.netid, QBCore.Shared.Jobs[PlayerJob.name].VehicleSettings[data.vehicle].livery)
    		    end
            end
            TaskWarpPedIntoVehicle(PlayerPedId(), data.netid, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", data.plate)
            if QBCore.Shared.Jobs[PlayerJob.name].Items and (QBCore.Shared.Jobs[PlayerJob.name].Items.trunk or QBCore.Shared.Jobs[PlayerJob.name].Items.glovebox) then TriggerServerEvent("qb-jobs:server:addVehItems",data) end
            SetVehicleEngineOn(data.netid, true, true)
        end, data.vehicle, coords, true)
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
    if not QBCore.Shared.Jobs[playerJob].DutyBlips.enable then return end
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
    if not DoesBlipExist(blip) and QBCore.Shared.Jobs[playerJob].DutyBlips then
        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end
        SetBlipSprite(blip, QBCore.Shared.Jobs[playerJob].DutyBlips.blipSprite)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, QBCore.Shared.Jobs[playerJob].DutyBlips.blipScale)
        SetBlipColour(blip, QBCore.Shared.Jobs[playerJob].DutyBlips.blipSpriteColor)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        if QBCore.Shared.Jobs[playerJob].DutyBlips.type == "service" then DutyBlips[#DutyBlips+1] = blip
        elseif QBCore.Shared.Jobs[playerJob].DutyBlips.type == "public" then PublicBlips[#PublicBlips+1] = blip end
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
function AddJobs()
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
        CurrentJob()
        QBCore.Shared.Jobs = AddJobs()
        spawnPeds()
        setLocations()
    end)
end
local function setGaragesPageState(bool, message)
    if message then
        local action = bool and "open" or "close"
        SendNUIMessage({
            action = action
        })
    end
    SetNuiFocus(bool, bool)
    inGaragesPage = bool
    if not Config.UseTarget or bool then return false end
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
    kickOff()
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
RegisterNetEvent('qb-jobs:client:receiveGaragedVehicles', function(result)
    SendNUIMessage({
        action = 'setGaragedVehicles',
        jobs = result
    })
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
    for k,v in pairs(QBCore.Shared.Jobs) do
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
    exports['qb-clothing']:getOutfits(PlayerJob.grade.level, QBCore.Shared.Jobs[PlayerJob.name].Outfits)
end)
RegisterNetEvent("qb-jobs:client:VehicleMenuHeader", function (data)
    MenuGarage(data.currentSelection)
    currentGarage = data.currentSelection
end)
RegisterNetEvent('qb-jobs:client:TakeOutVehicle', function(data)
    if inGarage then
        TakeOutVehicle(data)
    end
end)
RegisterNetEvent('qb-jobs:client:addVehItems', function(data,items)
    if data.trunkItems then
        exports['qb-inventory']:addTrunkItems(QBCore.Functions.GetPlate(data.netid), items)
    end
    if data.gloveboxItems then
        exports['qb-inventory']:addGloveboxItems(QBCore.Functions.GetPlate(data.netid), items)
    end
end)
-- NUI Callbacks
RegisterNUICallback('close', function(_, cb)
    setGaragesPageState(false, false)
    if not Config.UseTarget and inRangeCityhall then exports['qb-core']:DrawText('[E] Open Cityhall') end -- Reopen interaction when you're still inside the zone
    cb('ok')
end)
RegisterNUICallback('setGaragedVehicles', function(id, cb)
    QBCore.Debug()
    if inRangeCityhall and license and id.cost == license.cost then
        TriggerServerEvent('qb-cityhall:server:requestId', id.type, closestCityhall)
        QBCore.Functions.Notify(('You have received your %s for $%s'):format(license.label, id.cost), 'success', 3500)
    else
        QBCore.Functions.Notify(Lang:t('error.not_in_range'), 'error')
    end
    cb('ok')
end)
RegisterNUICallback('requestLicenses', function(_, cb)
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = Config.Cityhalls[closestCityhall].licenses
    for license, data in pairs(availableLicenses) do
        if data.metadata and not licensesMeta[data.metadata] then
            availableLicenses[license] = nil
        end
    end
    cb(availableLicenses)
end)
RegisterNUICallback('applyJob', function(job, cb)
    if inRangeCityhall then
        TriggerServerEvent('qb-cityhall:server:ApplyJob', job, Config.Cityhalls[closestCityhall].coords)
    else
        QBCore.Functions.Notify(Lang:t('error.not_in_range'), 'error')
    end
    cb('ok')
end)
kickOff()