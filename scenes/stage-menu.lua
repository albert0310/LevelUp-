--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local color = require "com.ponywolf.ponycolor"

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
    composer.gotoScene("scenes.stage.stage1")
end
local function gotoStage2()
    composer.gotoScene("scenes.stage.stage2")
end
local function gotoStage3()
    composer.gotoScene("scenes.stage.stage3")
end
local function gotoStage4()
    composer.gotoScene("scenes.stage.stage4")
end
local function gotoStage5()
    composer.gotoScene("scenes.stage.stage5")
end
local function gotoMenu()
    composer.gotoScene("scenes.menu")
end
--
-- Scene events functions

function scene:create( event )

    print("scene:create - stage menu")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    local BG = display.newRect(_grpMain , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    BG.fill =  {color.hex2rgb("191c54")}
    _grpMain:insert(BG)

    local btnStage1 = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStage1.x , btnStage1.y= _CX - 200, _CY - 25
    local txtStage1 = display.newText("Stage 1", _CX - 200, _CY - 25, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStage1.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStage1)
    
    local btnStage2 = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStage2.x , btnStage2.y= _CX - 100, _CY + 25
    local txtStage2 = display.newText("Stage 2", _CX - 100, _CY + 25, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStage2.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStage2)

    local btnStage3 = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStage3.x , btnStage3.y= _CX , _CY - 25 
    local txtStage3 = display.newText("Stage 3", _CX , _CY - 25 , "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStage3.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStage3)

    local btnStage4 = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStage4.x , btnStage4.y= _CX + 100, _CY + 25
    local txtStage4 = display.newText("Stage 4", _CX + 100, _CY + 25, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStage4.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStage4)

    local btnStage5 = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStage5.x , btnStage5.y= _CX + 200, _CY - 25
    local txtStage5 = display.newText("Stage 5", _CX + 200, _CY - 25, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStage5.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStage5)

    local btnBack = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnBack.x , btnBack.y= display.actualContentWidth - 100 , 50
    local Back = display.newText("Back", display.actualContentWidth - 100 , 50, "assets/fonts/Shadow of the Deads.ttf", 10)
    Back.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(Back)

    btnStage1:addEventListener("tap", gotoStage1)
    btnStage2:addEventListener("tap", gotoStage2)
    btnStage3:addEventListener("tap", gotoStage3)
    btnStage4:addEventListener("tap", gotoStage4)
    btnStage5:addEventListener("tap", gotoStage5)
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