--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local physics = require "physics"
local color = require "com.ponywolf.ponycolor"
local fx = require "com.ponywolf.ponyfx" 
local json = require "json"

--
-- Set variables
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
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

local function loadScores()
 
    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    end
end

local function saveScores()
 
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end
--
-- Scene events functions

function scene:create( event )
    print("scene:create - leaderboard - " )

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

    loadScores()
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )
    
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    saveScores()

    local box = display.newImageRect(_grpMain, "assets/menu/highscorewindow.png", 200, 270)
    box.x, box.y = _CX, _CY + 40
    for i = 1, 10 do
        local txtScore = display.newText(scoresTable[i], _CX, _CY-(50-(i*20)), "assets/fonts/Shadow of the Deads.ttf", 10)
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