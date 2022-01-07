#
# Lunar Template

---

## *Wait...it's* all *Lua?*
> *[NotITG](https://notitg.heysora.net) is a fork of OpenITG designed to make it easier for mod file creators to implement their ideas. The [Mirin Template](https://www.github.com/XeroOl/notitg-mirin) provides functions that allow creators to use NotITG express their mod ideas and bring them to life in the game. -XeroOl*
###### Always has been.

The Mirin Template is an extremely powerful template that has an fast growing fanbase. With this power in mind, a Stepmania template has been created, but is not as greatly supported, and plugins for said template is not maintained in-house. Porting modfiles between NotITG and Stepmania has always been a great challenge, especially when dealing with Actors. What new syntax do I have to learn? Why is Quad not showing my texture? How do AFTs even work?

The [Lunar Template](https://github.com/sudospective/lunar-template) tries its best to fix these issues.

Built off the Mirin Template, the Lunar Template is an ongoing effort to make porting modfiles between NotITG and its OutFox sister much less stressful and time-consuming. It uses the same syntax for modding, but uses a more OutFox friendly approach to Actors.

(Full documentation for mods can be found [here](https://xerool.github.io/notitg-mirin))

---

## Syntax
#### Mods
```lua
-- turn on invert
ease {0, 1, outExpo, 100, 'invert'}
-- turn off invert
ease {7, 1, outExpo, 0, 'invert'}
```

#### Actors
```lua
-- make a quad
Def.Quad {
    Name = 'Quad',
    OnCommand = function(self) self:zoom(64) end
},
-- make an actorframe with children
Def.ActorProxy {
    Name = 'ActorFrame',
    Def.ActorProxy {
        Name = 'ActorProxy',
        OnCommand = function(self)
            self:SetTarget(myActor)
        end
    },
    Def.Sprite { Name = 'Sprite', Texture = 'myTexture.png' }
}
```

#### Recursive Actors
```lua
xero() -- outside the main actorframe
-- make an empty actorframe called myActor
local recursive_quads = Def.ActorFrame { Name = "myActor" }
-- for-loop and add 10 quads
for i = 1, 10 do
    t[#t + 1] = Def.Quad { Name = "Quad" .. i }
end
return Def.ActorFrame {
    LoadCommand = function(self)
    ... -- Mods
    end,
    -- add it as a child to main actorframe
    recursive_quads,
    -- other actors
    Def.ActorProxy { Name = 'PP[1]' },
    Def.ActorProxy { Name = 'PP[2]' },
    ... -- Actor
}
```

---

## So, how do I port it?
~~You load the `mirin-porting.lua` script from Tiny-Foxes in your `mods.lua`, drag and drop your modfile into Stepmania, delete the `default.xml` in the `template` folder, and make minor edits until your file looks 1:1. That's really about it. If you need help with porting, feel free to send a message in the OutFox Discord and you'll be sure to get the help you need.~~ Most of the porting is done for you, thanks to the `modport.lua` script. Some things, like AFTs and tween scaling, may need some additional polish, but the bulk of it all should be done from here. In fact, you could even make separate actor files for NotITG and OutFox, if you really want porting to be virtually seamless.

---

## What about collabs?
You can supercharge them. Take the Mirin template's quick modwriting and powerful node system to the next level with Lunar's elegant actor syntax and extreme portability.
Some recommended setups for different use cases:

---
#### Just Mods
```lua
-- in mods.lua
xero()
return Def.ActorFrame {
    LoadCommand = function(self)
    ... -- Mods
        loadfile('lua/sudo.lua')() -- Sudo
        loadfile('lua/xero.lua')() -- Xero
    end,
    ... -- Actors
}

-- in sudo.lua
xero()
ease {6, 4, spike, -200, 'tiny'}
... -- Mods
```
#### Mods and Actors
```lua
-- in mods.lua
xero()
return Def.ActorFrame {
    LoadCommand = function(self)
        ... -- Mods
    end,
    loadfile('lua/sudo.lua')(), -- Sudo
    loadfile('lua/xero.lua')(), -- Xero
    ... -- Actors
}

-- in sudo.lua
xero()
return Def.ActorFrame {
    Name = 'Sudo' -- optional but useful
    LoadCommand = function(self)
        ease {6, 4, spike, -200, 'tiny'}
        ... -- Mods
    end,
    Def.Quad { Name = 'TheBoy' }
    ... -- Actors
}
```
#### Mods, Actors, and Assets
```lua
-- in mods.lua
xero()
return Def.ActorFrame {
    LoadCommand = function(self)
        ... -- Mods
    end,
    loadfile('lua/sudo/mods.lua')(), -- Sudo
    loadfile('lua/xero/mods.lua')(), -- Xero
    ... -- Actors
}

-- in sudo.lua
xero()
return Def.ActorFrame {
    Name = 'Sudo'
    LoadCommand = function(self)
        ease {6, 4, spike, -200, 'tiny'}
        ... -- Mods
    end,
    Def.Sprite { Name = 'Beb', Texture = 'lua/sudo/warmfren.png' }
    ... -- Actors
}
```
The Lunar Template is designed to fit and streamline your style.

---

## Known Issues
- ~~Extra players are not supported for SM5 (halted for OutFox)~~ Supported in OutFox! Have fun <3
- AFTs are not perfectly portable (needs significant effort to fix)

---

## To-Do
1. Look into possible ways to port AFTs 1:1

---
## Huge Warm Hugs to These People
[XeroOl](https://github.com/xerool) - Original Mirin Template  
[ArcticFqx](https://github.com/arcticfqx) - Recursive XML trick for NotITG  
[HeySora](https://github.com/heysora) - Encouragement and direction  
[Mr.ThatKid](https://github.com/mrthatkid) - Motivation and support  
[Kinoseidon](https://github.com/kinoseidon) - Direct contributor!  
