Config = {
    ["useTarget"] = GetConvar('UseTarget', 'false') == 'true',
    ["Jobs"] = {},
    ["Gangs"] = {},
    ["multiJobKey"] = "j", -- choose key to activate multi-job menu
    ["duty"] = "user", -- user, admin, god
    ["debugPoly"] = true, -- true = shows polyZone Aeas | false = hides polyZone areas
    ["fuel"] = "LegacyFuel",
    ["keys"] = "qb-vehiclekeys:server:AcquireVehicleKeys",
    ["hideAvailableJobs"] = true, -- true = does not display unworked jobs | false = displays unworked jobs.
    ["currencySymbol"] = "$", -- Sets the currency symbol.
    ["menu"] = {
        ["headerMultiJob"] = "Multi-Job Menu",
        ["icons"] = {
            ["close"] = "fa-solid fa-x",
            ["retract"] = "fa-solid fa-angles-left",
            ["quit"] = "fa-regular fa-circle-xmark",
            ["hiredOn"] = "fa-solid fa-check-to-slot",
            ["available"] = "fa-solid fa-laptop-file",
            ["activate"] = "fa-solid fa-toggle-on",
            ["apply"] = "fa-regular fa-clipboard",
            ["active"] = "fa-solid fa-land-mine-on",
            ["pending"] = "fa-solid fa-file-circle-question"
        }
    }
}