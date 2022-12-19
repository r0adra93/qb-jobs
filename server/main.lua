-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob
local vehCount = {}
local vehTrack = {}
exports['qb-core']:AddJobs(Config.Jobs)
-- Functions
local function countVehPop()
    for k in pairs(Config.Jobs) do
        vehCount[k] = 0
    end
end
local function updateBlips()
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
    TriggerClientEvent("qb-jobs:client:updateBlips", -1, dutyPlayers, publicPlayers)
end
local function populateJobs()
    for k,v in pairs(Config.Jobs) do
        TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, "Jobs", k, v)
    end
end
exports('populateJobs',populateJobs)
local function sendToCityHall()
    for k,v in pairs(Config.Jobs) do
        if v.inCityHall then
            exports['qb-cityhall']:AddCityJob(k,v.label)
        end
    end
end
local function verifySociety()
    local bossList = {}
    local bossMenu = MySQL.query.await('SELECT `job_name` AS "jobName" FROM `management_funds` WHERE type = "boss"', {})
    for _,v in pairs(bossMenu) do bossList[v.jobName] = v.jobName end
    for k in pairs(Config.Jobs) do
        if not bossList[k] then
            MySQL.query.await("INSERT INTO `management_funds` (`job_name`,`amount`,`type`) VALUES (?,0,'boss')", {k})
        end
    end
end
local function sendToCustoms()
    local data = {}
    for k,v in pairs(Config.Jobs) do
        data[k] = v.MotorworksConfig
    end
    exports["qb-customs"]:buildLocations(data)
end
local function kickOff()
    CreateThread(function()
        countVehPop()
        populateJobs()
        sendToCityHall()
        verifySociety()
        sendToCustoms()
    end)
    CreateThread(function()
        while true do
            Wait(5000)
            updateBlips()
        end
    end)
end
-- Events
RegisterServerEvent('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'")
        end)
    end
