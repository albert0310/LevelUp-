local M = {}
local composer = require "composer"
local json = require "json"
local color = require "com.ponywolf.ponycolor"

function M.new(Enemy, type, hero)
    local scene = composer.getScene(composer.getSceneName("current"))
    if not Enemy then error("ERROR: Expected display object") end
	Enemy.isVisible = false
    local parent = Enemy.parent
	local x, y = Enemy.x, Enemy.y
    --pocong 
	local pocong_idle = graphics.newImageSheet( "assets/enemy/Pocong-Sheet_idle.png", {
        width= 39,
        height= 102,
        numFrames= 4
    })
	local pocong_walk = graphics.newImageSheet( "assets/enemy/Pocong-Sheet_walk.png", {
        width= 42,
        height= 110,
        numFrames= 4
    })
	local pocong_attack = graphics.newImageSheet( "assets/enemy/Pocong-Sheet_attack.png", {
        frames ={
			--f1
			{
				x = 1,
				y = 1,
				width = 46,
				height = 98,
			},
			--f2
			{
				x= 47,
				y= 1,
				width = 64,
				height = 98
			},
			--f3
			{
				x= 112,
				y= 1,
				width = 144,
				height = 98
			},
			--f4
			{
				x= 256,
				y= 1,
				width= 102,
				height= 40
			},
			--f5
			{
				x = 358,
				y = 1,
				width = 50,
				height = 98
			}
		}
    })
	local pocong_sequenceData = {
		{ name = "idle", sheet = pocong_idle, frames = { 1, 2, 3, 4 }, time = 500, loopCount= 0 },
		{ name = "walk", sheet = pocong_walk, frames = { 1, 2, 3, 4 } , time = 500, loopCount = 0 },
        { name = "attack", sheet = pocong_attack, frames = {1, 2, 3, 4, 5}, time = 750, loopCount = 1}	
	}
	--kuyang
	local kuyang_sheet = graphics.newImageSheet( "assets/enemy/Kuyang-Sheet.png", {
        frames = {
			--idle
			{
				x = 1, y = 1,
				width = 80,height = 80
			},
			{
				x = 116, y = 1, 
				width = 80,height = 80
			},
			{
				x = 250, y = 1,
				width = 80,height = 80
			},
			{
				x = 378, y = 1,
				width = 80,height = 80
			},
			--walk
			{
				x = 1, y = 80,
				width = 70, height = 80
			},
			{
				x = 120, y = 80,
				width = 70, height = 80
			},
			{
				x = 270, y = 80,
				width = 52, height = 80
			},
			{
				x = 380, y = 80,
				width = 70, height = 80
			},
			--attack
			{
				x = 1, y = 160,
				width = 125, height = 80
			},
			{
				x = 128, y = 160,
				width = 80, height = 80
			},
			{
				x = 246, y = 160,
				width = 78, height = 80
			},
			{
				x = 378, y = 160,
				width = 125, height = 80
			},
		}
    })
    
	local kuyang_sequenceData = {
			{ name = "idle", frames = { 1, 2, 3, 4 }, time = 600, loopCount= 0 },
			{ name = "walk", frames = { 5, 6, 7, 8 } , time = 500, loopCount = 0 },
		    { name = "attack", frames = {11, 9, 12, 10}, time = 750, loopCount = 1}	
	}

	--kuntilanak
	local sundel_sheet = graphics.newImageSheet( "assets/enemy/Sundelbolong-Sheet.png", {
        frames = {
			--idle
			{
				x = 1, y = 30,
				width = 98,height = 105
			},
			{
				x = 144, y = 30, 
				width = 96,height = 105
			},
			{
				x = 290, y = 30,
				width = 90,height = 105
			},
			{
				x = 440, y = 30,
				width = 90,height = 105
			},
			--walk
			{
				x = 1, y = 165,
				width = 98, height = 110
			},
			{
				x = 144, y = 165,
				width = 96, height = 110
			},
			{
				x = 280, y = 165,
				width = 100, height = 110
			},
			{
				x = 438, y = 165,
				width = 90, height = 110
			},
			--attack
			{
				x = 1, y = 300,
				width = 96, height = 115
			},
			{
				x = 138, y = 300,
				width = 100, height = 115
			},
			{
				x = 280, y = 280,
				width = 156, height = 140
			},
			{
				x = 440, y = 300,
				width = 90, height = 115
			},
		}
    })

	local sundel_sequenceData = {
		{ name = "idle", frames = { 1, 2, 3, 4 }, time = 500, loopCount= 0 },
		{ name = "walk", frames = { 5, 6, 7, 8 } , time = 500, loopCount = 0 },
		{ name = "attack", frames = {9, 10, 11, 12}, time = 750, loopCount = 1}	
	}	
	--buto
	local buto_sheet = graphics.newImageSheet( "assets/enemy/Buto_Ijo-Sheet.png", {
		width = 836/4,     -- sheet width / total columns
		height = 492/3,    -- sheet height / total rows
		numFrames = 12     -- columns * rows
    })

	local buto_sequenceData = {
		{ name = "idle", frames = { 1, 2, 3, 4 }, time = 700, loopCount= 0 },
		{ name = "walk", frames = { 5, 6, 7, 8 } , time = 800, loopCount = 0 },
		{ name = "attack", frames = {9, 10, 11, 12}, time = 750, loopCount = 1}	
	}	

    if type == "pocong" then
		Enemy = display.newSprite( parent,pocong_idle, pocong_sequenceData )
		Enemy.x, Enemy.y = x, y
		Enemy:setSequence( "idle" )
		Enemy:play()
        physics.addBody( Enemy, "dynamic", { density = 0.5, bounce = 0.2, friction =  0.1 , 
        	filter = {categoryBits = 2, maskBits = 1}
		} )
	elseif type == "kuyang" then
		Enemy = display.newSprite( parent, kuyang_sheet, kuyang_sequenceData )
		Enemy.x, Enemy.y = x, y
		Enemy.xScale, Enemy.yScale = 0.7, 0.8
		Enemy:setSequence( "idle" )
		Enemy:play()
        physics.addBody( Enemy, "dynamic", { density = 0.5, bounce = 0.2, friction =  0.1 , 
        	filter = {categoryBits = 2, maskBits = 1}
		} )
	elseif type == "buto" then
		Enemy = display.newSprite( parent,buto_sheet, buto_sequenceData )
		Enemy.x, Enemy.y = x, y
		Enemy.anchorY = 1
		Enemy:setSequence( "idle" )
		Enemy:play()
        physics.addBody( Enemy, "dynamic", { density = 0.75, bounce = 0.1, friction =  0.1 , 
        	filter = {categoryBits = 2, maskBits = 1}
		} )
	elseif type == "sundel" then
		Enemy = display.newSprite( parent, sundel_sheet, sundel_sequenceData )
		Enemy.x, Enemy.y = x, y
		Enemy.xScale, Enemy.yScale = 0.7, 0.8
		-- Enemy.anchorY = 1
		Enemy:setSequence( "idle" )
		Enemy:play()
        physics.addBody( Enemy, "dynamic", { density = 0.75, bounce = 0.2, friction =  0.1 , 
        	filter = {categoryBits = 2, maskBits = 1}
		} )
	end
	
	Enemy.isSensor = false
	Enemy.isFixedRotation = true
	Enemy.angularDamping = 3
	Enemy.isDead = false
	Enemy.isAttacking = false
    local max, direction, flip, timeout = 250, 5000, 0.133, 0
	direction = direction * ( ( Enemy.xScale < 0 ) and 1 or -1 )
	flip = flip * ( ( Enemy.xScale < 0 ) and 1 or -1 )

	if type == "pocong" then
		Enemy.hp = 60
		Enemy.acceleration = 100
		Enemy.max = 90
		Enemy.attackTimer = 6
		Enemy.attackCD = 6
		Enemy.damage = 8
	elseif type == "kuyang" then
		Enemy.hp = 30
		Enemy.acceleration = 130
		Enemy.max = 110
		Enemy.attackTimer = 4
		Enemy.attackCD = 4
		Enemy.damage = 5
	elseif type == "buto" then
		Enemy.hp = 150
		Enemy.acceleration = 140
		Enemy.max = 110
		Enemy.attackTimer = 10
		Enemy.attackCD = 10
		Enemy.damage = 15
	elseif type == "sundel" then
		Enemy.hp = 80
		Enemy.acceleration = 100
		Enemy.max = 100
		Enemy.attackTimer = 7
		Enemy.attackCD = 7
		Enemy.damage = 9
	end


	--function
	local function enemyAttackCDtick()
		Enemy.attackTimer = Enemy.attackTimer - 1
		if Enemy.attackTimer <= 0 then
			Enemy.attackTimer = Enemy.attackCD
			Enemy.isAttacking = false
		end
	end

	function Enemy:hurt(damage)
		Enemy.hp = Enemy.hp - damage
		if Enemy.hp <= 0 then
			if Enemy.timer then
				timer.cancel( Enemy.timer )
			end
			if Enemy then
				Enemy.isDead = true
				Enemy:removeSelf()
			end
		end
	end

	function Enemy:attack()
		
		if Enemy.isAttacking == false then
			print(Enemy.type .. " - " .. Enemy.x .. " - " .. Enemy.y)
			Enemy:setSequence("attack")
			Enemy:play()
			Enemy.timer = timer.performWithDelay( 600, function()
				if Enemy then
					Enemy:setSequence("idle")
					Enemy:play()
				end
			end )
			hero:hurt(Enemy.damage)
			Enemy.isAttacking = true
			local tm = timer.performWithDelay(1000,enemyAttackCDtick,Enemy.attackCD)
		end	
	end

    local function enterFrame()
		if not parent.pause then
			if not Enemy.isDead and (Enemy.x < hero.x+400 and Enemy.x > hero.x-400) and (Enemy.y < hero.y+150 and Enemy.y > hero.y-150)then
				local vx, vy = Enemy:getLinearVelocity()
				local direction =  hero.x - Enemy.x
				local left, right = 0, 0
				if direction < 0 then
					Enemy.flip = -0.133
					left = -Enemy.acceleration 
				elseif direction > 0 then
					Enemy.flip = 0.133
					right = Enemy.acceleration
				end
				local dx = left+right
				if (dx < 0 and vx > -Enemy.max and Enemy.x > hero.x) or (dx > 0 and vx < Enemy.max and Enemy.x < hero.x )then
					if Enemy.name == "buto" then
						if not ((Enemy.x > hero.x-120 and Enemy.x < hero.x ) or (Enemy.x < hero.x+120 and Enemy.x > hero.x ))then
							Enemy:applyForce(dx or 0, 0, Enemy.x, Enemy.y)
						end
					else
						if not ((Enemy.x > hero.x-100 and Enemy.x < hero.x ) or (Enemy.x < hero.x+100 and Enemy.x > hero.x ))then
							Enemy:applyForce(dx or 0, 0, Enemy.x, Enemy.y)
						end
					end
				end
				Enemy.xScale = math.min(1, math.max(Enemy.xScale + Enemy.flip, -1))
				if Enemy.name == "buto" then
					if ( (Enemy.x - 120 < hero.x and Enemy.x > hero.x) or (Enemy.x + 120 > hero.x and Enemy.x < hero.x)) then
						Enemy:attack()
					end
				else
					if ( (Enemy.x - 100 < hero.x and Enemy.x > hero.x) or (Enemy.x + 100 > hero.x and Enemy.x < hero.x)) then
						Enemy:attack()
					end
				end
				if vx == 0 then
					--print("lol")
					if Enemy.sequence == "walk" and Enemy then
						Enemy:setSequence("idle")
						Enemy:play()
					end
				end
				if vx ~= 0 then
					--print("ok")	
					if Enemy.sequence == "idle" and Enemy then
						Enemy:setSequence("walk")
						Enemy:play()
					end
				end
			
			end
		end
		
	end
	

	Enemy.attacking = false
	Enemy.idle = true
	Enemy.walk = false
    Enemy.name = "enemy"
	Enemy.type = type
	function Enemy:finalize()
		if Enemy.timer then
			timer.cancel(Enemy.timer)
		end
		Runtime:removeEventListener( "enterFrame", enterFrame )
    end

	Enemy:addEventListener("finalize")
	Runtime:addEventListener("enterFrame", enterFrame)

    return Enemy
end
return M