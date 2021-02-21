# Lunar Template
## *Wait...it's* all *Lua?*
> *[NotITG](https://notitg.heysora.net) is a fork of OpenITG designed to make it easier for mod file creators to implement their ideas. The [Mirin Template](https://www.github.com/XeroOl/notitg-mirin) provides functions that allow creators to use NotITG express their mod ideas and bring them to life in the game. -XeroOl*
###### Always has been.

The Mirin Template is an extremely powerful template that has an fast growing fanbase. With this power in mind, a Stepmania template has been created, but is not as greatly supported, and plugins for said template is not maintained in-house. Porting modfiles between NotITG and Stepmania has always been a great challenge, especially when dealing with Actors. What new syntax do I have to learn? Why is Quad not showing my texture? How do AFTs even work?

The [Lunar Template](https://github.com/sudospective/lunar-template) tries its best to fix these issues.

Built off the Mirin Template, the Lunar Template is an ongoing effort to make porting modfiles between NotITG and its Stepmania sister much less stressful and time-consuming. It uses the same syntax for modding, but uses a more SM-friendly approach to Actors.

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

---

## So, how do I port it?
You load the `mirin-porting.lua` script from Tiny-Foxes in your `mods.lua`, drag and drop your modfile into Stepmania, delete the `default.xml` in the `template` folder, and make minor edits until your file looks 1:1. That's really about it. If you need help with porting, feel free to send a message in the OutFox Discord and you'll be sure to get the help you need.

---

## Known Issues
- Extra players are not supported for SM5 (halted for OutFox)
- Shaders are not supported entirely (unfinished implementation)
- File breaks for SM5 (ironic but i really need to go to bed)

---

## To-Do
- Implement shaders for NotITG
- Merge files and use game-specific variables rather than game-specific files
- Thorough testing for both games

---
## Thank You to These People
[XeroOl](https://github.com/xerool) - Original Mirin Template  
[ArcticFqx](https://github.com/arcticfqx) - Recursive XML trick for NotITG  
[HeySora](https://github.com/heysora) - Encouragement and direction  
[Mr.ThatKid](https://github.com/mrthatkid) - Motivation and support  
