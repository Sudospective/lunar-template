xero()
return Def.Actor {
    LoadCommand = function(self)
        --[[
            Mirror Plugin - Created by Sudospective

            The mirror plugin allows you to use ease and add methods
            that takes P1's mods and mirrors them to P2 via inverse.
        --]]
        function mirror(t)
            local tcopy = copy(t)
            t.plr = 1
            tcopy.plr = 2
            for i = 4, #tcopy, 2 do
                tcopy[i] = -tcopy[i]
            end
            ease(t, 1, 'mirror')
            ease(tcopy, 1, 'mirror')
            return mirror
        end

        function mirroradd(t)
            local tcopy = copy(t)
            t.plr = 1
            tcopy.plr = 2
            for i = 4, #tcopy, 2 do
                tcopy[i] = -tcopy[i]
            end
            add(t, 1, 'mirror')
            add(tcopy, 1, 'mirror')
            return mirroradd
        end
    end
}