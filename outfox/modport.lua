--[[
----
This is an edit of mirin-porting.lua to better suit the Lunar Template.
Please use the original if you plan to port using the Mirin Template.
----
]]--

xero()

return Def.Actor {
LoadCommand = function(self)
    bw, bh = 640, 480
    sm_scaleW, sm_scaleH = sw / bw, sh / bh
    sm_scaleR = sm_scaleW / sm_scaleH
    sm_fix = (FUCK_EXE and 0) or 1
    
    function CorrectZDist(actor)
        if not FUCK_EXE and actor and actor.GetNumChildren then
            actor:fardistz(1000 * sm_scaleW)
            for an = 0, actor:GetNumChildren() - 1 do
                CorrectZDist(actor:GetChildAt(an))
            end
        end
    end
    function CorrectFOV(actor, fov)
        if not FUCK_EXE and actor and actor.GetNumChildren then
            actor:fov(fov)
            for an = 0, actor:GetNumChildren() - 1 do
                CorrectFOV(actor:GetChildAt(an), fov)
            end
        end
    end
    
    alias
    {'confusionzoffset', 'confusionoffset'}	
    {'hidenoteflashes', 'hidenoteflash'}
    
        local PN = {}
        for pn = 1, 2 do
            if P[pn]:GetChild('NoteField'):GetNumWrapperStates() == 0 then
                P[pn]:GetChild('NoteField'):AddWrapperState()
            end
            PN[pn] = P[pn]:GetChild('NoteField'):GetWrapperState(1)
            PN[pn]:rotafterzoom(false)
        end
    
        local POptions = {
            GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song'),
            GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')
        }
        
        alias
        {'holdstealth', 'stealthholds'}
        {'centered2', 'centeredpath'}
        {'arrowpath', 'notepath'}
        {'arrowpath0', 'notepath1'}
        {'arrowpath1', 'notepath2'}
        {'arrowpath2', 'notepath3'}
        {'arrowpath3', 'notepath4'}
        
        for _, tween in ipairs {
            {'x', 1},
            {'y', 1},
            {'z', 1},
            {'rotationx', 1},
            {'rotationy', 1},
            {'rotationz', 1},
            {'skewx', 0.01},
            {'skewy', 0.01},
            {'zoomx', 0.01},
            {'zoomy', 0.01},
            {'zoomz', 0.01 * sm_scaleR},
        } do
            definemod {
                tween[1],
                function(n, pn)
                    if PN[pn] and PN[pn][tween[1]] then PN[pn][tween[1]](PN[pn], n * tween[2]) end
                end,
                defer = true
            }
        end
    
        definemod
        {
            'tiny',
            function(n)
                return n, n
            end,
            'tinyx', 'tinyy',
            defer = true
        }
        {
            'hide',
            function(n, pn)
                if PN[pn] then PN[pn]:visible(n <= 0) end
            end,
            defer = true
        }
        {
            'hidenoteflash',
            function(n)
                return n, n, n, n
            end,
            'hidenoteflash1', 'hidenoteflash2', 'hidenoteflash3', 'hidenoteflash4',
            defer = true
        }
        {
            'holdgirth',
            function(n)
                return -n, -n, -n, -n
            end,
            'holdtinyx1', 'holdtinyx2', 'holdtinyx3', 'holdtinyx4',
            defer = true
        }
        --[[ Under construction, use at your own risk
        {
            'mini',
            function(n)
                if PN[pn] then PN[pn]:zoomz(PN[pn]:GetZoomZ() * (1 / (1 - n * 0.005)))
                return n
            end,
            'mini',
            defer = true
        }
        ]]--

        for col = 1, 4 do
            for _, mod in ipairs {
                {'ConfusionXOffset', 0.01},
                {'ConfusionYOffset', 0.01},
                {'ConfusionZOffset', 0.01},
                {'MoveX', 0.01},
                {'MoveY', 0.01},
                {'MoveZ', 0.01},
                {'NoteSkewX', 0.01},
                {'NoteSkewY', 0.01},
                {'Dark', 1},
                {'Reverse', 1},
            } do
                local modname = mod[1]..col
                definemod {
                    string.lower(mod[1])..col - 1,
                    function(n, pn)
                        if POptions[pn] and POptions[pn][modname] then
                            POptions[pn][modname](POptions[pn], n * mod[2])
                        end
                    end,
                    defer = true
                }
            end
        end
    end
}
