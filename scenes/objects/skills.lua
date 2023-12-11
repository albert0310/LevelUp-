local M = {}
local composer = require "composer"
local json = require "json"
local fx = require "com.ponywolf.ponyfx" 
local bullet = require "scenes.objects.bullet"

function M.new(Skill, hero, world)
    local parent = world
    local omega_slash_sheet = graphics.newImageSheet( "assets/main-character/skills/omega-slash (2).png", {
        width = 300,
        height = 240,
        numFrames = 5,
    })
    local earth_shatter_sheet = graphics.newImageSheet( "assets/main-character/skills/earth-shatter.png", {
        width = 1800/6,
        height = 240,
        numFrames = 6,
    })
    local omni_slash_sheet = graphics.newImageSheet( "assets/main-character/skills/omni-slash.png", {
        width= 1600/4,
        height = 200,
        numFrames = 4
    })
    local crescent_slash_sheet = graphics.newImageSheet( "assets/main-character/skills/crescent.png", {
        width= 248/4,
        height = 100,
        numFrames = 4
    })
    local sequenceData = {
        {name = "omega_slash", sheet = omega_slash_sheet,frames = {1,2,3,4,5}, time = 350, loopCount= 1},
        {name = "earth_shatter", sheet = earth_shatter_sheet, frames= {1,2,3,4,5,6}, time = 700, loopCount=1},
        {name = "omni_slash", sheet = omni_slash_sheet, frames= {1,2,3,4}, time = 450, loopCount=3},
        {name = "crescent_slash", sheet = crescent_slash_sheet, frames= {4,3,2,1}, time = 450, loopCount=1},

    }
    Skill = display.newSprite( parent ,omega_slash_sheet, sequenceData )
    Skill.x,Skill.y = hero.x, hero.y
    Skill.isFixedRotation = true 
    Skill.isVisible = false
    Skill.CD = 0
    Skill.CDtemp = 0
    Skill.Available = true
    Skill.rangexmin = 0
    Skill.rangexmax = 0

    function Skill:megaslash()
        Skill.isVisible = true
            hero.isVisible = false
            Skill:setSequence("omega_slash")
            Skill:play()
            Skill.timer = timer.performWithDelay( 500,function ()
                Skill.isVisible = false
                hero.isVisible = true
            end )
            Skill.Available = false;
    end

    function Skill:earthshatter()
        Skill.isVisible = true
        hero.isVisible = false
        Skill:setSequence("earth_shatter")
        Skill:play()
        Skill.timer = timer.performWithDelay( 800,function ()
            Skill.isVisible = false
            hero.isVisible = true
        end )
        Skill.Available = false;
    end

    function Skill:omnislash()
        Skill.isVisible = true
        hero.isVisible = false
        Skill:setSequence("omni_slash")
        Skill:play()
        Skill.timer = timer.performWithDelay( 1000,function ()
            Skill.isVisible = false
            hero.isVisible = true
        end )
        Skill.Available = false
    end

    function Skill:crescentslash()
        Skill.isVisible = true
        Skill:setSequence("crescent_slash")
        Skill:play()
        transition.to(Skill, {
            x = hero.x + (250*hero.xScale),
            y = hero.y - 20,
            time = 450
        })
        Skill.timer = timer.performWithDelay( 450,function ()
            Skill.isVisible = false
        end )
        Skill.Available = false
    end

    local function enterFrame()
        if hero then
            Skill.xScale = hero.xScale
            Skill.x,Skill.y = hero.x + (50*Skill.xScale), hero.y - 70   
            --print(Skill.x .. " - " .. Skill.y .. " || " .. hero.x .. " - " .. hero.y) 
            if not Skill.Available then
                Skill.CD = Skill.CD - 1
                if Skill.CD <= 0 then
                    Skill.CD = Skill.CDtemp
                    Skill.Available = true
                end
            end
        end
    end

    function Skill:finalize()
        if Skill.timer then
			timer.cancel(Skill.timer)
		end
        Runtime:removeEventListener( "enterFrame", enterFrame )
        Runtime:removeEventListener("key", key)
    end

    Skill:addEventListener("finalize")
    Runtime:addEventListener("enterFrame", enterFrame)
    
    return Skill
end
return M