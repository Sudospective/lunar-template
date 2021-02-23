-- If you edit template.xml, reflect the change here
local nodesPerAF = 10
local templatepath = "../notitg/actors.xml"

-- End of config

--[[ 
    geno is a library for creating screens in a similar way 
    to how SM5's Def tables work.

    Part of the nitg-theme project: https://github.com/ArcticFqx/nitg-theme/
]]

actorgen = { 
    Actors = {}, 
    ActorByName = {}, 
    NameByActor = {},
    TemplateByActor = {},
    ActorFrame = {},
    Overlay = { _ = "ignore", n = 0 }
}

local log = nodesPerAF == 10
            and math.log10
            or  function(n)
                    return math.log(n)/math.log(nodesPerAF) 
                end

local stack = {}

local ceil = math.ceil
local getn = table.getn
local lower = string.lower

local typespec = xero.loadscript("notitg/typespec.lua")

local function GetDepth(t)
    local depth = ceil(log(getn(t)))
    return depth > 0 and depth or 1
end

local smeta = {}

function smeta:Push(entry)
    self[getn(self) + 1] = entry
end

function smeta:Pop()
    local t = self[getn(self)]
    self[getn(self)] = nil
    return t
end

function smeta:Top()
    return self[getn(self)]
end

function smeta:NewLayer(t)
    self:Push {
        template = t, -- current layer
        depth = GetDepth(t), -- depth of tree structure
        width = getn(t), -- width of layer
        cd = 1, -- current depth
        i = 0, -- current template index
        l = {}, -- current index of node
        a = {} -- actorgen.Actors clone
    }
end

smeta.__index = smeta

-- This runs first
function actorgen.Cond(index, type)
    local s = stack:Top()
    s.l[s.cd] = index
    
    if s.width <= s.i then
        return false
    end
    return true
end

function actorgen.Type()
    local s = stack:Top()
    if s.cd < s.depth then
        return
    end
    s.i = s.i + 1
    local template = s.template[s.i]
    if lower(template.Type) == "actorframe" then
        if table.getn(template) > 0 then
            return
        end
    end
    if typespec[template.Type].Type then
        template.Type = typespec[template.Type].Type
    end
    return typespec[template.Type].Type
end

-- This runs second
function actorgen.File()
    local s = stack:Top()

    if s.cd < s.depth then
        s.cd = s.cd + 1
        --print("Depth["..table.getn(stack).."]:", s.cd-1, "->", s.cd)
        return templatepath
    end

    local template = s.template[s.i]

    if lower(template.Type) == "actorframe" then
        if table.getn(template) > 0 then
            stack:NewLayer(template)
            s.a[s.i] = stack:Top().a
            --print("NewAF["..table.getn(stack).."]:", 0, "->", 1)
            return templatepath
        end
    end

    if template.File then
        local rel = string.find(template.File, "^/") and "../" or ""
        print(rel..template.File)
        return rel .. template.File
    end

    return typespec[template.Type].File or nil
end

local function patchFunctionChaining(actor)
    --[[
    local mt,at = getmetatable(actor),{}
    for k,v in pairs(mt) do
        mt[k],at[k] = nil,v
    end
    function mt:__index(k)
        return function(...)
            return at[k](unpack(arg)) or arg[1]
        end
    end
    mt.__actorgen = true
    setmetatable(mt, mt)
    --]]
end

function actorgen:Meta()
    local s = stack:Top()
    local template = s.template[s.i]
    local meta = typespec[template.Type][self]
    if meta then
        return meta(template)
    end
end

function actorgen:RegisterOverlay()
    local name = self:GetName()
    if actorgen.Overlay[name] then return end
    if name == "" then
        actorgen.Overlay.n = actorgen.Overlay.n+1
        name = tostring(actorgen.Overlay.n)
        self:SetName(name)
    end

    actorgen.Overlay[self] = name
    actorgen.Overlay[name] = self
end

-- This runs third
function actorgen:Init()
    local s = stack:Top()
    if s.cd < 1 then
        s.a[0] = self
        actorgen.ActorFrame[self] = s.a
        stack:Pop()
        s = stack:Top()
    end
    local template = s.template[s.i]

    if s.cd == s.depth then
        if not s.a[s.i] then
            s.a[s.i] = self
        end
        actorgen.TemplateByActor[self] = template
        if template.Name then
            actorgen.ActorByName[template.Name] = self
            actorgen.NameByActor[self] = template.Name
            self:SetName(template.Name)
        end
        typespec[template.Type].Init(self, template)

        for k, v in pairs(template) do
            if string.len(k) > 8 and string.sub(k, -7, -1) == "Command" then
                --print(k)
                local cmd_name = string.sub(k, 1, -8)
                if self:hascommand(cmd_name) then self:removecommand(cmd_name) end
                self:addcommand(cmd_name, v)
                --if cmd_name == "Init" then self:playcommand("Init") end
            end
        end
    else
        self:SetName("_")
    end

    if template.Texture then
        self:Load(GAMESTATE:GetCurrentSong():GetMusicPath() .. "/../" .. template.Texture)
    end

    if s.l[s.cd] >= nodesPerAF or s.width <= s.i then
        s.cd = s.cd - 1
        --print("Depth["..table.getn(stack).."]:", s.cd+1, "->", s.cd)
    end

end

-- These runs at the very end when everything has been built
function actorgen:InitCmd(a)
    local s = stack:Top()
    local template = s.template
    actorgen.Actors[0] = self
    actorgen.TemplateByActor[self] = template
    if template.Name then
        actorgen.ActorByName[template.Name] = self
        actorgen.NameByActor[self] = template.Name
        self:SetName(template.Name)
    end
    typespec[template.Type].Init(self, template)
end

-- OnCommand Time
function actorgen:OnCmd(a)
    a = a or actorgen.Actors
    for k,v in ipairs(a) do
        if type(v) == "table" then
            actorgen.OnCmd(self, v)
        else
            typespec[v].On(v, actorgen.TemplateByActor[v])
        end
    end
    typespec[a[0]].On(a[0], actorgen.TemplateByActor[a[0]])
end

-- Called from Root
function actorgen.Template(template)
    actorgen.Actors = {}
    actorgen.ActorByName = {}
    actorgen.NameByActor = {}
    actorgen.TemplateByActor = {}
    actorgen.ActorFrame = {}
    stack = setmetatable({},smeta)
    stack:NewLayer(template)
    local s = stack:Top()
    s.a = actorgen.Actors
    --print("Depth["..table.getn(stack).."]:", s.cd-1, "->", s.cd)
    return true
end

local defmeta = {}
function defmeta:__call(append)
    for _,v in ipairs(append) do
        table.insert(self, v)
    end
end

actorgen.Def = {}
function actorgen.Def:__index(k)
    return function(t)
        t.Type = k
        return setmetatable(t, defmeta)
    end
end

Def = {}
setmetatable(Def, actorgen.Def)

return actorgen