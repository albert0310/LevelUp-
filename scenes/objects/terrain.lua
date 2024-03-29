-- terrain class
local M ={}

local lastWidth, lastAngle = 0, 0
local relayout = require("libs.relayout")
local physics = require "physics"
local color = require "com.ponywolf.ponycolor"
local json = require "json"

local imgDir = "assets/background/"
local treeImgs = { "bush-1.png", "tree-1.png", "tree-2.png" }
local houseImgs = { "house-1.png" }
local cloudImgs = {"cloud-1.png", "cloud-2.png"}

function M.new(world,stage,decor,length, x_start, y_start)
        local instance = display.newGroup()
        local x_next,y_next 

        local terrain = display.newLine( x_start, y_start, x_start+length , y_start)
        physics.addBody(terrain, "static", { friction = 1 , 
                filter = {categoryBits = 1, maskBits = 2}
        })
        terrain.strokeWidth = 3
        terrain:setStrokeColor(color.hex2rgb("#24690a"))
        terrain.isGround = true
        terrain.nama = "terrain"
        local ground = display.newImageRect("assets/menu/ground.png", length, 300)
        physics.addBody(ground, "static", { friction = 1 , 
                filter = {categoryBits = 1, maskBits = 2}
        })
        --ground.anchorX, ground.anchorY = 0, 0
        ground.x, ground.y = x_start+(length/2), y_start+150
        print(ground.x .. ground.y)
        ground.isVisible = true
        ground.nama = "ground"

        local cloud
        local tempy = math.random(200, 350)
        cloud = display.newImageRect(decor, imgDir .. cloudImgs[math.random(#cloudImgs)] , 80, 40)
        cloud.width, cloud.height = 160, 80
        cloud.x, cloud.y = math.random(x_start , x_start+length), (y_start - tempy)

        --decor
        if stage == 1 or stage == 2 then
                for i = 1, math.floor(length/100) , 1 do
                        local tree = display.newImageRect(decor, imgDir .. "forest/" .. treeImgs[math.random(#treeImgs)],150, math.random(120, 200))
                        tree.anchorX, tree.anchorY = 0.5, 1    
                        tree.x, tree.y = math.random(x_start , x_start+length), y_start --[[ + 128 + math.random(128) ]]
                        tree:setFillColor(color.hex2rgb("8479A7"))
                        tree:toBack()
                        decor:toBack()
                end
        else
                for i = 1, math.floor(length/200) , 1 do
                        local house = display.newImageRect(decor, imgDir .. "village/" .. houseImgs[1],150, math.random(120, 200))
                        house.anchorX, house.anchorY = 0.5, 1    
                        house.x, house.y = math.random(x_start , x_start+length), y_start + 10--[[ + 128 + math.random(128) ]]
                        house:setFillColor(color.hex2rgb("8479A7"))
                        house:toBack()
                        decor:toBack()
                end
        end


        instance:insert(terrain)
        instance:insert(ground)
        instance.x_start = x_start
        instance.y_start = y_start
        instance.x_end = x_start+length
        instance.name = "terrain"
        world:insert(instance)

        return instance
end

return M