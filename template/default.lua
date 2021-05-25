_G.xero = {}
xero.songdir = GAMESTATE:GetCurrentSong():GetSongDir()
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		assert(loadfile(xero.songdir..'template/sharedvars.lua'))()
		self:sleep(9e9)
	end,
	assert(loadfile(xero.songdir..'template/std.lua'))(),
	assert(loadfile(xero.songdir..'template/template.lua'))(),
	assert(loadfile(xero.songdir..'template/ease.lua'))(),
	assert(loadfile(xero.songdir..'template/plugins.lua'))(),
	assert(loadfile(xero.songdir..'outfox/modport.lua'))(),
	assert(loadfile(xero.songdir..'lua/mods.lua'))(),
}
