local M = {}
local composer = require "composer"
local json = require "json"

function M.new(Bullet, world, hero, x1, y1, x2, y2, type)
    local parent = world
    local bullet_sheet, bullet_sequenceData

    if(type == "boss")then
        bullet_sheet = graphics.newImageSheet( "assets/enemy/energyball-Sheet.png", {
            width = 80,
            height = 80,
            numFrames = 4
        })
        bullet_sequenceData = {
            {name = "bullet", frames = {1,2,3,4} , time = 400, loopCount = 0}
        }
    end
    

    Bullet = display.newSprite(parent , bullet_sheet, bullet_sequenceData)
    Bullet.x, Bullet.y = x1, y1
    physics.addBody(Bullet, "dynamic", {density = 1.0, friction = 0.3,angularDamping = 0})
    Bullet:setSequence("bullet")
    Bullet:play()
    Bullet.isBullet = true
    Bullet.name = "bullet"
    Bullet.hit = nil
    Bullet.type = type

    local angle = math.atan2(y2 - y1, x2 - x1)
    local distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
    local speed = 120

    local vx = speed * math.cos(angle)
    local vy = speed * math.sin(angle)

    local function onBulletComplete()
        display.remove(Bullet)
    end

    transition.to(Bullet, {
        x = x2,
        y = y2,
        time = distance / speed * 1000,
        onComplete = onBulletComplete
    })

    local function onCollision(event)
        if event.phase == "began" then
            local obj1 = event.object1
            local obj2 = event.object2
            if obj1.type == "boss" or obj2.type == "boss" then
                if (obj1.name == "bullet" and obj2.name == "hero") or (obj1.name == "hero" and obj2.name == "bullet") then
                    if obj1.name == "bullet" then
                        obj1:removeSelf()
                    elseif obj2.name == "bullet" then
                        obj2:removeSelf()
                    end
                    hero:hurt(30)
                    print("Bullet collided with hero!")
                end
            end
        end
    end

    function Bullet:finalize()
        Runtime:removeEventListener("collision", onCollision)
    end

    Bullet:addEventListener("finalize")
    Runtime:addEventListener("collision", onCollision)

    return Bullet
end
return M