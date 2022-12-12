--[[
Romanian base language translation for qb-jobs
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[E] - Intra in tura',
        off_duty = '[E] - Iesi din tura',
        onoff_duty = '~g~Intra~s~/~r~Iesi~s~ din tura',
        stash = 'Fiset %{value}',
        store_heli = '[E] Parcheaza elicopterul',
        take_heli = '[E] Foloseste elicopterul',
        store_veh = '[E] - Parcheaza vehicul',
        armory = 'Armurier',
        enter_armory = '[E] Armurier',
        keysReturned = "Keys have been returned!", --English Change
        vehicleLimitReached = "Vehicle Limit Reached", --English Change
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'Gunoi',
        trash_enter = '[E] Cos de gunoi',
        stash_enter = '[E] Vestiar'
    },
    menu = {
        garage_title = 'Vehicule MAI',
        close = '⬅ Inchide meniul',
        impound = 'Vehicule confiscate',
        jobs_garage = ' Garage', --English Change
        jobs_armory = ' Armory', --English Change
        jobs_duty_station = "Set Duty Status", --English Change
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
if GetConvar('qb_locale', 'en') == 'ro' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end