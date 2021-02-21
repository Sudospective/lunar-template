xero()
return Def.ActorFrame {
    LoadCommand = function(self)
            
        --loadfileM('scripts/mirin_portable.lua')

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

        -- your code goes here here:
        ease {0, 1, outExpo, 100, 'invert'}
        
    end,

    Def.ActorProxy { Name = 'PJ[1]' },
    Def.ActorProxy { Name = 'PJ[2]' },
    Def.ActorProxy { Name = 'PC[1]' },
    Def.ActorProxy { Name = 'PC[2]' },
    Def.ActorProxy { Name = 'PP[1]' },
    Def.ActorProxy { Name = 'PP[2]' },
}
