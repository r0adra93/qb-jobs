local QBCore = exports['qb-core']:GetCoreObject()
Config.Jobs = Config.Jobs or {}
Config.Jobs.ambulance = { -- name the job
    ["label"] = "Medical Services", -- label that display when typing in /job
    ["type"] = "ems", -- job type -- leave set to ems as it's part of the ambulancejob
    ["defaultDuty"] = true, -- duty status when logged on
    ["offDutyPay"] = false, -- true get paid even off duty
    ["inCityHall"] = false, -- true lists job inside city hall
    ["vehicle"] = {
        ["plate"] = "EMS", -- 4 Chars Max -- License Plate Prefix
        ["assignVehicles"] = true, -- true = the player may only have one vehicle | false = the player may have more than one vehicle.
        ["assigned"] = "unassigned" -- leave unassigned this variable will be assigned the id of the vehcile assigned to the driver.
    },
    ["DutyBlips"] = {
        ["enable"] = true, -- Enables the Duty Blip
        ["type"] = "public", -- Service = Only for service members to view or Public for all people to view
        ["blipSprite"] = 1, -- https://docs.fivem.net/docs/game-references/blips/#blips
        ["blipSpriteColor"] = 5, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
        ["blipScale"] = 1, -- Size of the Blip on the minimap
    },
    ["grades"] = {
        ['0'] = {
            ["name"] = 'Recruit',
            ["payment"] = 180
        },
        ['1'] = {
            ["name"] = 'Paramedic',
            ["payment"] = 240
        },
        ['2'] = {
            ["name"] = 'Nurse',
            ["payment"] = 273
        },
        ['3'] = {
            ["name"] = 'Doctor',
            ["payment"] = 684
        },
        ['4'] = {
            ["name"] = 'Surgeon',
            ["payment"] = 2191
        },
        ['5'] = {
            ["name"] = 'Chief of Staff',
            ["payment"] = 2739,
            ["isboss"] = true
        }
    },
    ["Locations"] = {
        ["duty"] = {
            [1] = {
                ["Label"] = "Hospital Timeclock", -- Label of the timeclock
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(326.72, -583.02, 43.32, 345.98),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "4",
                        ["width"] = "2"
                    }
                },
                ["blipName"] = "Hospital Timeclock",
                ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.4, -- set the size of the blip on the full size map
                ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
            }
        },
        ["management"] = {
            [1] = {
                ["Label"] = "Medical Management",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(324.33, -582.2, 43.32, 345.98),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "4",
                        ["width"] = "2"
                    }
                },
                ["blipName"] = "Medical Management",
                ["blipNumber"] = 793, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 39, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 5, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.4, -- set the size of the blip on the full size map
                ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
            }
        },
        ["garages"] = {
            [1] = {
                ["label"] = "Hospital Garage - Pillbox",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(305.0, -598.41, 43.29, 77),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "4",
                        ["width"] = "4"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(292.02, -569.36, 42.91, 56.58), -- spawn vehicle locations
                        ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
                    },
                    [1] = {
                        ["coords"] = vector4(296.72, -575.61, 42.92, 11.67),
                        ["type"] = "vehicle"
                    },
                    [2] = {
                        ["coords"] = vector4(296.32, -583.68, 42.92, 340.94),
                        ["type"] = "vehicle"
                    },
                    [3] = {
                        ["coords"] = vector4(293.56, -591.24, 42.86, 341.41),
                        ["type"] = "vehicle"
                    },
                    [4] = {
                        ["coords"] = vector4(290.63, -599.41, 42.91, 335.64),
                        ["type"] = "vehicle"
                    },
                    [5] = {
                        ["coords"] = vector4(285.67, -605.84, 42.93, 301.75),
                        ["type"] = "vehicle"
                    },
                    [6] = {
                        ["coords"] = vector4(277.29, -608.74, 42.76, 277.89),
                        ["type"] = "vehicle"
                    },
                    [7] = {
                        ["coords"] = vector4(352.27, -587.93, 74.17, 91.02),
                        ["type"] = "helicopter"
                    }
                },
                ["blipName"] = "Hospital Garage",
                ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.6, -- set the size of the blip on the full size map
                ["blipShortRange"] = true -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
            },
            [2] = {
                ["label"] = "Hospital Garage - Paleto Bay",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(-251.38, 6338.43, 32.49, 37.65),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(-257.96, 6347.63, 32.2, 269.57), -- spawn vehicle locations
                        ["type"] = "vehicle" -- vehicle, boat, plane, helicopter
                    },
                    [1] = {
                        ["coords"] = vector4(-261.48, 6344.16, 32.2, 268.59),
                        ["type"] = "vehicle"
                    },
                    [2] = {
                        ["coords"] = vector4(-264.61, 6340.94, 32.2, 271.83),
                        ["type"] = "vehicle"
                    },
                    [3] = {
                        ["coords"] = vector4(-268.09, 6337.3, 32.2, 268.01),
                        ["type"] = "vehicle"
                    },
                    [4] = {
                        ["coords"] = vector4(-271.67, 6333.82, 32.2, 269.64),
                        ["type"] = "vehicle"
                    },
                    [5] = {
                        ["coords"] = vector4(-274.83, 6330.76, 32.2, 271.92),
                        ["type"] = "vehicle"
                    },
                    [6] = {
                        ["coords"] = vector4(-277.81, 6327.54, 32.2, 263.53),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Garage",
                ["blipNumber"] = 357, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 81, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.6, -- set the size of the blip on the full size map
                ["blipShortRange"] = true -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
            },
            [3] = {
                ["label"] = "Hospital Hanger LosSantos Airport",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(-1232.29, -2809.43, 13.95, 222.26),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(-1221.33, -2946.33, 14.29, 247.66),
                        ["type"] = "plane"
                    },
                    [1] = {
                        ["coords"] = vector4(-1131.8, -2998.63, 14.29, 239.33),
                        ["type"] = "plane"
                    },
                    [2] = {
                        ["coords"] = vector4(-1131.8, -2998.63, 14.29, 239.33),
                        ["type"] = "plane"
                    },
                    [3] = {
                        ["coords"] = vector4(-1177.39, -2844.51, 13.95, 153.61),
                        ["type"] = "helicopter"
                    },
                    [4] = {
                        ["coords"] = vector4(-1146.06, -2864.38, 13.95, 153.35),
                        ["type"] = "helicopter"
                    },
                    [5] = {
                        ["coords"] = vector4(-1111.6, -2882.67, 13.95, 154.89),
                        ["type"] = "helicopter"
                    },
                    [6] = {
                        ["coords"] = vector4(-1204.88, -2815.36, 13.72, 241.89),
                        ["type"] = "vehicle"
                    },
                    [7] = {
                        ["coords"] = vector4(-1201.78, -2808.47, 13.72, 244.87),
                        ["type"] = "vehicle"
                    },
                    [8] = {
                        ["coords"] = vector4(-1216.67, -2823.85, 13.72, 181.4),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Hanger",
                ["blipNumber"] = 359,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            },
            [4] = {
                ["label"] = "Hospital Hanger Grapeseed",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(2120.9, 4784.06, 40.97, 297.55),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(2133.74, 4807.58, 41.72, 115.16),
                        ["type"] = "plane"
                    },
                    [1] = {
                        ["coords"] = vector4(2133.74, 4807.58, 41.72, 115.16),
                        ["type"] = "helicopter"
                    },
                    [2] = {
                        ["coords"] = vector4(2136.61, 4798.74, 40.91, 25.93),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Hanger",
                ["blipNumber"] = 359,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            },
            [5] = {
                ["label"] = "Hospital Hanger Sandy Shores",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(1720.09, 3287.05, 41.53, 185.75),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(1710.97, 3252.41, 41.69, 105.83),
                        ["type"] = "plane"
                    },
                    [1] = {
                        ["coords"] = vector4(1770.41, 3239.77, 42.52, 101.73),
                        ["type"] = "helicopter"
                    },
                    [2] = {
                        ["coords"] = vector4(1748.53, 3293.51, 40.88, 195.15),
                        ["type"] = "vehicle"
                    },
                    [3] = {
                        ["coords"] = vector4(1726.8, 3287.29, 40.9, 200.19),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Hanger",
                ["blipNumber"] = 359,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            },
            [6] = {
                ["label"] = "Hospital Boatlaunch Alamo Sea",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(1302.96, 4226.23, 33.91, 353.23),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(1293.24, 4222.41, 30.8, 174.57),
                        ["type"] = "boat"
                    },
                    [1] = {
                        ["coords"] = vector4(1302.1, 4323.88, 38.09, 298.3),
                        ["type"] = "vehicle"
                    },
                    [2] = {
                        ["coords"] = vector4(1310.47, 4309.0, 37.6, 356.87),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Boatlaunch",
                ["blipNumber"] = 356,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            },
            [7] = {
                ["label"] = "Hospital Boatlaunch Los Santos",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(-784.0, -1356.02, 5.15, 236.42),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(-761.98, -1373.05, 0.1, 231.48),
                        ["type"] = "boat"
                    },
                    [2] = {
                        ["coords"] = vector4(-802.86, -1321.46, 4.77, 171),
                        ["type"] = "vehicle"
                    },
                    [3] = {
                        ["coords"] = vector4(-805.91, -1321.46, 4.77, 171),
                        ["type"] = "vehicle"
                    },
                    [4] = {
                        ["coords"] = vector4(-809.42, -1321.46, 4.77, 171),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Boatlaunch",
                ["blipNumber"] = 356,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            },
            [8] = {
                ["label"] = "Hospital Boatlaunch Paleto Cove",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01",
                    ["coords"] = vector4(-1598.24, 5188.34, 4.31, 306.23),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["spawnPoint"] = {
                    [0] = {
                        ["coords"] = vector4(-1603.61, 5260.97, 0.29, 22.87),
                        ["type"] = "boat"
                    },
                    [1] = {
                        ["coords"] = vector4(-1573.75, 5167.36, 19.32, 139.75),
                        ["type"] = "vehicle"
                    },
                    [2] = {
                        ["coords"] = vector4(-1577.79, 5171.09, 19.34, 139.27),
                        ["type"] = "vehicle"
                    }
                },
                ["blipName"] = "Hospital Boatlaunch",
                ["blipNumber"] = 356,
                ["blipColor"] = 81,
                ["blipDisplay"] = 4,
                ["blipScale"] = 0.6,
                ["blipShortRange"] = true
            }
        },
        ["stashes"] = {
            [1] = {
                ["label"] = "Hospital Locker - Pillbox",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(316.97, -583.32, 43.28, 251.62),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["blipName"] = "Medical Locker",
                ["blipNumber"] = 187,
                ["blipColor"] = 81,
                ["blipDisplay"] = 5,
                ["blipScale"] = 0.4,
                ["blipShortRange"] = true
            }
        },
        ["armories"] = {
            [1] = {
                ["label"] = "Hospital Supplies - Pillbox",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(309.76, -603.13, 43.29, 77),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["blipName"] = "Hospital Supplies",
                ["blipNumber"] = 187,
                ["blipColor"] = 81,
                ["blipDisplay"] = 5,
                ["blipScale"] = 0.4,
                ["blipShortRange"] = true
            }
        },
        ["trash"] = {
            [1] = {
                ["label"] = "Hospital Trash - Pillbox",
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(301.44, -580.94, 43.29, 188.55),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["blipName"] = "Hospital Trash",
                ["blipNumber"] = 728,
                ["blipColor"] = 81,
                ["blipDisplay"] = 5,
                ["blipScale"] = 0.4,
                ["blipShortRange"] = true,
            }
        },
        ["stations"] = {
            [1] = {
                ["label"] = "Hospital - Pillbox",
                ["public"] = true, -- true station is displayed for all players | false = station is displayed just for the player
                ["coords"] = vector4(304.27, -600.33, 43.28, 272.249),
                ["blipName"] = "Hospital",
                ["blipNumber"] = 61, -- https://docs.fivem.net/docs/game-references/blips/#blips
                ["blipColor"] = 3, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors
                ["blipDisplay"] = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
                ["blipScale"] = 0.6, -- set the size of the blip on the full size map
                ["blipShortRange"] = true, -- true or false true only displays on minimap when player is close false always displays on the minimap no matter the distance
            }
        },
        ["outfits"] = {
            [1] = {
                ["jobType"] = "ems",
                ["isGang"] = false,
                ["ped"] = {
                    ["model"] = "s_f_y_scrubs_01", -- Model name from https://docs.fivem.net/docs/game-references/ped-models/
                    ["coords"] = vector4(342.72, -586.45, 43.32, 346.32),
                    ["targetIcon"] = "fas fa-sign-in-alt", -- Font Awesome Icon https://fontawesome.com/v4/icons/
                    ["drawDistance"] = 2.0,
                    ["zoneOptions"] = {
                        ["length"] = "2",
                        ["width"] = "2"
                    }
                },
                ["width"] = 2,
                ["length"] = 2,
                ["cameraLocation"] = vector4(342.72, -586.45, 43.32, 346.32),
                ["blipName"] = "Medical Clothing",
                ["blipNumber"] = 366,
                ["blipColor"] = 81,
                ["blipDisplay"] = 5,
                ["blipScale"] = 0.4,
                ["blipShortRange"] = true
            }
        }
    },
    ["Vehicles"] = {
        [0] = { -- Job Rank ID
            ["ambulance"] = { -- Spawn Code
                ["label"] = "Ambulance", -- Label for Spawner
                ["type"] = "vehicle", -- vehicle, boat, plane, helicopter
                ["icon"] = "fa-solid fa-truck-medical" -- https://fontawesome.com/icons
            }
        },
        [1] = {
            ["ambulance"] = {
                ["label"] = "Ambulance",
                ["type"] = "vehicle",
                ["icon"] = "fa-solid fa-truck-medical"
            },
            ["polmav"] = {
                ["label"] = "Air Ambulance",
                ["type"] = "helicopter",
                ["icon"] = "fa-solid fa-helicopter"
            }
        },
        [2] = {
            ["ambulance"] = {
                ["label"] = "Ambulance",
                ["type"] = "vehicle",
                ["icon"] = "fa-solid fa-truck-medical"
            },
            ["polmav"] = {
                ["label"] = "Air Ambulance",
                ["type"] = "helicopter",
                ["icon"] = "fa-solid fa-helicopter"
            }
        },
        [3] = {
            ["ambulance"] = {
                ["label"] = "Ambulance",
                ["type"] = "vehicle",
                ["icon"] = "fa-solid fa-truck-medical"
            },
            ["polmav"] = {
                ["label"] = "Air Ambulance",
                ["type"] = "helicopter",
                ["icon"] = "fa-solid fa-helicopter"
            }
        },
        [4] = {
            ["ambulance"] = {
                ["label"] = "Ambulance",
                ["type"] = "vehicle",
                ["icon"] = "fa-solid fa-truck-medical"
            },
            ["polmav"] = {
                ["label"] = "Air Ambulance",
                ["type"] = "helicopter",
                ["icon"] = "fa-solid fa-helicopter"
            }
        },
        [5] = {
            ["ambulance"] = {
                ["label"] = "Ambulance",
                ["type"] = "vehicle",
                ["icon"] = "fa-solid fa-truck-medical"
            },
            ["polmav"] = {
                ["label"] = "Air Ambulance",
                ["type"] = "helicopter",
                ["icon"] = "fa-solid fa-helicopter"
            }
        }
    },
    ["VehicleSettings"] = {
        ["ambulance"] = { -- Spawn name
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
        },
        ["polmav"] = {
            ["extras"] = {
                [1] = 0,
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
            ["livery"] = 1
        }
    },
    ["Items"] = {
        ["stash"] = {}, -- copy design from one of the other items area.
        ["armory"] = {
            ["label"] = "Medical Supply Cabinet", -- name of armory
            ["slots"] = 30, -- how many slots for armory
            ["items"] = {
                [1] = {
                    name = "radio",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "item",
                    authorizedJobGrades = {0,1,2,3,4,5}
                },
                [2] = {
                    name = "bandage",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "item",
                    authorizedJobGrades = {0,1,2,3,4,5}
                },
                [3] = {
                    name = "painkillers",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "item",
                    authorizedJobGrades = {0,1,2,3,4,5}
                },
                [4] = {
                    name = "firstaid",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "item",
                    authorizedJobGrades = {0,1,2,3,4,5}
                },
                [5] = {
                    name = "weapon_flashlight",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "weapon",
                    authorizedJobGrades = {0,1,2,3,4,5}
                },
                [6] = {
                    name = "weapon_fireextinguisher",
                    price = 0,
                    amount  = 50,
                    info = {},
                    type = "weapon",
                    authorizedJobGrades = {0,1,2,3,4,5}
                }
            }
        },
        ["trunk"] = { -- aka boot aka cargo hold aka cargo area aka cargo compartment
            [1] = {
                name = "heavyarmor", -- item name from qb-core/shared/items.lua
                amount  = 2, -- Quantity in trunk
                info = {}, -- get from qb-core/shared/items.lua
                type = "item", -- item or weapon
                vehType = {"vehicle", "boat", "helicopter", "plane"}, -- Vehicle, Boat, Helicopter and/or Plane (any combo)
                authGrade = {0,1,2,3,4,5} -- Job Grades authorized to obtain item
            },
            [2] = {
                name = "radio",
                amount  = 1,
                info = {},
                type = "item",
                vehType = {"vehicle", "boat", "helicopter", "plane"},
                authGrade = {0,1,2,3,4,5}
            },
            [3] = {
                name = "bandage",
                amount  = 50,
                info = {},
                type = "item",
                vehType = {"vehicle", "boat", "helicopter", "plane"},
                authGrade = {0,1,2,3,4,5}
            },
            [4] = {
                name = "painkillers",
                amount  = 50,
                info = {},
                type = "item",
                vehType = {"vehicle", "boat", "helicopter", "plane"},
                authGrade = {0,1,2,3,4,5}
            },
            [5] = {
                name = "firstaid",
                amount  = 15,
                info = {},
                type = "item",
                vehType = {"vehicle", "boat", "helicopter", "plane"},
                authGrade = {0,1,2,3,4,5}
            },
            [6] = {
                name = "weapon_fireextinguisher",
                amount  = 1,
                info = {},
                type = "weapon",
                vehType = {"vehicle", "boat", "helicopter", "plane"},
                authGrade = {0,1,2,3,4,5}
            }
        },
        ["glovebox"] = { -- aka glove compartment
            [1] = {
                ["name"] = "weapon_flashlight", -- item name from qb-core/shared/items.lua
                ["amount"] = 1, -- Quantity in glovebox
                ["info"] = {}, -- get from qb-core/shared/items.lua
                ["type"] = "weapon", -- item or weapon
                ["vehType"] = {"vehicle", "boat", "helicopter", "plane"}, -- Vehicle, Boat, Helicopter and/or Plane (any combo)
                ["authGrade"] = {0, 1, 2, 3, 4} -- Job Grades authorized to obtain item
            }
        }
    },
    ["Outfits"] = {
        -- Job
        ['male'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 85, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 250, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 58, texture = 0}, -- Decals
                        ['accessory'] = {item = 127, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 85, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 250, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 58, texture = 0}, -- Decals
                        ['accessory'] = {item = 127, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 85, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 250, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 58, texture = 0}, -- Decals
                        ['accessory'] = {item = 127, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 90, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 15, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 249, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 57, texture = 0}, -- Decals
                        ['accessory'] = {item = 126, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 85, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 250, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 58, texture = 0}, -- Decals
                        ['accessory'] = {item = 127, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 90, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 15, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 249, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 57, texture = 0}, -- Decals
                        ['accessory'] = {item = 126, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = {item = 93, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 32, texture = 3}, -- T-Shirt
                        ['torso2'] = {item = 31, texture = 7}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 0, texture = 0}, -- Decals
                        ['accessory'] = {item = 126, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 28, texture = 0}, -- Pants
                        ['shoes'] = {item = 10, texture = 0}, -- Shoes
                        ['mask'] = {item = 0, texture = 0}, -- Mask
                        ['hat'] = {item = -1, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 85, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 129, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 250, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 58, texture = 0}, -- Decals
                        ['accessory'] = {item = 127, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 90, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 15, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 249, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 57, texture = 0}, -- Decals
                        ['accessory'] = {item = 126, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 96, texture = 0}, -- Pants
                        ['shoes'] = {item = 54, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 122, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = {item = 93, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 32, texture = 3}, -- T-Shirt
                        ['torso2'] = {item = 31, texture = 7}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 0, texture = 0}, -- Decals
                        ['accessory'] = {item = 126, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 28, texture = 0}, -- Pants
                        ['shoes'] = {item = 10, texture = 0}, -- Shoes
                        ['mask'] = {item = 0, texture = 0}, -- Mask
                        ['hat'] = {item = -1, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            }
        },
        ['female'] = {
            -- Gender
            [0] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 109, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 258, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 66, texture = 0}, -- Decals
                        ['accessory'] = {item = 97, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [1] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 109, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 258, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 66, texture = 0}, -- Decals
                        ['accessory'] = {item = 97, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [2] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 109, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 258, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 66, texture = 0}, -- Decals
                        ['accessory'] = {item = 97, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 105, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 13, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 257, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 65, texture = 0}, -- Decals
                        ['accessory'] = {item = 96, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [3] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 109, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 258, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 66, texture = 0}, -- Decals
                        ['accessory'] = {item = 97, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 105, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 13, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 257, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 65, texture = 0}, -- Decals
                        ['accessory'] = {item = 96, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = {item = 105, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 39, texture = 3}, -- T-Shirt
                        ['torso2'] = {item = 7, texture = 1}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 0, texture = 0}, -- Decals
                        ['accessory'] = {item = 96, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 34, texture = 0}, -- Pants
                        ['shoes'] = {item = 29, texture = 0}, -- Shoes
                        ['mask'] = {item = 0, texture = 0}, -- Mask
                        ['hat'] = {item = -1, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            },
            [4] = {
                -- Grade Level
                [1] = {
                    outfitLabel = 'T-Shirt',
                    outfitData = {
                        ['arms'] = {item = 109, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 159, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 258, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 66, texture = 0}, -- Decals
                        ['accessory'] = {item = 97, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [2] = {
                    outfitLabel = 'Polo',
                    outfitData = {
                        ['arms'] = {item = 105, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 13, texture = 0}, -- T-Shirt
                        ['torso2'] = {item = 257, texture = 0}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 65, texture = 0}, -- Decals
                        ['accessory'] = {item = 96, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 99, texture = 0}, -- Pants
                        ['shoes'] = {item = 55, texture = 0}, -- Shoes
                        ['mask'] = {item = 121, texture = 0}, -- Mask
                        ['hat'] = {item = 121, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                },
                [3] = {
                    outfitLabel = 'Doctor',
                    outfitData = {
                        ['arms'] = {item = 105, texture = 0}, -- Arms
                        ['t-shirt'] = {item = 39, texture = 3}, -- T-Shirt
                        ['torso2'] = {item = 7, texture = 1}, -- Jackets
                        ['vest'] = {item = 0, texture = 0}, -- Vest
                        ['decals'] = {item = 0, texture = 0}, -- Decals
                        ['accessory'] = {item = 96, texture = 0}, -- Neck
                        ['bag'] = {item = 0, texture = 0}, -- Bag
                        ['pants'] = {item = 34, texture = 0}, -- Pants
                        ['shoes'] = {item = 29, texture = 0}, -- Shoes
                        ['mask'] = {item = 0, texture = 0}, -- Mask
                        ['hat'] = {item = -1, texture = 0}, -- Hat
                        ['glass'] = {item = 0, texture = 0}, -- Glasses
                        ['ear'] = {item = 0, texture = 0} -- Ear accessories
                    }
                }
            }
        }
    }
}