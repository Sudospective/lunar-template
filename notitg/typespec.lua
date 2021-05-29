local generic, runcommand
local typespec = {
    BitmapText = {
        File = "../notitg/bitmaptext.xml",
        Init = function( actor, template )
			local init = template.InitCommand
			if type(init) == "function" then
				init( actor, template )
			end
        end,
		FileText = function( template )
			return template.Text or ""
		end,
		FileFont = function( template )
			local font = template.Font
			if font then
				print("RETURNING FONT", font)
				return font
			end
			return "eurostile _normal"
		end,
		On = function( actor, template )
			local on = template.OnCommand
			if type(on) == "function" then
				on( actor, template )
			end
		end
    },
    Shader = {
        File = "../notitg/shader.xml",
        Init = function( actor, template )
            local dummy = actor:GetChildAt(0)
            local shader = dummy:GetShader()
            local init = template.InitCommand
            if type(init) == "function" then
                init( shader, template )
            end
			actor:SetName('')
			dummy:SetName(template.Name)
        end,
        FileFrag = function( template )
            local frag = template.Frag
            if frag then
                print("RETURNING FRAG","../" .. frag)
                return "../" .. frag
            end
            return 'nop.frag'
        end,
        FileVert = function( template )
            local vert = template.Vert
            if vert then
                print("RETURNING VERT","../" .. vert)
                return "../" .. vert
            end
            return 'nop.vert'
        end,
        On = function(actor, template)
            local on = template.OnCommand
            if type(on) == "function" then
                on( actor:GetChildAt(0):GetShader(), template )
            end
        end
    },
    Quad = { Type = "Quad" },
    Sprite = { Type = "Sprite" },
    Text = { Type = "BitmapText" },
    ActorFrameTexture = { Type = "ActorFrameTexture" },
    AFT = { Type = "ActorFrameTexture" },
    Polygon = { Type = "Polygon" },
    Poly = { Type = "Polygon" },
    ActorMultiVertex = { Type = "Polygon" },
    AMV = { Type = "Polygon" },
    ActorSound = { Type = "ActorSound" },
    Sound = { Type = "ActorSound" },
    Audio = { Type = "ActorSound" },
    Actor = { Type = "Actor" },
    Aux = { Type = "Actor" },
    Proxy = { Type = "ActorProxy" },
    ActorProxy = { Type = "ActorProxy" },
    ActorFrame = { },
}

local function runcommand(actor, template, kind)
    local func = template[kind]
    if func then
        if type(func) == "string" then
            actor:cmd(func)
        elseif type(func) == "function" then
            return func(actor, template)
        end
    end
end

generic = {
    Init = function (actor, template)
        actor:xy(template.X or 0, template.Y or 0)
        return runcommand(actor, template, "InitCommand")
    end,
    On = function (actor, template)
        return runcommand(actor, template, "OnCommand")
    end
}

setmetatable( typespec, {
    __index = function()
        return generic
    end
})

local tsmeta = { __index = generic }
for _,v in pairs(typespec) do
    setmetatable(v, tsmeta)
end

return typespec
