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
local function gotoGame()
   composer.gotoScene( "scenes.game" )
end
local function gotoStory()
    composer.gotoScene("scenes.stage-menu")
end

--
-- Scene events functions

function scene:create( event )

    print("scene:create - menu")

    _grpMain = display.newGroup()

    self.view:insert(_grpMain)

    local BG = display.newRect(_grpMain , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    BG.fill =  {color.hex2rgb("191c54")}
    _grpMain:insert(BG)
    
    local Title = display.newImageRect( _grpMain, "assets/menu/title.png", 400, 80)
    Title.x, Title.y = _CX, _CY - 120
    local txtTitle = display.newText("Level Up!", _CX, _CY - 115, "assets/fonts/UrbanJavaDEMO-Expanded.ttf", 50)
    txtTitle.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtTitle)


    local btnPlay = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnPlay.x , btnPlay.y= _CX, _CY - 25
    local txtPlay = display.newText("Endless Mode", _CX, _CY - 25, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtPlay.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtPlay)
    

    local btnStory = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnStory.x , btnStory.y= _CX, _CY + 20 
    local txtStory = display.newText("Story Mode", _CX, _CY + 20, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtStory.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtStory)

    local btnLead = display.newImageRect(_grpMain, "assets/menu/button.png", 150, 35)
    btnLead.x , btnLead.y= _CX, _CY + 70 
    local txtLead = display.newText("Leaderboard", _CX, _CY + 70, "assets/fonts/Shadow of the Deads.ttf", 10)
    txtLead.fill = {color.hex2rgb("#dba400")}
    _grpMain:insert(txtLead)

    local btnSettings = display.newImageRect( _grpMain, "assets/menu/setting.png", 50, 50 )
    btnSettings.x, btnSettings.y = display.actualContentWidth - 50, display.actualContentHeight - 50
    
    btnPlay:addEventListener("tap", gotoGame)
    btnStory:addEventListener("tap", gotoStory)
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