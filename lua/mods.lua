xero()
return Def.ActorFrame {
	LoadCommand = function(self)
		-- judgment / combo proxies
		for pn = 1, 2 do
			setupJudgeProxy(PJ[pn], P[pn]:GetChild('Judgment'), pn)
			setupJudgeProxy(PC[pn], P[pn]:GetChild('Combo'), pn)
		end
		-- player proxies
		for pn = 1, #PP do
			PP[pn]:SetTarget(P[pn])
			P[pn]:hidden(1)
		end
		-- set default mods/notitg mod conversions
		NotITGMods(true)
		setdefault {
			1.5, 'xmod',
			100, 'modtimer'
		}
		-- funy arow jigles go here

	end,
	-- funy scren budies go here
	Def.ActorProxy { Name = 'PP[1]' },
	Def.ActorProxy { Name = 'PP[2]' },
	Def.ActorProxy { Name = 'PJ[1]' },
	Def.ActorProxy { Name = 'PJ[2]' },
	Def.ActorProxy { Name = 'PC[1]' },
	Def.ActorProxy { Name = 'PC[2]' },
	Def.Sprite {
		Name = 'ScreenSprite',
		InitCommand = function(self)
			sprite(self)
			self:diffusealpha(0.8)
			self:zoom(1.01)
		end,
		OnCommand = function(self)
			aftsprite(ScreenAST, self)
		end,
	},
	Def.ActorScreenTexture {
		Name = 'ScreenAST',
		InitCommand = function(self)
			aft(self)
		end,
	},
}
