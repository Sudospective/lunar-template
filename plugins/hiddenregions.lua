xero()
return Def.Actor {
    LoadCommand = function(self)
        --[[
            hiddenregions.lua
            original code by oatmealine
            ported by sudospective

            lets you add hidden regions to a player as a function

            hide {beat, duration, [plr], [column]}
            ```lua
            hide
            {0, 2, plr = 1, column = {1, 2, 3}}
            {2, 2, plr = 2, column = {2, 3, 4}}
        ]]
        
        local hiddenregions = {}
        
        local function contains(table, element)
            for _, value in pairs(table) do
                if value == element then
                    return true
                end
            end
            return false
        end

        local function throw(msg)
            local _, err = pcall(error, msg, 4)
            SCREENMAN:SystemMessage(err)
        end

        function hide(table)
            if type(table) == 'table' then
                local start = table[1]
                local dur = table[2]

                local players = table.plr or rawget(xero, 'plr') or {1, 2}
                if type(players) == 'number' then players = {players} end

                local column = table.column or {1, 2, 3, 4}
                if type(column) == 'number' then
                    if column == 0 then
                        column = {1, 2, 3, 4}
                    else
                        column = {column}
                    end
                end

                if type(start) ~= 'number' then throw('invalid hide beat: expected number, got ' .. type(start)); return hide end
                if type(dur) ~= 'number' then throw('invalid hide duration: expected number, got ' .. type(dur)); return hide end
                if type(players) ~= 'table' then throw('invalid hide players: expected table, got ' .. type(players)); return hide end
                if type(column) ~= 'table' then throw('invalid hide column: expected table, got ' .. type(players)); return hide end

                hiddenregions[#hiddenregions + 1] = {start, start + dur, column, players}
                return hide
            else
                throw('invalid hide input: expected table, got ' .. type(table))
                return hide
            end
        end
        
        func {0, function()
            local res = {}
            
            -- one for each player
            for pn = 1, max_pn do
                res[pn] = {}
            end
            
            for c = 1, 4 do
                for _,r in ipairs(hiddenregions) do
                    if contains(r[3], c) then
                        for _,pl in ipairs(r[4]) do
                            table.insert(res[pl], {r[1], r[2], c})
                        end
                    end
                end
            end

            for i,pl in ipairs(res) do
                P[i]:GetChild('NoteField'):add_hidden_regions(res[i])
            end
        end}
    end	
}