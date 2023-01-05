local QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs or {}
Config.Jobs.unemployed = {
    ["label"] = "Civilian",
    ["defaultDuty"] = true,
    ["offDutyPay"] = false,
    ["inCityHall"] = {
        ["listInCityHall"] = false, -- true he job is sent to city hall | false the job is not in city hall
        ["isManaged"] = true -- true the job is sent to the boss of the job | false the job is automatically assigned
    },

    ["grades"] = {
        ['0'] = {
            ["name"] = "freelancer",
            ["payment"] = 50
        }
    }
}