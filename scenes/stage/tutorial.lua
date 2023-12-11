--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local physics = require "physics"
local color = require "com.ponywolf.ponycolor"
local fx = require "com.ponywolf.ponyfx" 


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain

-- Sounds


--
-- Local functions

local function gotoStage1()
    fx.fadeOut( function()
        composer.gotoScene("scenes.stage.stage1")
    end )
    
end
--
-- Scene events functions

function scene:create( event )

    print("scene:create - menu")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)
    
    BG = display.newGroup()
    _grpMain:insert(BG)
    
    local background = display.newRect(BG , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    background.fill =  {color.hex2rgb("191c54")}
    local terrain = display.newLine( _CX - display.pixelWidth/2 , _CY + 130,  _CX + display.pixelWidth/2 , _CY + 130)
    terrain.strokeWidth = 3
    terrain:setStrokeColor(color.hex2rgb("#24690a"))

    local ground = display.newImageRect("assets/menu/ground.png", display.pixelWidth, 300)
    ground.x, ground.y = _CX, _CY + 280

    BG:insert(ground)
    BG:insert(terrain)

    local tutorial = display.newImage( _grpMain,"assets/menu/tutorialimage.png")
    tutorial.x, tutorial.y = _CX, _CY
    tutorial.width, tutorial.height = 761, 302

    tutorial:addEventListener("tap",gotoStage1)

end

function scene:show( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:hide( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:destroy( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end


--
-- Scene event listeners

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene