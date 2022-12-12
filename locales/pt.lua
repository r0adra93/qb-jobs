local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[E] - Entrar em serviço',
        off_duty = '[E] - Sair de serviço',
        onoff_duty = 'Entrar/Sair de Serviço',
        stash = 'Baú %{value}',
        store_heli = '[E] Guardar Helicóptero',
        take_heli = '[E] Pedir Helicóptero',
        store_veh = '[E] - Guardar Veículo',
        armory = 'Arsenal',
        enter_armory = '[E] Arsenal',
        keysReturned = "Keys have been returned!", --English Change
        vehicleLimitReached = "Vehicle Limit Reached", --English Change
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'Lixo',
        trash_enter = '[E] Lixo',
        stash_enter = '[E] Abrir Cacifo'
    },
    menu = {
        garage_title = 'Veículos Polícia',
        close = '⬅ Fechar Menu',
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
    },
}
if GetConvar('qb_locale', 'en') == 'pt' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end