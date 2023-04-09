fx_version 'adamant'
game 'gta5'

shared_script 'config.lua'

client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua',
	'config.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua',
	'config.lua'
}
