local QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs or {}
Config.Jobs.unemployed = {
    ["label"] = "Civilian",
    ["defaultDuty"] = true,
    ["offDutyPay"] = false,
    ["inCityHall"] = false, -- true lists job inside city hall
    ["grades"] = {
        ['0'] = {
            ["name"] = "freelancer",
            ["payment"] = 50
        }
    }
}