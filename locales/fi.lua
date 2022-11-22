local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[E] - Mene virkaajalle',
        off_duty = '[E] - Mene virkavapaalle',
        onoff_duty = '~g~Päälle~s~/~r~Pois~s~ Virka',
        stash = 'Kätkeä %{value}',
        store_heli = '[E] Säilytä helikopteri',
        take_heli = '[E] Ota helikopteri',
        store_veh = '[E] - Tallenna Ajoneuvo',
        armory = 'Asevarasto',
        enter_armory = '[E] Asevarasto',
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'Roskis',
        trash_enter = '[E] Roskis',
        stash_enter = '[E] Pukuhuone'
    },
    menu = {
        garage_title = 'Virkamiesten Autotalli',
        close = '⬅ Sulje valikko',
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
if GetConvar('qb_locale', 'en') == 'fi' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end