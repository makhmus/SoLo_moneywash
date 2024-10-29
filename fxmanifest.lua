fx_version 'cerulean'
lua54 'yes'
games {
    'gta5'
}

author 'SoLo'
description 'Money wash'
version '1.0.0'

client_scripts {
    'client.lua',
    
}

shared_scripts {
	'config.lua'
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

ui_page 'html/ui.html'

files {
    'html/*.js',
    'html/*.css'
}

