Config = {
    ["useTarget"] = GetConvar('UseTarget', 'false') == 'true',
    ["Jobs"] = {},
    ["duty"] = true, -- true = all players can use /duty | false = only admins can use /duty
    ["debugPoly"] = false, -- true = shows polyZone Aeas | false = hides polyZone areas
    ["fuel"] = "LegacyFuel",
    ["keys"] = "qb-vehiclekeys:server:AcquireVehicleKeys",
    ["hideAvailableJobs"] = true, -- true = does not display unworked jobs | false = displays unworked jobs.
    ["currencySymbol"] = "$", -- Sets the currency symbol.
    ["menu"] = {
        ["icons"] = {
            ["close"] = "fa-solid fa-x",
            ["retract"] = "fa-solid fa-angles-left",
            ["quit"] = "fa-regular fa-circle-xmark",
            ["hiredOn"] = "fa-solid fa-check-to-slot",
            ["available"] = "fa-solid fa-laptop-file",
            ["activate"] = "fa-solid fa-toggle-on",
        }
    }
}