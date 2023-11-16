--
-- Import

local composer = require("composer")
local relayout = require("libs.relayout")
local physics = require "physics"
local color = require "com.ponywolf.ponycolor"
local fx = require "com.ponywolf.ponyfx" 

--
-- Set variables
local textB, textS
-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

-- Groups
local _grpMain, _pauseGroup

-- Sounds


--
-- Local functions

local function blood(event)
    local bblood = composer.getVariable("bloodOnOff")
    if(event.phase == "ended" ) then
        if bblood == true then
            bblood = false
        else 
            bblood = true
        end

        if bblood == false then
            textB = "Off"
        else
            textB = "On"
        end
        composer.setVariable("bloodOnOff", bblood)
        for i = 1, _pauseGroup.numChildren, 1 do
            if _pauseGroup[i].name == "txtBloodOnoff" then
                _pauseGroup[i]:removeSelf()
                local txtBloodOnoff = display.newText(textB, 450, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtBloodOnoff.fill = {color.hex2rgb("#dba400")}
                txtBloodOnoff.name = "txtBloodOnoff"
                _pauseGroup:insert(txtBloodOnoff)
            end
        end
    end
end

local function sound(event)
    local bsound = composer.getVariable("soundOnOff")
    if(event.phase == "ended" ) then
        if bsound == true then
            bsound = false
            audio.stop(1)
        else 
            bsound = true
        end

        if bsound == false then
            textS = "Off"
        else
            textS = "On"
        end
        composer.setVariable("soundOnOff", bsound)
        for i = 1, _pauseGroup.numChildren, 1 do
            if _pauseGroup[i].name == "txtSoundOnOff" then
                _pauseGroup[i]:removeSelf()
                local txtSoundOnOff = display.newText(textS, 450, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtSoundOnOff.fill = {color.hex2rgb("#dba400")}
                txtSoundOnOff.name = "txtSoundOnOff"
                _pauseGroup:insert(txtSoundOnOff)
            end
        end
    end
    if not composer.getVariable("soundOnOff") then
        audio.stop(1)
    end
end

local function goBack()
    fx.fadeOut( function()
        composer.gotoScene( "scenes.menu")
    end )
end

--
-- Scene events functions

function scene:create( event )

    print("scene:create - settings")

    _grpMain = display.newGroup()
    _pauseGroup = display.newGroup()

    self.view:insert(_grpMain)

    local BG = display.newRect(_grpMain , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    BG.fill =  {color.hex2rgb("191c54")}
    _grpMain:insert(BG)

    local pausemenu = display.newImage( _pauseGroup,"assets/menu/pausemenu.png", 180, 180)
    pausemenu.x, pausemenu.y =  400, 150
    
    local txtSound = display.newText(_pauseGroup, "Sound" , 350, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtSound.fill = {color.hex2rgb("#dba400")}

    if composer.getVariable("soundOnOff")  then
        textS = "On"
    else
        textS = "Off" 
    end
    local txtSoundOnOff = display.newText(textS, 450, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtSoundOnOff.fill = {color.hex2rgb("#dba400")}
    txtSoundOnOff.name = "txtSoundOnOff"
    _pauseGroup:insert(txtSoundOnOff)

    local txtBlood = display.newText(_pauseGroup, "Blood ", 347, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtBlood.fill = {color.hex2rgb("#dba400")}
    
    if composer.getVariable("bloodOnOff")  then
        textB = "On"
    else
        textB = "Off" 
    end
    local txtBloodOnoff = display.newText(textB, 450, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtBloodOnoff.fill = {color.hex2rgb("#dba400")}
    txtBloodOnoff.name = "txtBloodOnoff"
    _pauseGroup:insert(txtBloodOnoff)

    local txtBack = display.newText( _pauseGroup, "Back", 342, 225, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtBack.fill = {color.hex2rgb("#dba400")}

    txtBlood:addEventListener("touch", blood)
    txtSound:addEventListener("touch", sound)
    txtBack:addEventListener("tap", goBack)


end

function scene:show( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
    end
end

function scene:hide( event )

    if ( event.phase == "will" ) then
        _pauseGroup:removeSelf()
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