end)
RegisterServerEvent('QBCore:Client:OnPlayerLoaded', function()
    kickOff()
end)
RegisterServerEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
end)
RegisterServerEvent('qb-jobs:server:Alert', function(text) -- Add alerts for other jobs
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
RegisterServerEvent('qb-jobs:server:populateJobs', function()
    populateJobs()
end)
RegisterServerEvent('qb-jobs:server:addVehItems', function(data)
    local function SetCarItemsInfo(data)
        local items = {}
        local index = 1
        local player = QBCore.Functions.GetPlayer(source)
        if not player then return false end
        PlayerJob = player.PlayerData.job
        if Config.Jobs[PlayerJob.name].Items[data.inv] then
            for _,v in pairs(Config.Jobs[PlayerJob.name].Items[data.inv]) do
                local vehType = false
                local authGrade = false
                for _,v1 in pairs(v.vehType) do
                    if v1 == Config.Jobs[PlayerJob.name].Vehicles[data.vehicle].type then
                        vehType = true
                    end
                end
                for _,v1 in pairs(v.authGrade) do
                    if v1 == PlayerJob.grade.level then
                        authGrade = true
                    end
                end
                if vehType and authGrade then
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
        return items
    end
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
RegisterServerEvent('qb-jobs:server:openArmory', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    populateJobs()
    local index = 1
    local inv = {
        label = Config.Jobs[PlayerJob.name].Items.armoryLabel,
        slots = 30,
        items = {}
    }
    local items = Config.Jobs[PlayerJob.name].Items.items
    for key = 1, #items do
        for key2 = 1, #items[key].authorizedJobGrades do
            for key3 = 1, #items[key].locations do
                if items[key].locations[key3] == "armory" and items[key].authorizedJobGrades[key2] == PlayerJob.grade.level then
                    if items[key].type == "weapon" then items[key].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4)) end
                    inv.items[index] = items[key]
                    inv.items[index].slot = index
                    index = index + 1
                end
            end
        end
    end
    exports['qb-inventory']:OpenInventory("shop", PlayerJob.name, inv, src)
end)
RegisterServerEvent("qb-jobs:server:openStash", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    exports['qb-inventory']:OpenInventory("stash", PlayerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid, false, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", PlayerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid)
end)
RegisterServerEvent('qb-jobs:server:openTrash', function()
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
-- Initilizes the Vehicle Tracker for the client.
RegisterServerEvent('qb-jobs:server:initilizeVehicleTracker', function()
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    vehTrack = {[player.PlayerData.citizenid] = {}}
end)
--- adds vehicles to job total
RegisterServerEvent('qb-jobs:server:addVehicle', function()
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    vehCount[PlayerJob.name] += 1
end)
-- Deletes Vehicle from the server
RegisterServerEvent("qb-jobs:server:deleteVehicleProcess", function(result)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local citid = player.PlayerData.citizenid
    if vehTrack[citid] and vehTrack[citid][result.plate] and vehTrack[citid][result.plate].selGar == "motorpool" and DoesEntityExist(NetworkGetEntityFromNetworkId(vehTrack[citid][result.plate].veh)) then
        if not result.noRefund and player.Functions.AddMoney("cash", Config.Jobs[PlayerJob.name].Vehicles[result.vehicle].depositPrice, PlayerJob.name .. Lang:t("success.depositFeesPaid", {value = Config.Jobs[PlayerJob.name].Vehicles[result.vehicle].depositPrice})) then
            TriggerClientEvent('QBCore:Notify', source, Lang:t("success.depositReturned", {value = Config.Jobs[PlayerJob.name].Vehicles[result.vehicle].depositPrice}), "success")
            TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Refund Deposit Success', 'green', string.format('%s received a refund of %s for returned vehicle!', GetPlayerName(source),Config.Jobs[PlayerJob.name].Vehicles[result.vehicle].depositPrice))
            exports['qb-management']:RemoveMoney(PlayerJob.name, Config.Jobs[PlayerJob.name].Vehicles[result.vehicle].depositPrice)
        end
    else
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Fake Refund Attempt', 'red', string.format('%s attempted to obtain a refund for returned vehicle!', GetPlayerName(source)))
    end
    vehCount[PlayerJob.name] -= 1
    vehTrack[citid][result.plate] = nil
end)
-- Callbacks
--- Verifies the vehicle count
QBCore.Functions.CreateCallback("qb-jobs:server:verifyMaxVehicles", function(source,cb)
    local test = true
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then cb(false) end
    local PlayerJob = player.PlayerData.job
    if Config.Jobs[PlayerJob.name].VehicleConfig.maxVehicles > 0 and Config.Jobs[PlayerJob.name].VehicleConfig.maxVehicles <= vehCount[PlayerJob.name] then
        QBCore.Functions.Notify(Lang:t("info.vehicleLimitReached"))
        test = false
    end
    cb(test)
end)
--- Processes Vehicles to be issued
QBCore.Functions.CreateCallback("qb-jobs:server:spawnVehicleProcessor", function(source,cb,result)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local PlayerJob = player.PlayerData.job
    local vehicle = result.vehicle
    local selGar = result.selGar
    local total = 0
    local message = {}
    local jobStore
    result.source = source
    result.player = player
    if selGar == "ownGarage" then
        if Config.Jobs[PlayerJob.name].VehicleConfig.ownedParkingFee and Config.Jobs[PlayerJob.name].Vehicles[vehicle].parkingPrice then
            total += Config.Jobs[PlayerJob.name].Vehicles[vehicle].parkingPrice
            message.msg = Lang:t("success.parkingFeesPaid",{value = Config.Jobs[PlayerJob.name].Vehicles[vehicle].parkingPrice})
        end
    elseif selGar == "jobStore" then
        jobStore = exports['qb-vehicleshop']:BuyJobsVehicle(result)
        if not jobStore  then cb(false) end
    elseif selGar == "motorpool" then
        if Config.Jobs[PlayerJob.name].VehicleConfig.rentalFees and Config.Jobs[PlayerJob.name].Vehicles[vehicle].rentPrice then
            total += Config.Jobs[PlayerJob.name].Vehicles[vehicle].rentPrice
            message.rent = Lang:t("success.rentalFeesPaid",{value = Config.Jobs[PlayerJob.name].Vehicles[vehicle].rentPrice})
        end
        if Config.Jobs[PlayerJob.name].VehicleConfig.depositFees and Config.Jobs[PlayerJob.name].Vehicles[vehicle].depositPrice then
            total += Config.Jobs[PlayerJob.name].Vehicles[vehicle].depositPrice
            message.deposit = Lang:t("success.depositFeesPaid",{value = Config.Jobs[PlayerJob.name].Vehicles[vehicle].depositPrice})
        end
        if message.rent and message.deposit then message.msg = message.rent .. " " .. message.deposit
        elseif message.rent then message.msg = message.rent
        elseif message.deposit then message.msg = message.deposit end
    else
        TriggerClientEvent('QBCore:Notify', source, Lang.t("denied.invalidGarage"), "denied")
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Intrusion Attempted', 'red', string.format('%s attempted to obtain a vehicle!', GetPlayerName(source)))
        return false
    end
    if total > 0 then
        if not player.Functions.RemoveMoney("bank", total, message.msg) then
            if not player.Functions.RemoveMoney("cash", total, message.msg) then
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_enough", {value = total}), "error")
                return false
            end
        end
        exports['qb-management']:AddMoney(PlayerJob.name, total)
    end
    TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Money Received!', 'green', string.format('%s received money!', GetPlayerName(source)))
    if(not vehTrack[player.PlayerData.citizenid]) then vehTrack[player.PlayerData.citizenid] = {} end
    vehTrack[player.PlayerData.citizenid][result.plate] = {
        ["veh"] = result.veh,
        ["netid"] = result.netid,
        ["vehicle"] = vehicle,
        ["selGar"] = selGar
    }
    cb(true)
end)
--- Creates plates and ensures they are not in-use
QBCore.Functions.CreateCallback("qb-jobs:server:vehiclePlateCheck", function(source,cb,res)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local PlayerJob = player.PlayerData.job
    local plate, vehProps
    local ppl = string.len(Config.Jobs[PlayerJob.name].VehicleConfig.plate)
    if ppl > 4 then
        print(color.bg.red .. color.fg.white .. "Your plate prefix is " .. ppl .. " must be less than 4 chracters at: qb-jobs > config.lua > Jobs > " .. PlayerJob.name .. " > VehicleConfig > Plate")
        cb(false)
    end
    if ppl == 4 then
        res.min = 1000
        res.max = 9999
    elseif ppl == 3 then
        res.min = 10000
        res.max = 99999
    elseif ppl == 2 then
        res.min = 100000
        res.max = 999999
    elseif ppl == 1 then
        res.min = 1000000
        res.max = 9999999
    else
        plate = exports["qb-vehicleshop"]:GeneratePlate()
    end
    if not plate then
        res.platePrefix = Config.Jobs[PlayerJob.name].VehicleConfig.plate
        res.vehTrack = vehTrack[player.PlayerData.citizenid]
        plate = exports["qb-vehicleshop"]:JobsPlateGen(res)
    end
    if res.selGar == "ownGarage" then
        local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
        if result[1] then vehProps = json.decode(result[1].mods) end
    end
    cb(plate, vehProps)
end)
--- Generates list to populate the vehicle selector menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendGaragedVehicles', function(source,cb,data)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    PlayerJob = player.PlayerData.job
    local vehShort, queryResult
    local vehList = {
        ["vehicles"] = {},
        ["vehiclesForSale"] = {},
        ["ownedVehicles"] = {},
    }
    local typeList = {}
    local index = {
        ["boat"] = 1,
        ["helicopter"] = 1,
        ["plane"] = 1,
        ["vehicle"] = 1
    }
    vehList.colors = Config.Jobs[PlayerJob.name].uiColors
    vehList.label = Config.Jobs[PlayerJob.name].label
    vehList.icons = Config.Jobs[PlayerJob.name].VehicleConfig.icons
    vehList.garage = data
    vehList.header = Config.Jobs[PlayerJob.name].label .. Lang:t('headings.garages')
    for _,v in pairs(Config.Jobs[PlayerJob.name].Locations.garages[data].spawnPoint) do
        typeList[v.type] = true
    end
    for k,v in pairs(Config.Jobs[PlayerJob.name].Vehicles) do
        if(v.authGrades[PlayerJob.grade.level] and typeList[v.type]) then
            vehList.vehicles[v.type] = {
                [index[v.type]] = {
                    ["spawn"] = k,
                    ["label"] = v.label,
                    ["icon"] = v.icon,
                }
            }
            if Config.Jobs[PlayerJob.name].VehicleConfig.depositFees then vehList.vehicles[v.type][index[v.type]].depositPrice = v.depositPrice  end
            if Config.Jobs[PlayerJob.name].VehicleConfig.rentalFees then vehList.vehicles[v.type][index[v.type]].rentPrice = v.rentPrice  end
            if v.purchasePrice and Config.Jobs[PlayerJob.name].VehicleConfig.allowPurchase then
                vehList.vehicles[v.type][index[v.type]].purchasePrice = v.purchasePrice
                vehList.vehiclesForSale[v.type] = {
                    [index[v.type]] = {
                        ["spawn"] = k,
                        ["label"] = v.label,
                        ["icon"] = v.icon,
                        ["purchasePrice"] = v.purchasePrice
                    }
                }
            end
            if v.parkingPrice and Config.Jobs[PlayerJob.name].VehicleConfig.allowPurchase and Config.Jobs[PlayerJob.name].VehicleConfig.ownedParkingFee then
                vehList.vehicles[v.type][index[v.type]].parkingPrice = v.parkingPrice
                vehList.vehiclesForSale[v.type][index[v.type]].parkingPrice = v.parkingPrice
            end
            index[v.type] += 1
        end
    end
    index.boat = 1
    index.helicopter = 1
    index.plane = 1
    index.vehicle = 1
    if Config.Jobs[PlayerJob.name].VehicleConfig.ownedVehicles then
        vehList.allowPurchase = true
    end
    queryResult = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles WHERE citizenid = ? AND (state = ?) AND job = ?', {player.PlayerData.citizenid, 0, PlayerJob.name}, function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    for _, v in pairs(queryResult) do
        vehShort = Config.Jobs[PlayerJob.name].Vehicles[v.vehicle]
        if(vehShort.authGrades[PlayerJob.grade.level] and typeList[vehShort.type]) then
            if not vehList.ownedVehicles[vehShort.type] then vehList.ownedVehicles[vehShort.type] = {} end
            vehList.ownedVehicles[vehShort.type][index[vehShort.type]] = {
                ["plate"] = v.plate,
                ["spawn"] = v.vehicle,
                ["label"] = Config.Jobs[PlayerJob.name].Vehicles[v.vehicle].label,
                ["icon"] = Config.Jobs[PlayerJob.name].Vehicles[v.vehicle].icon
            }
            if(vehShort.parkingPrice) then vehList.ownedVehicles[vehShort.type][index[vehShort.type]].parkingPrice = vehShort.parkingPrice end
            index[vehShort.type] += 1
        end
    end
    cb(vehList)
end)
--- Generates list to populate the Management menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendManagementData', function(source,cb,data)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local PlayerJob = player.PlayerData.job
    local btnList = {}
    local jobsList = {}
    local queryResult = MySQL.query.await('SELECT citizenid AS citid, job FROM players', function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    if queryResult then
        for _,v in pairs(queryResult) do
            for _,v1 in pairs(JSON.decode(v.job)) do
                if v1.name then
                    if v1.name == PlayerJob.name then jobsList[v.citid] = v.job end
                else
                    for _,v2 in pairs(v1) do
                        if v2.name == PlayerJob.name then jobsList[v.citid] = v.job end
                    end
                end
            end
        end
        QBCore.Debug(jobsList)
    end
    cb(btnList)
end)
-- Commands
QBCore.Commands.Add("duty", Lang:t("commands.duty"), {}, false, function()
    TriggerClientEvent('qb-jobs:client:toggleDuty',-1)
end)
kickOff()