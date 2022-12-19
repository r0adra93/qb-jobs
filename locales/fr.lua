local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[~g~E~s~] - Prendre son service',
        off_duty = '[~r~E~s~] - Quitter son service',
        onoff_duty = '~g~On~s~/~r~Off~s~ Service',
        stash = 'Coffre %{value}',
        store_heli = '[~g~E~s~] Ranger l\'hélicoptère',
        take_heli = '[~g~E~s~] Prendre l\'hélicoptère',
        store_veh = '[~g~E~s~] - Ranger le véhicule',
        armory = 'Armurerie',
        enter_armory = '[~g~E~s~] Armurerie',
        enter_motorworks = '[E] Motorworks', -- English Change
        vehicleLimitReached = "Vehicle Limit Reached", -- English Change
        enter_outfit = '[E] Outfitter', -- English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', -- English Change
        trash = 'Poubelle',
        trash_enter = '[~g~E~s~] Poubelle',
        stash_enter = '[~g~E~s~] Entrer dans le Casier'
    },
    menu = {
        garage_title = 'Véhicule de police',
        close = '⬅ Fermer le menu',
        jobs_garage = ' Garage', -- English Change
        jobs_armory = ' Armory', -- English Change
        jobs_duty_station = "Set Duty Status" -- English Change
    },
    headings = {
        stash = '_Stash', -- English Change
        trash = '_Trash', -- English Change
        armory = '_Armory', -- English Change
        outfit = '_Outfit', -- English Change
        management = '_Management', -- English Change
        garages = ' Vehicle Selector' -- English Change
    },
    commands = {
        duty = 'Set Duty On or Off' -- English Change
    }
}
if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end