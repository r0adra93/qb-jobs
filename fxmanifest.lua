fx_version 'cerulean'
game 'gta5'

description 'QB-Jobs'
version '0.0.1'

shared_scripts {
    'config.lua',
	'jobs/*.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/main.css',
	'html/vcr-ocd.ttf'
}

lua54 'yes'