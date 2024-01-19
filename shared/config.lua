lib.locale()

Config = {}
Config.Debug = false
Config.Target = nil               -- only supporting ox_target and qb-target | nil to disable targeting
Config.SpawnDelay = 1             -- seconds [how much time it should take between spawning animals]
Config.DeleteEntityRadius = 300.0 -- will delete animal if your 400 meters away from them

Config.TrackerItem = "animal_tracker"
Config.TrackingDuration = 60      -- seconds
Config.DelayBetweenTracks = 120   -- seconds
Config.TrackingFailureChance = 20 -- [1 - 100]

Config.AimBlock = {
    enable = true,
    global = true,     -- false if you want to have aimblock only in hunting zones
    weaponsToBlock = { -- weapons that are disabled to shoot at players
        `WEAPON_HEAVYSNIPER_MK2`,
        -- `WEAPON_HEAVYSNIPER`,
    }
}

Config.BaitItem = "huntingbait"
Config.BaitAttractionDistance = 100.0 -- in 200 radius it will atract an animal
Config.BaitTimeLimit = 2              -- minutes

Config.ImagesPath = "nui://ars_hunting/_icons/"


-- _____                           __  _
-- / ____|                         / _| (_)
-- | |      __ _  _ __ ___   _ __  | |_  _  _ __  ___
-- | |     / _` || '_ ` _ \ | '_ \ |  _|| || '__|/ _ \
-- | |____| (_| || | | | | || |_) || |  | || |  |  __/
-- \_____|\__,_||_| |_| |_|| .__/ |_|  |_||_|   \___|
--                         | |
--                         |_|

Config.Campfire = {
    enable = true,
    campfireItem = "campfire",
    items = {
        {
            label = "Cooked meat",
            give = "cooked_meat",
            cookTime = 5, -- seconds
            require = {
                {
                    label = "Raw Meat",
                    quantity = 1,
                    item = "raw_meat",
                },
            }
        },
        -- {
        --     label = "Cooked meat",
        --     give = "cooked_meat",
        --     cookTime = 5, -- seconds
        --     require = {
        --         {
        --             label = "Raw Meat",
        --             quantity = 1,
        --             item = "raw_meat",
        --         },
        --     }
        -- },
    }
}

