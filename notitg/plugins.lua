local path_to_plugins = GAMESTATE:GetCurrentSong():GetSongDir() .. 'plugins/'
local af = Def.ActorFrame {}
for _, v in ipairs({GAMESTATE:GetFileStructure(path_to_plugins)}) do
    xero.loadscript('plugins/'..v)
end
return af