--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local physics = require "physics"
local color = require "com.ponywolf.ponycolor"


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain
local BG
-- Sounds


--
-- Local functions
local function gotoStage5()
    composer.gotoScene("scenes.stage.stage5")
end

--
-- Scene events functions

function scene:create( event )

    print("scene:create - story4")

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

    local pausemenu = display.newImage( BG,"assets/menu/pausemenu.png", 180, 180)
    pausemenu.width = 550
    pausemenu.x, pausemenu.y =  400, 150

    --local txt = 

    local txtStory = display.newText(BG, "Finally you're able to reach Bandung Bondowoso" , 400, 120, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    local txtStory = display.newText(BG, "He attempted to hold Nyi Roro Jonggrang hostage" , 400, 140, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "But before he does, " , 400, 160, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "You try to rescue her from him" , 400, 180, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}

    
    local txtContinue = display.newText(BG, "Continue >" , 600, 240, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtContinue.fill = {color.hex2rgb("#dba400")}
    txtContinue:addEventListener("tap", gotoStage5)
    
    BG:insert(ground)
    BG:insert(terrain)
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