-- _    _                _    _                  ______
-- | |  | |              | |  (_)                |___  /
-- | |__| | _   _  _ __  | |_  _  _ __    __ _      / /  ___   _ __    ___  ___
-- |  __  || | | || '_ \ | __|| || '_ \  / _` |    / /  / _ \ | '_ \  / _ \/ __|
-- | |  | || |_| || | | || |_ | || | | || (_| |   / /__| (_) || | | ||  __/\__ \
-- |_|  |_| \__,_||_| |_| \__||_||_| |_| \__, |  /_____|\___/ |_| |_| \___||___/
--                                        __/ |
--                                       |___/

Config.HuntingZones = {
    ["CHILIAD_MOUNTAINS"] = {
        coords = vec3(1125.88, 4622.2, 80.08),
        radius = 200.0,
        maxSpawns = 5,                                                  -- max animals spawned at one time
        allowedWeapons = { "WEAPON_HEAVYSNIPER_MK2", "WEAPON_DAGGER" }, -- nil if you want to allow every weapon
        zone_radius = {
            enable = true,
            color = 1,
            opacity = 128,
        },
        blip = {
            enable = true,
            name = 'Hunting Zone',
            type = 141,
            scale = 1.0,
            color = 0,
        },
        animals = {
            {
                model = "a_c_deer",
                chance = 80, -- chance of spawning
                harvestTime = 5,
                harvestWeapons = { "WEAPON_DAGGER" },
                blip = {
                    enable = true,
                    name = 'Deer',
                    type = 119,
                    scale = 0.8,
                    color = 1,
                },
                marker = {
                    enable = true,
                    color = { r = 196, g = 136, b = 77, a = 150 }
                },
                items = {
                    skins = {
                        {
                            item = "skin_deer_ruined",
                            chance = 70,
                            maxQuantity = 1,
                        },
                        {
                            item = "skin_deer_low",
                            chance = 50,
                            maxQuantity = 1,
                        },
                        {
                            item = "skin_deer_medium",
                            chance = 30,
                            maxQuantity = 1,
                        },
                        {
                            item = "skin_deer_good",
                            chance = 25,
                            maxQuantity = 1,
                        },
                        {
                            item = "skin_deer_perfect",
                            chance = 5,
                            maxQuantity = 1,
                        },
                    },
                    meat = {
                        {
                            item = "raw_meat",
                            chance = 100,
                            maxQuantity = 10,
                        },
                        -- {
                        --     item = "raw_meat",
                        --     chance = 100,
                        --     maxQuantity = 10,
                        -- },
                    },
                    extra = { -- rare items
                        {
                            item = "deer_horn",
                            chance = 30,
                            maxQuantity = 1,
                        },
                        -- {
                        --     item = "deer_horn",
                        --     chance = 30,
                        --     maxQuantity = 1,
                        -- },
                    }

                }
            },
            -- {
            --     model = "a_c_deer",
            --     chance = 80, -- chance of spawning
            --     harvestTime = 5,
            --     harvestWeapons = { "WEAPON_DAGGER" },
            --     blip = {
            --         enable = true,
            --         name = 'Deer',
            --         type = 8,
            --         scale = 0.8,
            --         color = 1,
            --     },
            --     marker = {
            --         enable = true,
            --         color = { r = 196, g = 136, b = 77, a = 150 }
            --     },
            --     items = {
            --         skins = {
            --             {
            --                 item = "skin_deer_ruined",
            --                 chance = 70,
            --                 maxQuantity = 1,
            --             },
            --             {
            --                 item = "skin_deer_low",
            --                 chance = 50,
            --                 maxQuantity = 1,
            --             },
            --             {
            --                 item = "skin_deer_medium",
            --                 chance = 30,
            --                 maxQuantity = 1,
            --             },
            --             {
            --                 item = "skin_deer_good",
            --                 chance = 25,
            --                 maxQuantity = 1,
            --             },
            --             {
            --                 item = "skin_deer_perfect",
            --                 chance = 5,
            --                 maxQuantity = 1,
            --             },
            --         },
            --         meat = {
            --             {
            --                 item = "raw_meat",
            --                 chance = 100,
            --                 maxQuantity = 10,
            --             },
            --             -- {
            --             --     item = "raw_meat",
            --             --     chance = 100,
            --             --     maxQuantity = 10,
            --             -- },
            --         },
            --         extra = { -- rare items
            --             {
            --                 item = "deer_horn",
            --                 chance = 30,
            --                 maxQuantity = 1,
            --             },
            --             -- {
            --             --     item = "deer_horn",
            --             --     chance = 30,
            --             --     maxQuantity = 1,
            --             -- },
            --         }

            --     }
            -- },
        }
    },
    -- ["CHILIAD_MOUNTAINS2"] = {
    --     coords = vec3(1125.88, 4622.2, 80.08),
    --     radius = 200.0,
    --     maxSpawns = 5,                                                  -- max animals spawned at one time
    --     allowedWeapons = { "WEAPON_HEAVYSNIPER_MK2", "WEAPON_DAGGER" }, -- nil if you want to allow every weapon
    --     blip = {
    --         enable = true,
    --         color = 1,
    --         opacity = 128,
    --     },
    --     animals = {
    --         {
    --             model = "a_c_deer",
    --             chance = 80, -- chance of spawning
    --             harvestTime = 5,
    --             harvestWeapons = { "WEAPON_DAGGER" },
    --             blip = {
    --                 enable = true,
    --                 name = 'Deer',
    --                 type = 8,
    --                 scale = 0.8,
    --                 color = 1,
    --             },
    --             marker = {
    --                 enable = true,
    --                 color = { r = 196, g = 136, b = 77, a = 150 }
    --             },
    --             items = {
    --                 skins = {
    --                     {
    --                         item = "skin_deer_ruined",
    --                         chance = 70,
    --                         maxQuantity = 1,
    --                     },
    --                     {
    --                         item = "skin_deer_low",
    --                         chance = 50,
    --                         maxQuantity = 1,
    --                     },
    --                     {
    --                         item = "skin_deer_medium",
    --                         chance = 30,
    --                         maxQuantity = 1,
    --                     },
    --                     {
    --                         item = "skin_deer_good",
    --                         chance = 25,
    --                         maxQuantity = 1,
    --                     },
    --                     {
    --                         item = "skin_deer_perfect",
    --                         chance = 5,
    --                         maxQuantity = 1,
    --                     },
    --                 },
    --                 meat = {
    --                     {
    --                         item = "raw_meat",
    --                         chance = 100,
    --                         maxQuantity = 10,
    --                     },
    --                     -- {
    --                     --     item = "raw_meat",
    --                     --     chance = 100,
    --                     --     maxQuantity = 10,
    --                     -- },
    --                 },
    --                 extra = { -- rare items
    --                     {
    --                         item = "deer_horn",
    --                         chance = 30,
    --                         maxQuantity = 1,
    --                     },
    --                     -- {
    --                     --     item = "deer_horn",
    --                     --     chance = 30,
    --                     --     maxQuantity = 1,
    --                     -- },
    --                 }

    --             }
    --         },
    --         -- {
    --         --     model = "a_c_deer",
    --         --     chance = 80, -- chance of spawning
    --         --     harvestTime = 5,
    --         --     harvestWeapons = { "WEAPON_DAGGER" },
    --         --     blip = {
    --         --         enable = true,
    --         --         name = 'Deer',
    --         --         type = 8,
    --         --         scale = 0.8,
    --         --         color = 1,
    --         --     },
    --         --     marker = {
    --         --         enable = true,
    --         --         color = { r = 196, g = 136, b = 77, a = 150 }
    --         --     },
    --         --     items = {
    --         --         skins = {
    --         --             {
    --         --                 item = "skin_deer_ruined",
    --         --                 chance = 70,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --             {
    --         --                 item = "skin_deer_low",
    --         --                 chance = 50,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --             {
    --         --                 item = "skin_deer_medium",
    --         --                 chance = 30,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --             {
    --         --                 item = "skin_deer_good",
    --         --                 chance = 25,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --             {
    --         --                 item = "skin_deer_perfect",
    --         --                 chance = 5,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --         },
    --         --         meat = {
    --         --             {
    --         --                 item = "raw_meat",
    --         --                 chance = 100,
    --         --                 maxQuantity = 10,
    --         --             },
    --         --             -- {
    --         --             --     item = "raw_meat",
    --         --             --     chance = 100,
    --         --             --     maxQuantity = 10,
    --         --             -- },
    --         --         },
    --         --         extra = { -- rare items
    --         --             {
    --         --                 item = "deer_horn",
    --         --                 chance = 30,
    --         --                 maxQuantity = 1,
    --         --             },
    --         --             -- {
    --         --             --     item = "deer_horn",
    --         --             --     chance = 30,
    --         --             --     maxQuantity = 1,
    --         --             -- },
    --         --         }

    --         --     }
    --         -- },
    --     }
    -- },

}

-- _____  _
-- / ____|| |
-- | (___  | |__    ___   _ __   ___
-- \___ \ | '_ \  / _ \ | '_ \ / __|
-- ____) || | | || (_) || |_) |\__ \
-- |_____/ |_| |_| \___/ | .__/ |___/
--                      | |
--                      |_|

Config.Shops = {
    ["HuntGear Store"] = {
        coords = vector4(967.6, -2121.12, 30.48, 86.84),
        ped = {
            enable = Config.Target and true or true, -- false the last bool to dont use ped
            model = "s_m_m_ammucountry"
        },
        blip = {
            enable = true,
            type = 59,
            scale = 0.7,
            color = 5,
        },
        useDrawText = true,
        items = {
            sell = {
                {
                    item = "skin_deer_ruined",
                    price = 250,
                    label = "Tattered Deer Pelt"

                },
                {
                    item = "skin_deer_low",
                    price = 500,
                    label = "Worn Deer Pelt"

                },
                {
                    item = "skin_deer_medium",
                    price = 700,
                    label = "Supple Deer Pelt"


                },
                {
                    item = "skin_deer_good",
                    price = 1200,
                    label = "Prime Deer Pelt"

                },
                {
                    item = "skin_deer_perfect",
                    price = 2250,
                    label = "Flawless Deer Pelt"


                },
            },
            buy = {
                {
                    item = "huntingbait",
                    label = "hunting Bait",
                    price = 250,
                },
                {
                    item = "campfire",
                    label = "Campfire",
                    price = 750,
                },
                {
                    item = "animal_tracker",
                    label = "Animal Tracker",
                    price = 10050,
                },
            }

        }
    },
    -- ["HuntGear Store2"] = {
    --     coords = vector4(967.6, -2121.12, 30.48, 86.84),
    --     ped = {
    --         enable = Config.Target and true or true, -- false the last bool to dont use ped
    --         model = "s_m_m_ammucountry"
    --     },
    --     blip = {
    --         enable = true,
    --         type = 59,
    --         scale = 0.7,
    --         color = 5,
    --     },
    --     useDrawText = true,
    --     items = {
    --         sell = {
    --             {
    --                 item = "skin_deer_ruined",
    --                 price = 250,
    --                 label = "Tattered Deer Pelt"

    --             },
    --             {
    --                 item = "skin_deer_low",
    --                 price = 500,
    --                 label = "Worn Deer Pelt"

    --             },
    --             {
    --                 item = "skin_deer_medium",
    --                 price = 700,
    --                 label = "Supple Deer Pelt"


    --             },
    --             {
    --                 item = "skin_deer_good",
    --                 price = 1200,
    --                 label = "Prime Deer Pelt"

    --             },
    --             {
    --                 item = "skin_deer_perfect",
    --                 price = 2250,
    --                 label = "Flawless Deer Pelt"


    --             },
    --         },
    --         buy = {
    --             {
    --                 item = "huntingbait",
    --                 label = "hunting Bait",
    --                 price = 250,
    --             },
    --             {
    --                 item = "campfire",
    --                 label = "Campfire",
    --                 price = 750,
    --             },
    --             {
    --                 item = "animal_tracker",
    --                 label = "Animal Tracker",
    --                 price = 10050,
    --             },
    --         }

    --     }
    -- }
}


-- __  __  _            _
-- |  \/  |(_)          (_)
-- | \  / | _  ___  ___  _   ___   _ __   ___
-- | |\/| || |/ __|/ __|| | / _ \ | '_ \ / __|
-- | |  | || |\__ \\__ \| || (_) || | | |\__ \
-- |_|  |_||_||___/|___/|_| \___/ |_| |_||___/

Config.HuntMaster = {
    coords = vector4(17.04, 3688.28, 38.68, 147.12),
    model = "cs_fabien",
    blip = {
        enable = true,
        name = 'Hunting Missions',
        type = 85,
        scale = 0.8,
        color = 5,
    },
    vehicleSpawn = vector4(10.04, 3679.52, 39.72, 115.0),
    vehicleDeposit = vector3(10.04, 3679.52, 39.72)
}

Config.Missions = {
    {
        label = "High-Quality Pelts",
        content = "Bring me 10 high-quality deer skins",
        icon = "fa-solid fa-bullseye",
        image = Config.ImagesPath .. "skin_deer_good.png",
        delay = 10, -- wait 10 minutes do another of this mission
        time = 20,  -- minutes
        type = "item",
        id = "mission_1",
        vehicle = {
            enable = false,
            model = "bodhi2",
        },
        requirements = {
            {
                item = "skin_deer_good",
                label = "Prime Deer Pelt",
                quantity = 10
            }
        },
        rewards = {
            {
                item = "money",
                quantity = 5000
            }
        }
    },
    {
        label = "Antler Collection",
        content = "Gather 5 Deer Horns for my collection",
        icon = "fa-solid fa-bullseye",
        image = Config.ImagesPath .. "deer_horn.png",
        delay = 10, -- wait 10 minutes do another of this mission
        time = 25,  -- minutes
        type = "item",
        id = "mission_2",
        vehicle = {
            enable = false,
            model = "bodhi2",
        },
        requirements = {
            {
                item = "deer_horn",
                label = "Deer Horns",
                quantity = 5
            }
        },
        rewards = {
            {
                item = "money",
                quantity = 5000
            }
        }
    },
    {
        label = "Boar Bounty",
        content = "- Catch The boar and bring it to hunt master",
        icon = "fa-solid fa-bullseye",
        image = Config.ImagesPath .. "boar.png",
        delay = 10, -- wait 10 minutes do another of this mission
        time = 10,  -- minutes
        type = "animal",
        id = "mission_3",
        animal = "a_c_boar",
        vehicle = {
            enable = true,
            model = "bodhi2",

        },
        attach = {
            pos = vector3(-0.6, 1.0, -0.5),
            rot = vector3(0.0, 0.0, 0.0)
        },
        vehicleAttach = {
            pos = vector3(-1.2, 1.0, 0.8),
            rot = vector3(0.0, 0.0, 0.0),
        },
        blip = {
            name = 'Hunt Me',
            type = 1,
            scale = 0.8,
            color = 4,
        },
        spawns = {
            vector3(-1640.24, 4726.76, 53.4),
            vector3(-1166.44, 5068.44, 142.92)
        },
        rewards = {
            {
                item = "money",
                quantity = 5000
            }
        }
    },

}
