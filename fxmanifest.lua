fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client.lua',

    "@RageUI/src/RageUI.lua",
    "@RageUI/src/Menu.lua",
    "@RageUI/src/MenuController.lua",

    "@RageUI/src/components/Audio.lua",
    "@RageUI/src/components/Graphics.lua",
    "@RageUI/src/components/Keys.lua",
    "@RageUI/src/components/Util.lua",
    "@RageUI/src/components/Visual.lua",

    "@RageUI/src/elements/ItemsBadge.lua",
    "@RageUI/src/elements/ItemsColour.lua",
    "@RageUI/src/elements/PanelColour.lua",

    "@RageUI/src/items/Items.lua",
    "@RageUI/src/items/Panels.lua"
}

server_scripts {
    'server.lua',
    '@mysql-async/lib/MySQL.lua'
}