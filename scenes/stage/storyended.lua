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
local function gotoMenu()
    composer.gotoScene("scenes.menu")
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

    local hero = display.newImage(BG, "assets/main-character/MainChara.png")
    hero.x, hero.y = _CX - 320, _CY + 75
    hero.height, hero.width = 220, 220

    local princess = display.newImage(BG, "assets/main-character/PrincessChara.png")
    princess.x, princess.y = _CX + 320, _CY + 75
    princess.height, princess.width = 220, 220

    local pausemenu = display.newImage( BG,"assets/menu/pausemenu.png", 180, 180)
    pausemenu.width = 550
    pausemenu.x, pausemenu.y =  400, 150

    --local txt = 

    local txtStory = display.newText(BG, "And so you finally beat Bandung Bondowoso" , 400, 120, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "He run away back to his kingdom after you defeat him" , 400, 140, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "Nyi Roro Jonggrang says her gratitude to you" , 400, 160, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "After that you continue your endless journey" , 400, 180, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    txtStory = display.newText(BG, "To become more stronger than you ever be" , 400, 200, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtStory.fill = {color.hex2rgb("#dba400")}
    
    local txtContinue = display.newText(BG, "Continue >" , 600, 240, "assets/fonts/Shadow of the Deads.ttf", 11)
    txtContinue.fill = {color.hex2rgb("#dba400")}
    txtContinue:addEventListener("tap", gotoMenu)
    
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