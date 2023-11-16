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
local function gotoMenu()
    fx.fadeOut(function ()
        composer.gotoScene("scenes.menu")
    end)
end
--
-- Scene events functions

function scene:create( event )

    print("scene:create - leaderboard")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    BG = display.newGroup()
    local background = display.newRect(BG , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    background.fill =  {color.hex2rgb("191c54")}

    _grpMain:insert(BG)

    local boxHighscore = display.newImageRect(_grpMain, "assets/menu/button.png", 250, 55)
    boxHighscore.x , boxHighscore.y= _CX, _CY - 120 
    local txtHighscore = display.newText("Highscore", _CX, _CY - 120, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtHighscore.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtHighscore)

    local scores
    if composer.getVariable("score") == nil then
        scores = {3500, 2300, 2000, 1100, 0, 0, 0, 0, 0, 0}
    end

    local box = display.newImageRect(_grpMain, "assets/menu/highscorewindow.png", 200, 270)
    box.x, box.y = _CX, _CY + 40
    for i = 1, #scores, 1 do
        local txtScore = display.newText(scores[i], _CX, _CY-(50-(i*20)), "assets/fonts/Shadow of the Deads.ttf", 10)
        txtScore.fill = {color.hex2rgb("#dba400")}
        _grpMain:insert(txtScore)
    end

    local btnBack = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnBack.x , btnBack.y= display.actualContentWidth - 100 , 50
    local Back = display.newText("Back", display.actualContentWidth - 100 , 50, "assets/fonts/Shadow of the Deads.ttf", 10)
    Back.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(Back)

    btnBack:addEventListener("tap", gotoMenu)
    
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