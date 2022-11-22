local Translations = {
    error = {},
    success = {},
    info = {
        on_duty = '[~g~E~s~] - ﺔﻣﺪﺨﻟﺍ ﻝﻮﺧﺩ',
        off_duty = '[~r~E~s~] - ﺔﻣﺪﺨﻟﺍ ﻦﻣ ﺝﻭﺮﺨﻟﺍ',
        onoff_duty = 'ﺔﻣﺪﺨﻟﺍ ﺔﻟﺎﺣ',
        stash = '%{value}',
        store_heli = '[~g~E~s~] ﺝﺍﺮﻏ',
        take_heli = '[~g~E~s~] ﺝﺍﺮﻏ',
        store_veh = '[~g~E~s~] - ﺝﺍﺮﻏ',
        armory = 'Armory',
        enter_armory = '[~g~E~s~] ﺔﺤﻠﺳﻻﺍ ﺔﻧﺰﺧ',
        enter_outfit = '[E] Outfitter', --English Change
        enter_management = '[E] Manager System', -- English Change
        enter_garage = '[E] Sign Out Vehicle', --English Change
        trash = 'ﺮﻳﻭﺪﺘﻟﺍ ﺓﺩﺎﻋﺍ',
        trash_enter = '[~g~E~s~] ﺮﻳﻭﺪﺘﻟﺍ ﺓﺩﺎﻋﺍ',
        stash_enter = '[~g~E~s~] ﻞﺧﺩﺃ',
    },
    menu = {
        garage_title = 'سيارات الشرطة',
        close = '⬅ اغلاق',
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
if GetConvar('qb_locale', 'en') == 'ar' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end