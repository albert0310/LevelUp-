local M = {}
local composer = require "composer"
local json = require "json"
local fx = require "com.ponywolf.ponyfx" 

function M.new(Hero,world)
    local scene = composer.getScene(composer.getSceneName("current"))
    local parent = world
    --print(json.prettify())
    local scene =composer.getScene( composer.getSceneName("current") )
    --print(json.prettify(scene))
    --sprite
    local idle_sheet = graphics.newImageSheet( "assets/main-character/main-character-idle.png", {
        width= 70,
        height= 92,
        numFrames= 5,
    })
    local attack_sheet = graphics.newImageSheet( "assets/main-character/main-character-attack.png", {
            width= 105,
            height= 92,
            numFrames= 11
    })
    local dash_sheet = graphics.newImageSheet( "assets/main-character/main-character-dash.png", {
        width= 105,
        height= 92,
        numFrames= 2
    })
    local walk_sheet = graphics.newImageSheet( "assets/main-character/main-character-walk.png", {
        width= 70,
        height= 92,
        numFrames= 4
    })
    local jumping_sheet = graphics.newImageSheet( "assets/main-character/main-character-jumping.png", {
        width= 70,
        height= 92,
        numFrames= 4
    })
    
    local sequenceData = {
        {name = "idle",sheet = idle_sheet, frames = {1,2,3,4,5}, time = 1000, loopCount = 0},
        {name = "attack-1", sheet = attack_sheet, frames = {1, 2, 3, 4}, time = 350, loopCount = 1},
        {name = "attack-2", sheet = attack_sheet, frames = {5, 6, 7}, time = 350, loopCount = 1},
        {name = "attack-3", sheet = attack_sheet, frames = {8, 9, 10, 11}, time = 350, loopCount = 1},
        {name = "walk", sheet = walk_sheet, frames = {1, 2, 3, 4}, time = 1000, loopCount = 0},
        {name = "dash", sheet = dash_sheet, frames = {1, 2}, time = 200, loopCount = 1},
        {name = "jump", sheet = jumping_sheet, frames = {1, 2, 3, 4}, time = 300, loopCount = 1},
    }
    Hero = display.newSprite(parent, idle_sheet, sequenceData)
    Hero:setSequence("idle")
    Hero:play()
    --physics
    physics.addBody( Hero, "dynamic", { density = 1.5, bounce = 0.1, friction =  1, 
        filter = {categoryBits = 2, maskBits = 1}
    })
	Hero.isFixedRotation = true 

    --properties
    Hero.isHero = true
    Hero.isVisible = true
    local experience = 0
    local max_experience = 100
    local max_experience_increase = 100
    Hero.dashBool = true
    Hero.dashCD = 400
    Hero.direction = "right"
    Hero.level = 1
    Hero.maxHP = 150
    Hero.maxHP_increase = 50
    Hero.hp = 150
    Hero.armor = 1
    Hero.armor_increase = 1
    Hero.damage = 25
    Hero.damage_increase = 10
    Hero.name = "hero"
    local x, y = Hero.x, Hero.y

    --Skill Properties
    Hero.megaslashCD = 7
    Hero.megaslashBool = true
    Hero.earthshatterCD = 10
    Hero.earthshatterBool = true
    Hero.omnislashCD = 15
    Hero.omnislashBool = true
    Hero.crescentslashCD = 5
    Hero.crescentslashBool = true
    Hero.healCD = 17
    Hero.healBool = true
	Hero.lifestealCD = 25
    Hero.lifestealBool = true
    Hero.lifestealActiveCD = 10
    Hero.lifestealActive = false
    Hero.imunityCD = 20
    Hero.imunityBool = true
    Hero.imunityActiveCD = 5
    Hero.imunityActive = false
    

    --movement
    local max, acceleration, left, right, flip = 150, 750, 0, 0, 0
    local lastMovement = {}
    local att_times = 0
    local attackpattern = {}
    local function key(event)
        if(event.phase == lastMovement.phase) and (event.keyName == lastMovement.keyName) then return false end
        if event.phase == "down" and not parent.pause then
            if event.keyName == "left" or event.keyName == "a" then 
                left = -acceleration
                flip = -0.133
                Hero.direction = "left"
            end
            if event.keyName == "mright" or event.keyName == "d" then 
                right = acceleration
                flip = 0.133
                Hero.direction = "right"
            end
            if "space" == event.keyName or "jump" == event.keyName  then
                Hero:jump()
            end
            if (event.keyName == "dash" or event.keyName == "leftShift") and Hero.dashBool == true then
                Hero:dash()
            end
            if not (left == 0 and right == 0) and not Hero.jumping and not Hero.dashing then
                Hero:setSequence("walk")
                Hero:play()
            end
            if event.keyName == "attack" or event.keyName == "t" then
                att_times = att_times + 1
                if att_times > 3 then
                    att_times = 1
                end
                table.insert(attackpattern, att_times)
                Hero.isAttacking = true
            end
        end
        if event.phase == "up" and not parent.pause then
            if "left" == event.keyName or "a" == event.keyName then 
                left = 0
                Hero:setSequence("idle")
            end
			if "mright" == event.keyName or "d" == event.keyName then
                right = 0 
                Hero:setSequence("idle")
            end
            if event.keyName == "attack" or event.keyName == "t" then
                -- if att_times == 1 then
                --     Hero:setSequence("attack-1")
                --     Hero:play()
                -- elseif att_times == 2 then
                --     Hero:setSequence("attack-2")
                --     Hero:play()
                -- elseif att_times == 3 then
                --     Hero:setSequence("attack-3")
                --     Hero:play()
                --     att_times = 0
                -- end
                
                Hero:playAttSeq()
            end
            if right == 0 and left == 0 and not Hero.jumping then
                Hero:play()
            end
        end
        
        lastMovement = event
    end

    
    
    --functions
    local function onAttackComplete(event)
        local currentSequence = event.target.sequence
        local currentIndex = 0
        for i, name in ipairs(attackpattern) do
            if name == currentSequence then
                currentIndex = i
                break
            end
        end
        print(currentIndex)
        if currentIndex < #attackpattern then
            -- Play the next attack animation in the sequence
            local nextAttack = "attack-" .. attackpattern[currentIndex + 1]
            event.target:setSequence(nextAttack)
            event.target:play()
        else
            print("All attack animations completed!")
            Hero:setSequence("idle")
            -- You can perform additional actions here after the entire sequence is done
        end
    end

    local function spriteListener( event )
 
        local thisSprite = event.target  -- "event.target" references the sprite
     
        if ( event.phase == "ended" ) then 
            print(Hero.sequence)
            Hero:playAttSeq()
        end
    end

    function Hero:playAttSeq()
        print("wooooo")
        print(#attackpattern)
        print(json.prettify(attackpattern))
        if attackpattern[1] then
            Hero:setSequence("attack-"..table.remove(attackpattern,1))
            Hero:play()
        end
    end

    Hero:addEventListener("sprite", spriteListener)

    function Hero:dash()
        if not self.dashhing then
            if self.xScale > 0 then self:applyLinearImpulse( 120, 0)
            else self:applyLinearImpulse(-120, 0) end
            self:setSequence( "dash" )
            self:play()
			self.dashsing = true
            Hero.dashBool = false
        end
    end
    function Hero:jump()
		if not self.jumping then
			self:applyLinearImpulse( 0, -100 )
			self:setSequence( "jump" )
            self:play()
			self.jumping = true
		end
	end

    function Hero:gainExp(enemy, multiplier)
        --print(multiplier .. "multiplier")
        if enemy == "pocong" then
            experience = experience + (20 + 20 * multiplier) 
        elseif enemy == "kuyang" then
            experience = experience + (35 + 35 * multiplier)
        elseif enemy == "sundel" then
            experience = experience + (50 + 50 * multiplier)
        else
            experience = experience + (75 + 75 * multiplier)
        end
        if experience >= max_experience then
            Hero.level = Hero.level + 1   
            if experience > max_experience then
                experience = math.abs(experience - max_experience)
            end
            max_experience = max_experience + math.floor(max_experience_increase*multiplier)
            --print(max_experience .. "maxEXP")
            Hero.damage = Hero.damage + math.floor(Hero.damage_increase * multiplier * 0.1)
            Hero.armor = Hero.armor + (Hero.armor_increase * multiplier * 0.05)
            Hero.maxHP = Hero.maxHP +  math.floor(Hero.maxHP_increase * multiplier * 0,1)
            Hero.hp = Hero.hp +  math.floor(Hero.maxHP * 0.15)
            --print(Hero.hp .. "HP + " .. Hero.damage .. "DMG + " .. Hero.armor .. " Armor")
            if Hero.hp > Hero.maxHP then
                Hero.hp = Hero.maxHP
            end
        end
    end

    function Hero:hurt(damage)
        if not Hero.imunityActive then
            -- print (Hero.hp .. ' - ' .. Hero.maxHP)
            Hero.hp = Hero.hp - math.floor(math.max(1, damage - Hero.armor))
            if parent.score then
                if parent.player_death >= 3 then
                    composer.setVariable("finalScore", parent.score)
                    composer.gotoScene( "scenes.highscore")
                else
                    if Hero.hp <= 0 then
                        Hero:resurect()
                    end
                end
            end
            if Hero.hp <= 0 then
                fx.fadeOut( function()
                    composer.gotoScene( "scenes.menu")
                end )
            end
            
        end
    end

    function Hero:resurect()
        parent.player_death = parent.player_death + 1
        parent.decrease = true
        Hero.hp = Hero.maxHP
    end

    --function skills


    local function megaslashCDtick()
        Hero.megaslashCD = Hero.megaslashCD - 1
        if Hero.megaslashCD <= 0 then
             Hero.megaslashCD = 7
             Hero.megaslashBool = true
        end
    end

    function Hero:megaslash()
        Hero.megaslashBool = false
        local tm = timer.performWithDelay(1000,megaslashCDtick,Hero.megaslashCD)
    end

    local function earthshatterCDtick()
        Hero.earthshatterCD = Hero.earthshatterCD - 1
        if Hero.earthshatterCD <= 0 then
             Hero.earthshatterCD = 7
             Hero.earthshatterBool = true
        end
    end

    function Hero:earthshatter()
        Hero.earthshatterBool = false
        local tm = timer.performWithDelay(1000,earthshatterCDtick,Hero.earthshatterCD)
    end

    local function omnislashCDtick()
        Hero.omnislashCD = Hero.omnislashCD - 1
        if Hero.omnislashCD <= 0 then
             Hero.omnislashCD = 7
             Hero.omnislashBool = true
        end
    end

    function Hero:omnislash()
        Hero.omnislashBool = false
        local tm = timer.performWithDelay(1000,omnislashCDtick,Hero.omnislashCD)
    end

    local function crescentslashCDtick()
        Hero.crescentslashCD = Hero.crescentslashCD - 1
        if Hero.crescentslashCD <= 0 then
             Hero.crescentslashCD = 5
             Hero.crescentslashBool = true
        end
    end

    function Hero:crescentslash()   
        Hero.crescentslashBool = false
        local tm = timer.performWithDelay(1000,crescentslashCDtick,Hero.crescentslashCD)
    end

    local function healCDtick()
        -- print(Hero.healCD)
        Hero.healCD = Hero.healCD - 1
        if Hero.healCD <= 0 then
             Hero.healCD = 17
             Hero.healBool = true
        end
    end

    function Hero:heal()
        if Hero.healBool == true then
            Hero.hp = Hero.hp + 25 + (math.floor(Hero.maxHP*0.05))
            if Hero.hp > Hero.maxHP then
                Hero.hp = Hero.maxHP
            end
            Hero.healBool = false
            local tm = timer.performWithDelay(1000,healCDtick,Hero.healCD)
        end
    end

    local function lifestealCDtick()
        -- print(Hero.lifestealCD)
        Hero.lifestealCD = Hero.lifestealCD - 1
        if Hero.lifestealCD <= 0 then
             Hero.lifestealCD = 17
             Hero.lifestealBool = true
        end
    end
    
    local function lifestealActiveCDtick()
        Hero.lifestealActiveCD = Hero.lifestealActiveCD - 1
        if Hero.lifestealActiveCD <= 0 then
             Hero.lifestealActiveCD = 10
             Hero.lifestealActive = false
        end
    end

    function Hero:lifesteal()
        Hero.lifestealBool = false
        Hero.lifestealActive = true
        local tm = timer.performWithDelay( 1000, lifestealActiveCDtick , Hero.lifestealActiveCD )
        local tm = timer.performWithDelay(1000,lifestealCDtick,Hero.lifestealCD)
    end

    function Hero:lifestealActivate()
        if Hero.lifestealActive then
            Hero.hp = Hero.hp + math.floor(Hero.damage * 0.1)

            if Hero.hp > Hero.maxHP then
                Hero.hp = Hero.maxHP
            end
        end
    end
    
    local function imunityCDtick()
        -- print(Hero.lifestealCD)
        Hero.imunityCD = Hero.imunityCD - 1
        if Hero.imunityCD <= 0 then
             Hero.imunityCD = 17
             Hero.imunityBool = true
        end
    end
    
    local function imunityActiveCDtick()
        Hero.imunityActiveCD = Hero.imunityActiveCD - 1
        if Hero.imunityActiveCD <= 0 then
             Hero.imunityActiveCD = 10
             Hero.imunityActive = false
        end
    end

    function Hero:imunity()
        Hero.imunityBool = false
        Hero.imunityActive = true
        local tm = timer.performWithDelay( 1000, imunityCDtick , Hero.imunityCD )
        local tm = timer.performWithDelay(1000,imunityActiveCDtick,Hero.imunityActiveCD)
    end

    --collision
    function Hero:collision(event)
        local other = event.other
        local phase = event.phase
        local vx, vy = self:getLinearVelocity()
        if phase == "began" then
            if self.jumping and vy > 0 then
                self.jumping = false
                if not (left == 0 and right == 0) then 
                    self:setSequence("walk")
                    self:play()
                else
                    self:setSequence("idle")
                end
            end
        end
    end
    
    --event per Frame
    
    local function enterFrame()
        if not parent.pause then
            if Hero then
                local vx,vy = Hero:getLinearVelocity()
                local dx = left+right
                if (dx < 0 and vx > -max) or (dx > 0 and vx < max) then
                    Hero:applyForce(dx or 0, 0, Hero.x, Hero.y)
                end
                Hero.xScale = math.min(1, math.max(Hero.xScale + flip, -1))
                -- if Hero.sequence == "attack-1" or Hero.sequence == "attack-2" or Hero.sequence == "attack-3" then
                --     Hero.timer = timer.performWithDelay( 100,function ()
                --         if Hero then
                --             Hero:setSequence("idle")
                --             Hero:play()
                --         end
                --     end )
                -- end     
                if Hero.sequence == "dash" then
                    Hero.timer = timer.performWithDelay( 100,function ()
                        Hero:setSequence("idle")
                        Hero:play()
                    end )
                    Hero.dashing = false
                end
                if not Hero.dashBool then
                    Hero.dashCD = Hero.dashCD - 1
                    if Hero.dashCD <= 0 then
                        Hero.dashCD = 400
                        Hero.dashBool = true
                    end
                end
            end
        end
    end

    --add listeners
    function Hero:finalize()
        if Hero.timer then
			timer.cancel(Hero.timer)
		end
        -- print("hilang kan")
		Hero:removeEventListener( "collision" )
		Runtime:removeEventListener( "enterFrame", enterFrame )
		Runtime:removeEventListener( "key", key )
    end

    Hero:addEventListener("finalize")
    Hero:addEventListener("collision")
    Runtime:addEventListener("key",key)
    Runtime:addEventListener("enterFrame", enterFrame)
    
	return Hero
end
return M
