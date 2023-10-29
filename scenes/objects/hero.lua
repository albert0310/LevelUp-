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
        {name = "attack-1", sheet = attack_sheet, frames = {1, 2, 3, 4}, time = 150, loopCount = 1},
        {name = "attack-2", sheet = attack_sheet, frames = {5, 6, 7}, time = 150, loopCount = 1},
        {name = "attack-3", sheet = attack_sheet, frames = {8, 9, 10, 11}, time = 150, loopCount = 1},
        {name = "walk", sheet = walk_sheet, frames = {1, 2, 3, 4}, time = 1000, loopCount = 0},
        {name = "dash", sheet = dash_sheet, frames = {1, 2}, time = 200, loopCount = 1},
        {name = "jump", sheet = jumping_sheet, frames = {1, 2, 3, 4}, time = 300, loopCount = 1},
        --{name = "omega_slash", sheet = omega_slash_sheet, frames={1}, timer = 1300, loopCount= 0}
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
    local experience = 80
    local max_experience = 100
    Hero.dashBool = true
    Hero.dashCD = 350
    Hero.direction = "right"
    Hero.level = 1
    Hero.maxHP = 150
    Hero.hp = 150
    Hero.armor = 5
    Hero.damage = 25
    Hero.name = "hero"
	local x, y = Hero.x, Hero.y
    --movement
    local max, acceleration, left, right, flip = 150, 750, 0, 0, 0
    local lastMovement = {}
    local att_times = 0
    local function key(event)
        if(event.phase == lastMovement.phase) and (event.keyName == lastMovement.keyName) then return false end
        if event.phase == "down" and not parent.pause then
            if event.keyName == "left" or event.keyName == "a" then 
                left = -acceleration
                flip = -0.133
                Hero.direction = "left"
            end
            if event.keyName == "right" or event.keyName == "d" then 
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
                Hero.isAttacking = true
                if right > 0 then
                    right = acceleration / 2
                elseif left > 0 then
                    left = acceleration/2
                end
            end
        end
        if event.phase == "up" and not parent.pause then
            if "left" == event.keyName or "a" == event.keyName then 
                left = 0
                Hero:setSequence("idle")
            end
			if "right" == event.keyName or "d" == event.keyName then
                right = 0 
                Hero:setSequence("idle")
            end
            if event.keyName == "attack" or event.keyName == "t" then
                if att_times == 1 then
                    Hero:setSequence("attack-1")
                    Hero:play()
                elseif att_times == 2 then
                    Hero:setSequence("attack-2")
                    Hero:play()
                elseif att_times == 3 then
                    Hero:setSequence("attack-3")
                    Hero:play()
                    att_times = 0
                end
            end
            if event.keyName == "skill1" or event.keyName == "1" then
                Hero:setSequence("omega_slash")
                Hero:play()
                Hero.isAttacking = true
            end
            if right == 0 and left == 0 and not Hero.jumping then
                Hero:play()
            end
        end
        
        lastMovement = event
    end

    
    
    --functions
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

    function Hero:kill(enemy)
        if enemy == "pocong" then
            experience = experience + 20
        elseif enemy == "kuyang" then
            experience = experience + 25
        elseif enemy == "sundel" then
            experience = experience + 30
        else
            experience = experience + 50
        end
        if experience >= max_experience then
            Hero.level = Hero.level + 1   
            if experience > max_experience then
                experience = experience - max_experience
            end
            max_experience = max_experience + (max_experience*0.175)
            Hero.damage = Hero.damage + (Hero.damage * 0.2)
            Hero.armor = Hero.armor + (Hero.armor * 0.1)
        end
    end

    function Hero:hurt(damage)
        Hero.hp = Hero.hp - (damage - Hero.armor)
        print("HP " .. Hero.hp)
        if Hero.hp <= 0 then
            fx.fadeOut( function()
                composer.gotoScene( "scenes.menu")
            end )
        end
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
            --if self.isAttacking then
            --    if event.contact.isTouching and event.other.type == "rectangle" then
            --        event.other:removeSelf()
            --        print(json.prettify(event))
            --        self.isAttacking = false
            --    end
            --    
            --end
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

                if Hero.sequence == "attack-1" or Hero.sequence == "attack-2" or Hero.sequence == "attack-3" then
                    Hero.timer = timer.performWithDelay( 200,function ()
                        Hero:setSequence("idle")
                        Hero:play()
                    end )
                end 
                if Hero.sequence == "dash" then
                    Hero.timer = timer.performWithDelay( 200,function ()
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
        print("hilang kan")
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
