fx_version 'cerulean'
game 'gta5'

description 'QB-Jobs'
version '0.0.3'

ui_page 'html/index.html'

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


files {
	'html/*.html',
	'html/*.js',
	'html/*.css'
}

lua54 'yes'