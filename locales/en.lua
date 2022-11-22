local Translations = {
    error = {},
    success = {},
    info = {
        onoff_duty = '[E] - Set Duty Status',
        stash = 'Stash %{value}',
        store_heli = '[E] Store Helicopter',
        take_heli = '[E] Take Helicopter',
        store_veh = '[E] - Store Vehicle',
        armory = 'Armory',
        enter_armory = '[E] Armory',
        enter_outfit = '[E] Outfitter',
        enter_management = '[E] Manager System',
        enter_garage = '[E] Sign Out Vehicle',
        trash = 'Trash',
        trash_enter = '[E] Trash Bin',
        stash_enter = '[E] Enter Locker',
    },
    menu = {
        garage_title = ' Vehicles',
        close = '⬅ Close Menu',
        jobs_garage = ' Garage',
        jobs_armory = ' Armory',
        jobs_duty_station = "Set Duty Status",
    },
    headings = {
        stash = '_Stash',
        trash = '_Trash',
        armory = '_Armory',
        outfit = '_Outfit',
        management = '_Management',
        garages = ' Vehicle Selector'
    },
    commands = {
        duty = 'Set Duty On or Off',
    }
}
Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
