xero()
return Def.Actor {
    LoadCommand = xero(function(self)
        local swaps = {}
        local cols = {l = 0, d = 1, u = 2, r = 3}
        local movex = {[0] = 'movex1', 'movex2', 'movex3', 'movex4'}
        local has = string.find
        local function lambda(path)
            path = path or ''
            local e = true
            if not has(path, 'l') then lambda(path..'l') e = false end
            if not has(path, 'd') then lambda(path..'d') e = false end
            if not has(path, 'u') then lambda(path..'u') e = false end
            if not has(path, 'r') then lambda(path..'r') e = false end
            if e then
                local list = {}
                for col = 0, 3 do
                    local t = cols[string.sub(path, col + 1, col + 1)]
                    list[t] = (col - t) * 100
                end
                swaps[path] = list
            end
        end
        lambda()
        function swap(t)
            local which = t[4]
            for col = 0, 3 do
                t[4 + col * 2] = swaps[which][col]
                t[5 + col * 2] = movex[col]
            end
            ease(t, 1, 'swap')
            return swap
        end
    end
}