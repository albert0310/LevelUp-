local M = {}
local composer = require "composer"
local json = require "json"

function M.new(Bullet, world, x, y, type)
    local parent = world
    local bullet_sheet, bullet_sequenceData
    if type == "boss" then
        bullet_sheet = graphics.newImageSheet( "assets/enemy/energyball-Sheet.png", {
            width = 80,
            height = 80,
            numFrames = 4
        })
        bullet_sequenceData = {
            {name = "bullet", frames = {1,2,3,4} , time = 400, loopCount = 0}
        }
    elseif  type == "hero" then
        bullet_sheet = graphics.newImageSheet( "assets/enemy/slash_248x100.png", {
            width = 248 / 4,
            height = 100,
            numFrames = 4
        })
        bullet_sequenceData = {
            {name = "bullet", frames = {4,3,2,1} , time = 400, loopCount = 0}
        }
    end
    Bullet = display.newSprite(parent , bullet_sheet, bullet_sequenceData)
    Bullet:setSequence("bullet")
    Bullet:play()
    physics.addBody( Bullet, "dynamic", { radius = 30, --[[ 
        	filter = {categoryBits = 2, maskBits = 1}
	]]}  )
    Bullet.gravityScale = 0
    Bullet.isBullet = true

    local function onLocalCollision( self, event )
        if ( event.phase == "began" ) then
            print( ": collision began with " .. event.other.name )
     
        elseif ( event.phase == "ended" ) then
            print( ": collision ended with " .. event.other.name )
        end
    end

    Bullet.collision = onLocalCollision
    

    local function enterFrame()
        if x < Bullet.x then
            Bullet.x = Bullet.x - 2
        elseif x > Bullet.x then
            Bullet.x = Bullet.x + 2
        end
        if y < Bullet.y then
            Bullet.y = Bullet.y - 1
        elseif y > Bullet.y then
            Bullet.y = Bullet.y + 1
        end
    end

    function Bullet:finalize()
        --Runtime:removeEventListener("collision", onLocalCollision)
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    Bullet:addEventListener("finalize")
    Bullet:addEventListener( "collision" )
    Runtime:addEventListener("enterFrame", enterFrame)
    return Bullet
end
return M