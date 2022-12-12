local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[~g~E~s~] - Vai in servizio',
        off_duty = '[~r~E~s~] - Vai fuori servizio',
        onoff_duty = '~g~Entra~s~/~r~Fuori~s~ Servizio',
        stash = 'Magazzino %{value}',
        store_heli = '[~g~E~s~] Deposita Elicottero',
        take_heli = '[~g~E~s~] Prendi Elicottero',
        store_veh = '[~g~E~s~] - Deposita Veicolo',
        armory = 'Armeria',
        enter_armory = '[~g~E~s~] Armeria',
        keysReturned = "Keys have been returned!", --English Change
        vehicleLimitReached = "Vehicle Limit Reached", --English Change
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'Cestino',
        trash_enter = '[~g~E~s~] Cestino',
        stash_enter = '[~g~E~s~] Entra Armadietto'
    },
    menu = {
        garage_title = 'Veicoli Polizia',
        close = '⬅ Chiudi Menu',
        jobs_garage = ' Garage', --English Change
        jobs_armory = ' Armory', --English Change
        jobs_duty_station = "Set Duty Status" --English Change
    },
    headings = {
        stash = '_Stash', --English Change
        trash = '_Trash', --English Change
        armory = '_Armory', --English Change
        outfit = '_Outfit', --English Change
        management = '_Management', --English Change
        garages = ' Vehicle Selector' --English Change
    },
    commands = {
        duty = 'Set Duty On or Off', --English Change
    }
}
if GetConvar('qb_locale', 'en') == 'it' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end