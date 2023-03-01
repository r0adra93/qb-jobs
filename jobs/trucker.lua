--[[ Once hired the job will be assigned based on reputation ranking within the job. The higher the ranking the higher the promosion.]]--
local QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs or {}
Config.Jobs.trucker = {
    ["label"] = "Truck Driver",
    ["defaultDuty"] = true,
    ["offDutyPay"] = false,
    ["listInCityHall"] = true, -- true he job is sent to city hall | false the job is not in city hall
    ["plate"] = "CMRC", -- 4 Chars Max -- License Plate Prefix
    ["grades"] = {
        ['0'] = {
            ["name"] = "Class D Driver", -- Vans
            ["payment"] = 75,
            ["rep"] = 0
        },
        ['1'] = {
            ["name"] = "Class B Driver", -- Large Trucks
            ["payment"] = 100,
            ["rep"] = 20
        },
        ['2'] = {
            ["name"] = "Class B Driver + PS", -- Bus Driver
            ["payment"] = 125,
            ["rep"] = 40
        },
        ['3'] = {
            ["name"] = "Class A Driver + PS", -- Dry Van, Flat Bed, Refer and Buses
            ["payment"] = 125,
            ["rep"] = 60
        },
        ['4'] = {
            ["name"] = "Class A Driver + HNTPS", -- Any Commercial Vehicle including Tankers, Doubles / Triples
            ["payment"] = 150,
            ["rep"] = 80
        }
    },
    ["Locations"] = {
        ["duty"] = {
            [1] = {
                ["Label"] = "Trucker Timeclock",
                ["coords"] = vector3(-323.39, -129.6, 39.01),
                ["blipName"] = "Trucker Timeclock",
                ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 9, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.4, -- set the size of the blip on the full size map
                ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
                ["polyZone"] = {
                    ["drawDistance"] = 10.0,
                    ["drawColor"] = vector4(127,0,255,255), -- Red, Green, Blue, Transparency use RGB value here https://www.colorspire.com/rgb-color-wheel/
                    ["targetIcon"] = "fa fa-power-off", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["job"] = "job" -- type or job
                },
                ["marker"] = {
                    ["display"] = true, -- true = marker is displayed | false = marker is not displayed
                    ["type"] = 0, -- Choose from this list: https://docs.fivem.net/docs/game-references/markers/
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
        },
    }
}