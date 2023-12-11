local M = {}
local composer = require "composer"
local json = require "json"
local color = require "com.ponywolf.ponycolor"
local bullet = require "scenes.objects.bullet"

function M.new(Boss, world, hero, stage)
    local parent = world
    local boss_sheet = graphics.newImageSheet( "assets/enemy/bandung_bondowoso-Sheet.png", {
        width= 160,
        height= 227,
        numFrames= 24,
    })

    local boss_sequenceData = {
		{ name = "idle", frames = { 1, 2, 3, 4 }, time = 700, loopCount= 0 },
		{ name = "walk", frames = { 7, 8, 9, 10 } , time = 800, loopCount = 0 },
		{ name = "attack", frames = {13, 14, 15, 16, 17, 18 }, time = 700, loopCount = 0},
        { name = "ranged", frames = {19, 20, 21, 22, 23, 24 }, time = 700, loopCount = 0}
	}
    Boss = display.newSprite(parent, boss_sheet, boss_sequenceData)
    Boss:setSequence("idle")
    Boss:play()
    physics.addBody( Boss, "dynamic", { density = 0.5, bounce = 0.2, friction =  0.2 ,
        	filter = {categoryBits = 2, maskBits = 1}
	} )

    --properties
    Boss.isDead = false
    Boss.hp = 500
    Boss.maxHP = 500
    Boss.armor = 10
    Boss.damage = 65
    Boss.attackCD = 300
    Boss.attackTimer = 300
    Boss.acceleration = 150
    Boss.max = 170
    Boss.attacking = false
    Boss.name = "boss"
    local health = display.newImageRect(parent, "assets/main-character/skills/inner-health.png" , 150, 10)
    local healthwidth = 150

    function Boss:dead()
        for i = 0, 30, 1 do
            local radius = math.random(1, 10)
            local blood = display.newCircle(world, Boss.x, Boss.y, radius)
            local toX = blood.x + math.random(-100, 100)
            local toY = blood.y + math.random(-100,100)
            blood.fill = {color.hex2rgb("#ba1004")}
            transition.to(blood, {time = 500, x=toX, y=toY, alpha=0, rotation=180})
        end
    end

    function Boss:hurt(damage)
        Boss.hp = Boss.hp - damage
        if Boss.hp <= 0 then
            Boss.isDead = true
            Boss:dead()
            timer.cancel( Boss.timer )
        end
    end
    local hx, hy , ball
    local function attack()
        local vx, vy = Boss:getLinearVelocity()
        local direction =  hero.x - Boss.x
        if direction < 0 then
            Boss.flip = -0.133
        elseif direction > 0 then
            Boss.flip = 0.133
        end
        if Boss.x < hx then
            vx = 1
            Boss.x = Boss.x + 2
        elseif Boss.x > hx then
            vx = 1
            Boss.x = Boss.x - 2
        else
            vx = 0
        end
        Boss.xScale = math.min(1, math.max(Boss.xScale + Boss.flip, -1))
        if vx == 0 then
            Boss:setSequence("idle")
            Boss:play()
        end
        if vx ~= 0 then
            print("ok")
            if Boss.sequence == "idle" and Boss then
                Boss:setSequence("walk")
                Boss:play()
            end
        end
        if (Boss.x > hx-100 and Boss.x < hx     ) or (Boss.x < hx+100 and Boss.x > hx ) then
            Boss:setSequence("attack")
            Boss:play()
            if (Boss.x > hero.x-100 and Boss.x < hero.x ) or (Boss.x < hero.x+100 and Boss.x > hero.x )  then
                hero:hurt(Boss.damage)
            end
            Boss.timer = timer.performWithDelay( 900, function()
                if Boss then
                    Boss:setSequence("idle")
                    Boss:play()
                end
            end )
            Boss.attackTimer = Boss.attackCD
            Boss.attacking = false
        end
    end
    local function ranged()
        Boss:setSequence("ranged")
        Boss:play()
        ball = bullet.new(ball, parent, hero, Boss.x, Boss.y - 100, hx, hy, "boss")
        Boss.timer = timer.performWithDelay( 900, function()
            if Boss then
                Boss:setSequence("idle")
                Boss:play()
            end
        end )
        Boss.attackTimer = Boss.attackCD
        Boss.attacking = false
    end

    local function enterFrame()
        if not parent.pause then
            local ran
            if (Boss.x < hero.x+750 and Boss.x > hero.x-750)then
                if Boss.attackTimer == 0 and not Boss.attacking  then
                    Boss.attacking = true
                    hx = hero.x
                    hy = hero.y
                end
                if Boss.attacking then
                    if stage == 5 then
                        ran = math.random(10)
                        if ran < 3 then
                            ranged()
                        else
                            attack()
                        end
                    else
                        attack()
                    end

                end
                Boss.attackTimer = Boss.attackTimer - 1
            end
        end
        health.x,health.y = Boss.x, Boss.y - 100
        local percent = Boss.hp / Boss.maxHP
        health.width = healthwidth * percent
    end

    function Boss:finalize()
        print("boss hilang")
        if Boss.timer then
			timer.cancel(Boss.timer)
		end
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    Boss:addEventListener("finalize")
    Runtime:addEventListener("enterFrame", enterFrame)

    return Boss
end
return M