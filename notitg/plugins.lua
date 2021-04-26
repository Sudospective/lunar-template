local path_to_plugins = GAMESTATE:GetCurrentSong():GetSongDir() .. 'plugins/'
local af = Def.ActorFrame {}
for _, filename in ipairs({GAMESTATE:GetFileStructure(path_to_plugins)}) do
    if string.sub(filename, -4, -1) == '.lua' then
        af[#af + 1] = assert(loadfile('plugins/'..filename))()
    end
end
return af