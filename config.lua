Config = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
Config.Jobs = {}
Config.qbjobs = {
    ["duty"] = true, -- true = all players can use /duty | false = only admins can use /duty
    ["DebugPoly"] = false, -- true = shows polyZone Aeas | false = hides polyZone areas
    ["fuel"] = "LegacyFuel",
    ["keys"] = "qb-vehiclekeys:server:AcquireVehicleKeys",
    ["hideAvailableJobs"] = true -- true = does not display unworked jobs | false = displays unworked jobs.
}