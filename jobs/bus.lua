local QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs or {}
Config.Jobs.bus = {
    ["label"] = "Bus Driver",
    ["defaultDuty"] = true,
    ["offDutyPay"] = false,
    ["inCityHall"] = true, -- true lists job inside city hall
    ["plate"] = "OMNI", -- 4 Chars Max -- License Plate Prefix
    ["grades"] = {
        ['0'] = {
            ["name"] = "Driver",
            ["payment"] = 50
        }
    },
    ["Locations"] = {
        ["garages"] = {
            [1] = {
                ["label"] = "Bus Terminal",
                ["type"] = "vehicle", -- vehicle, boat, plane, helicopter
                ["takeVehicle"] = vector4(462.22, -641.15, 28.45, 175.0),
                ["spawnPoint"] = vector4(462.22, -641.15, 28.45, 175.0),
                ["putVehicle"] = vector4(462.22, -641.15, 28.45, 175.0),
                ["blipName"] = "Bus Terminal",
                ["blipNumber"] = 513, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.6, -- set the size of the blip on the full size map
                ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
                ["marker"] = {
                    ["display"] = true, -- true = marker is displayed | false = marker is not displayed
                    ["type"] = 39, -- Choose from this list: https://docs.fivem.net/docs/game-references/markers/
                    ["scale"] = 0.5, -- Sets the size of the marker
                    ["red"] = 255, -- digits 0 to 255 | use R value here https://www.colorspire.com/rgb-color-wheel/
                    ["green"] = 127, -- digits 0 to 255 | use G value here https://www.colorspire.com/rgb-color-wheel/
                    ["blue"] = 0, -- digits 0 to 255 | use B value here https://www.colorspire.com/rgb-color-wheel/
                    ["alpha"] = 255,  -- sets how transparent the marker is. 0 completely transparent 255 not transparent at all
                    ["bob"] = true, -- true marker bounces up and down | false marker does not bounce up and down
                    ["rotate"] = true, -- true marker spins | false marker does not spin
                    ["ents"] = true -- true marker appears over entities | false marker is hidden when entities are around
                }
            }
        }
    },
    ["Vehicles"] = {
        [0] = { -- Job Rank ID
            ["bus"] = { -- Spawn Code
                ["label"] = "Public Bus", -- Label for Spawner
                ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
            }
        }
    },
    ["VehicleSettings"] = {
        ["bus"] = { -- Spawn name
            ["extras"] = {
                [1] = 0, -- 0 = On | 1 = Off
                [2] = 0,
                [3] = 0,
                [4] = 0,
                [5] = 0,
                [6] = 0,
                [7] = 0,
                [8] = 0,
                [9] = 0,
                [10] = 0,
                [11] = 0,
                [12] = 0,
                [13] = 0
            },
            ["livery"] = 0 -- First Livery Starts At 0
        }
    },
}
