--[[
----
MIRIN-PORTING.LUA v2.0
THE QUINTESSENTIAL PORTING SCRIPT FOR MIRIN 2.0

Created by Sudospective
Special thanks to Mr. ThatKid
----

----
If you plan on using this porting script there are a few things you should do:

- CorrectZDist(self) and CorrectFOV(self) in main ActorFrame
- Load external Lua through loadfile(path_to_lua)
  (thats the whole point of this script's purpose ~wo)

There are a lot more changes to consider, mainly everything listed under alias below.

If you find any mods that don't work right and need to be ported, @ me in the UKSRT
Discord or send me a DM, and I'll look into it when I have the time.

(also not to be self-selling or whatever but i could use more twitter followers @sudospective)

(also also check out my website its fun https://sudospective.net)

Happy porting!
----
(This has been edited by Sudospective to better suit the Lunar Template. Please use the original if you plan to port using the Mirin Template.)
]]--

xero()

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

-- Generic Conversions

{'confusionzoffset', 'confusionoffset'}							-- Confusion Z offset alias hack
{'hidenoteflashes', 'hidenoteflash'}

-- SM Specific Conversions
if not FUCK_EXE then

    -- Player Notefield
    local PN = {}
    for pn = 1, 2 do
        if P[pn]:GetChild('NoteField'):GetNumWrapperStates() == 0 then
            P[pn]:GetChild('NoteField'):AddWrapperState()
        end
        PN[pn] = P[pn]:GetChild('NoteField'):GetWrapperState(1)
        PN[pn]:rotafterzoom(false)
    end

    -- Player Options
    local POptions = {
        GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song'),
        GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')
    }
    
    -- These mods were aliased from NotITG to OutFox. You can use them like you already do.
    alias
    {'holdstealth', 'stealthholds'}									-- Hold stealth
    {'centered2', 'centeredpath'}									-- Cenetered but math that makes sense
    {'arrowpath', 'notepath'}										-- Arrow path
    {'arrowpath0', 'notepath1'}										-- Arrow path 1
    {'arrowpath1', 'notepath2'}										-- Arrow path 2
    {'arrowpath2', 'notepath3'}										-- Arrow path 3
    {'arrowpath3', 'notepath4'}										-- Arrow path 4
    --[[
    For reference, these mods were defined for OutFox using Actor tweens or existing mods:
    ----
    'x', 'y', 'z'													-- X, Y, and Z position tweenmods
    'rotationx', 'rotationy', 'rotationz'							-- X, Y, and Z rotation tweenmods
    'zoomx', 'zoomy', 'zoomz'                                       -- X, Y, and Z zoom tweenmods
    'tiny'														    -- Tiny
    'hide'														    -- Hide
    'hidenoteflash'												    -- Hide note flash
    'holdgirth'													    -- Hold girth
    ---
    ]]--
    
    -- NON-COLUMN
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
            tween,
            function(n, pn)
                if PN[pn] then PN[pn][tween](PN[pn], n) end
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

    -- COLUMN
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
            {'Reverse', 1}
        } do
            local modname = mod..col
            definemod {
                string.lower(mod)..col - 1,
                function(n, pn)
                    if POptions[pn] then
                        POptions[pn][modname](POptions[pn], n, -1)
                    end
                end,
                defer = true
            }
        end
    end
end

return Def.Actor {}
