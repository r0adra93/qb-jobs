local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[E] - Entrar de servicio',
        off_duty = '[E] - Salir de servicio',
        onoff_duty = '~g~On~s~/~r~Fuera~s~ Servicio',
        stash = 'Hueco %{value}',
        store_heli = '[E] Guardar helicoptero',
        take_heli = '[E] Sacar helicpotero',
        store_veh = '[E] - Guardar vehiculo',
        armory = 'Arsenal',
        enter_armory = '[E] Acceder al arsenal',
        keysReturned = "Keys have been returned!", --English Change
        vehicleLimitReached = "Vehicle Limit Reached", --English Change
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'Basura',
        trash_enter = '[E] Papelera',
        stash_enter = '[E] Entrar armario',
    },
    menu = {
        garage_title = 'Vehiculos policia',
        close = '⬅ Cerrar menu',
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
if GetConvar('qb_locale', 'en') == 'es' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end