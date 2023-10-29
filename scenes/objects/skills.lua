local M = {}
local composer = require "composer"
local json = require "json"
local fx = require "com.ponywolf.ponyfx" 

function M.new(Skill, hero, world)
    local parent = world
    local omega_slash_sheet = graphics.newImageSheet( "assets/main-character/skills/omega-slash (2).png", {
        width= 300,
        height= 240,
        numFrames= 5,
    })
    local sequenceData = {
        {name = "omega_slash", sheet = omega_slash_sheet,frames = {1,2,3,4,5}, time = 350, loopCount= 1}
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
    local function key(event)
        if (event.keyName == "skill1" or event.keyName == "1") and Skill.Available then
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
    end

    local function enterFrame()
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

    function Skill:finalize()
        if Skill.timer then
			timer.cancel(Skill.timer)
		end
        Runtime:removeEventListener( "enterFrame", enterFrame )
        Runtime:removeEventListener("key", key)
    end

    Skill:addEventListener("finalize")
    Runtime:addEventListener("key",key)
    Runtime:addEventListener("enterFrame", enterFrame)
    
    return Skill
end
return M