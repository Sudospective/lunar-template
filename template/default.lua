_G.xero = {}
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		self:sleep(9e9)
	end,
	assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'template/outfox/std.lua'))(),
	assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'template/outfox/template.lua'))(),
	assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'template/outfox/ease.lua'))(),
	assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'template/outfox/plugins.lua'))(),
	assert(loadfile(GAMESTATE:GetCurrentSong():GetSongDir()..'lua/mods.lua'))(),
}
