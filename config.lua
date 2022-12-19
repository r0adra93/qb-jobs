Config = {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
Config.Jobs = {}
Config.qbjobs = {}
Config.qbjobs.duty = true -- true = all players can use /duty | false = only admins can use /duty
Config.qbjobs.DebugPoly = false -- true = shows polyZone Aeas | false = hides polyZone areas
Config.qbjobs.fuel = "LegacyFuel"