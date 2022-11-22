-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local Plates = {}
local PlayerStatus = {}
local Objects = {}
local PlayerJob = {}
exports['qb-core']:AddJobs(Config.Jobs)
-- Functions
local function UpdateBlips()
    local dutyPlayers = {}
    local publicPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for _,v in pairs(players) do
        if Config.Jobs[v.PlayerData.job.name].DutyBlips then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            if Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "service" and v.PlayerData.job.onduty then
                dutyPlayers[#dutyPlayers+1] = {
                    ["source"] = v.PlayerData.source,
                    ["label"] = v.PlayerData.metadata["callsign"],
                    ["job"] = v.PlayerData.job.name,
                    ["location"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                        ["w"] = heading
                    }
                }
            elseif Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "public" then
                publicPlayers[#publicPlayers+1] = {
                    ["source"] = v.PlayerData.source,
                    ["label"] = v.PlayerData.metadata["callsign"],
                    ["job"] = v.PlayerData.job.name,
                    ["location"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                        ["w"] = heading
                    }
                }
            end
        end
    end
    TriggerClientEvent("qb-jobs:client:UpdateBlips", -1, dutyPlayers, publicPlayers)
end
local function AddJobs()
    exports['qb-core']:AddJobs(Config.Jobs)
    return Config.Jobs
end
exports('AddJobs',AddJobs)
local function SendToCityHall()
    for k,v in pairs(Config.Jobs) do
        if v.inCityHall then
            exports['qb-cityhall']:AddCityJob(k,v.label)
        end
    end
end
local function SetWeaponSeries()
    for k, v in pairs(Config.Jobs[PlayerJob.name].Items.armory.items) do
        if k < 6 then
            v.info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
        end
    end
end
local function SetCarItemsInfo(data)
	local items = {}
    local index = 1
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    if Config.Jobs[PlayerJob.name].Items[data.inv] then
	    for k,v in pairs(Config.Jobs[PlayerJob.name].Items[data.inv]) do
            for _,v1 in pairs(v.vehType) do
                if v1 == data.vehType then
                    for _,v2 in pairs(v.authGrade) do
                        if v2 == PlayerJob.grade.level then
                            local itemInfo = QBCore.Shared.Items[v.name:lower()]
                            items[index] = {
                                name = itemInfo["name"],
                                amount = tonumber(v.amount),
                                info = v.info,
                                label = itemInfo["label"],
                                description = itemInfo["description"] and itemInfo["description"] or "",
                                weight = itemInfo["weight"],
                                type = itemInfo["type"],
                                unique = itemInfo["unique"],
                                useable = itemInfo["useable"],
                                image = itemInfo["image"],
                                slot = index,
                            }
                            index = index + 1
                        end
                    end
                end
            end
	    end
    end
	return items
end
-- Events
RegisterNetEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
end)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'")
        end)
    end
end)
RegisterNetEvent('qb-jobs:server:Alert', function(text) -- Add alerts for other jobs
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
            local alertData = {title = Lang:t('info.new_call'), coords = {x = coords.x, y = coords.y, z = coords.z}, description = text}
            TriggerClientEvent("qb-phone:client:Alert", v.PlayerData.source, alertData)
            TriggerClientEvent('qb-jobs:client:Alert', v.PlayerData.source, coords, text)
        end
    end
end)
RegisterNetEvent('qb-jobs:server:buildJobs', function()
    AddJobs()
end)
RegisterNetEvent('qb-jobs:server:addVehItems', function(data)
    data.inv = "trunk"
    local trunkItems = SetCarItemsInfo(data)
    data.inv = "glovebox"
    local gloveboxItems = SetCarItemsInfo(data)
    if trunkItems then
        exports['qb-inventory']:addTrunkItems(data.plate, trunkItems)
    end
    if gloveboxItems then
        exports['qb-inventory']:addGloveboxItems(data.plate, gloveboxItems)
    end
end)
RegisterNetEvent('qb-jobs:server:openArmory', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    AddJobs()
    local index = 1
    local inv = {
        label = Config.Jobs[PlayerJob.name].Items.armory.label,
        slots = 30,
        items = {}
    }
    for _,v in pairs(Config.Jobs[PlayerJob.name].Items.armory.items) do
        for _, v1 in pairs(v.authorizedJobGrades) do
            if v1 == PlayerJob.grade.level then
                inv.items[index] = v
                inv.items[index].slot = index
                index = index + 1
            end
        end
    end
    SetWeaponSeries()
    exports['qb-inventory']:OpenInventory("shop", PlayerJob.name, inv, src)
end)
RegisterNetEvent("qb-jobs:server:openStash", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    exports['qb-inventory']:OpenInventory("stash", PlayerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid, false, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", PlayerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid)
end)
RegisterNetEvent('qb-jobs:server:openTrash', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    local options = {
        maxweight = 4000000,
        slots = 300
    }
    exports['qb-inventory']:OpenInventory("stash", PlayerJob.name..Lang:t('headings.trash')..player.PlayerData.citizenid, options, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", PlayerJob.name..Lang:t('headings.trash')..player.PlayerData.citizenid)
end)
RegisterNetEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
    QBCore = exports['qb-core']:GetCoreObject()
end)
RegisterNetEvent('qb-jobs:server:vehMenuBuilder', function()
end)
RegisterNetEvent('qb-jobs:server:sendGaragedVehicles', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    local vehList = {}
    vehList.vehicles = {}
    vehList.header = Config.Jobs[PlayerJob.name].label .. Lang:t('headings.garages')
    local index = {}
    index.boat = 1
    index.helicopter = 1
    index.plane = 1
    index.vehicle = 1
    for k,v in pairs(Config.Jobs[PlayerJob.name].Vehicles[PlayerJob.grade.level]) do
        vehList.vehicles[v.type] = {
            [index[v.type]] = {
                ["spawn"] = k,
                ["label"] = v.label,
                ["icon"] = v.icon
            }
        }
        index[v.type] += 1
    end
    vehList = json.encode(vehList)
    QBCore.Debug(vehList)
    TriggerClientEvent('qb-jobs:client:receiveGaragedVehicles',-1,vehList)
end)
-- Callbacks
-- Commands
QBCore.Commands.Add("duty", Lang:t("commands.duty"), {}, false, function()
    TriggerClientEvent('qb-jobs:client:ToggleDuty',-1)
end)
-- Threads
CreateThread(function()
    AddJobs()
    SendToCityHall()
end)
CreateThread(function()
    while true do
        Wait(5000)
        local players = QBCore.Functions.GetQBPlayers()
        if players and players ~= nil then
            UpdateBlips()
        end
    end
end)