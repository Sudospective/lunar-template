_G.xero = {}
function xero.loadscript(path)
	-- load the song directory
	local songdir = GAMESTATE:GetCurrentSong():GetSongDir()
	-- attempt to load lua file
	return loadfile(songdir..path)
end
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		self:sleep(9e9)
	end,
	xero.loadscript('outfox/std.lua'),
	xero.loadscript('outfox/template.lua'),
	xero.loadscript('outfox/ease.lua'),
	xero.loadscript('outfox/plugins.lua'),
	xero.loadscript('outfox/mirin-porting.lua'),
	xero.loadscript('lua/mods.lua'),
}
