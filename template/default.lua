_G.xero = {}
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		assert(loadfile('template/sharedvars.lua'))()
		self:sleep(9e9)
	end,
	assert(loadfile('outfox/std.lua'))(),
	assert(loadfile('outfox/template.lua'))(),
	assert(loadfile('outfox/ease.lua'))(),
	assert(loadfile('outfox/plugins.lua'))(),
	assert(loadfile('outfox/modport.lua'))(),
	assert(loadfile('lua/mods.lua'))(),
}
