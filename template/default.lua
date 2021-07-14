_G.xero = {}
xero.songdir = GAMESTATE:GetCurrentSong():GetSongDir()
xero.loadscript = function(path) return assert(loadfile(xero.songdir..path))() end
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		xero.loadscript('template/sharedvars.lua')
		self:sleep(9e9)
	end,
	xero.loadscript('template/std.lua'),
	xero.loadscript('template/template.lua'),
	xero.loadscript('template/ease.lua'),
	xero.loadscript('template/plugins.lua'),
	xero.loadscript('outfox/modport.lua'),
	xero.loadscript('lua/mods.lua'),
}
