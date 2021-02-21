local path_to_plugins = GAMESTATE:GetCurrentSong():GetSongDir() .. 'plugins/'
local af = Def.ActorFrame {}
-- #TODO: Fix for NotITG even though GameState's GetFileStructure sucks
return af