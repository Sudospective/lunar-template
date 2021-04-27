local path_to_plugins = GAMESTATE:GetCurrentSong():GetSongDir() .. 'plugins/'
local af = Def.ActorFrame {}
local filestruct
if FUCK_EXE then
    filestruct = {GAMESTATE:GetFileStructure(path_to_plugins)}
else
    filestruct = FILEMAN:GetDirListing(path_to_plugins)
end
for _, filename in ipairs(filestruct) do
    if string.sub(filename, -4, -1) == '.lua' then
        af[#af + 1] = assert(loadfile(path_to_plugins..filename))()
    end
end
return af