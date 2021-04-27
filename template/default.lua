_G.xero = {}
return Def.ActorFrame {
	InitCommand = function(self)
		xero.foreground = self
		assert(loadfile('template/sharedvars.lua'))()
		self:sleep(9e9)
	end,
	assert(loadfile('template/std.lua'))(),
	assert(loadfile('template/template.lua'))(),
	assert(loadfile('template/ease.lua'))(),
	assert(loadfile('template/plugins.lua'))(),
	assert(loadfile('outfox/modport.lua'))(),
	assert(loadfile('lua/mods.lua'))(),
}
