local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[~g~E~s~] - Ísť do služby',
        off_duty = '[~r~E~s~] - Ísť mimo službu',
        onoff_duty = '~g~On~s~/~r~Off~s~ Duty',
        stash = 'Úložisko %{value}',
        store_heli = '[~g~E~s~] Uložiť helikoptéru',
        take_heli = '[~g~E~s~] Vybrať helikoptéru',
        store_veh = '[~g~E~s~] - Vložiť vozidlo',
        armory = 'Zbrojnica',
        enter_armory = '[~g~E~s~] Zbrojnica',
        enter_motorworks = '[E] Motorworks', -- English Change
        vehicleLimitReached = "Vehicle Limit Reached", -- English Change
        enter_outfit = '[E] Outfitter', -- English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', -- English Change
        trash = 'Smetie',
        trash_enter = '[~g~E~s~] Odpadkový kôš',
        stash_enter = '[~g~E~s~] Otvoriť úložisko'
    },
    menu = {
        garage_title = 'Policajné vozidlá',
        close = '⬅ Zatvoriť menu',
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
if GetConvar('qb_locale', 'en') == 'sk' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang
    })
end