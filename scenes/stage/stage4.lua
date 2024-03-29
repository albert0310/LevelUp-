--
-- Import

local composer = require"composer"
local relayout = require"libs.relayout"
local physics = require "physics"
local terrains = require "scenes.objects.terrain"
local heroes = require "scenes.objects.hero"
local skills = require "scenes.objects.skills"
local enemy = require "scenes.objects.enemy"
local bosss = require "scenes.objects.boss"
local health = require "scenes.objects.healthbar"
local vjoy = require( "com.ponywolf.vjoy" )
local color = require "com.ponywolf.ponycolor"
local fx = require "com.ponywolf.ponyfx" 
local json = require "json"
require("com.ponywolf.joykey").start()


--
-- Set variables

-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()

local terrain, terrainCount, spawnTerrain = {}, 1
local world, hero,skill, musuh, wall, BG, blockade, boss, decor, healthbar
local back,right,left,attack,jump ,dash ,skil1,skil2,skil3,skil4,skil5 
local enemies = {}
local bblood = composer.getVariable("bloodOnOff")
local textS = ""
local textB = ""
local bsound = composer.getVariable("soundOnOff")
local diessound, slashsound
--buttons
local back,right,left,attack,jump,dash,skill1,skill2,skill3,skill4,skill5 

-- Groups
local _grpMain
local _pauseGroup
--
-- Local functions
local function removepauseMenu()
    print (_pauseGroup.numChildren)

    for i = _pauseGroup.numChildren , 1 , -1 do
        display.remove(_pauseGroup[i])
    end

    world.pause = false
end

local function resume( event )
    if(event.phase == "ended" ) then
        removepauseMenu()
    end
    return true 
end

local function sound(event)
    if(event.phase == "ended" ) then
        if bsound == true then
            bsound = false
            audio.stop(1)
        else 
            bsound = true
            local musicTrack = composer.getVariable("musicTrack")
            audio.play(musicTrack, {channel=1, loops = -1})
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
end
local function blood(event)
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

local function goBack()
    removepauseMenu()
    fx.fadeOut( function()
        composer.gotoScene( "scenes.menu")
    end )
end

local function createpauseMenu()
    print "createpause"

    local pausemenu = display.newImage( _pauseGroup,"assets/menu/pausemenu.png", 180, 180)
    pausemenu.x, pausemenu.y =  400, 150
    
    local txtSound = display.newText(_pauseGroup, "Sound" , 350, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtSound.fill = {color.hex2rgb("#dba400")}

    if bsound  then
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

    if bblood then
        textB = "On"
    else
        textB = "Off" 
    end
    local txtBloodOnoff = display.newText( textB, 450, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtBloodOnoff.fill = {color.hex2rgb("#dba400")}
    txtBloodOnoff.name = "txtBloodOnoff"
    _pauseGroup:insert(txtBloodOnoff)

    local txtResume = display.newText( _pauseGroup ,"Resume ", 362, 190, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtResume.fill = {color.hex2rgb("#dba400")}

    local txtBack = display.newText( _pauseGroup, "Back", 342, 225, "assets/fonts/Shadow of the Deads.ttf", 15)
    txtBack.fill = {color.hex2rgb("#dba400")}

    txtBlood:addEventListener("touch", blood)
    txtResume:addEventListener("touch", resume)
    txtSound:addEventListener("touch", sound)
    txtBack:addEventListener("tap", goBack)

    world.pause = true
end

local function dead(x,y)
    if bblood then
        if bsound then
            audio.play(diessound)
        end
        for i = 0, 20, 1 do
            local radius = math.random(1, 10)
            local blood = display.newCircle(world, x, y, radius)
            local toX = blood.x + math.random(-100, 100)
            local toY = blood.y + math.random(-100,100)
            blood.fill = {color.hex2rgb("#ba1004")}
            transition.to(blood, {time = 500, x=toX, y=toY, alpha=0, rotation=180})
        end
    end
    local temp_dead = 0
    for index, value in ipairs(enemies) do
        if value.isDead then
            temp_dead = temp_dead + 1
        end
    end
    print(temp_dead .. " - " .. #enemies)
    if temp_dead == #enemies then
        composer.gotoScene( "scenes.menu")
    end
end

local function slashingsound()
    if bsound then
        audio.play(slashsound)
    end
end
--skill functions

local function megaslash()
    if hero.megaslashBool then
        hero.megaslash()
        skill.megaslash()
        for index, value in ipairs(enemies) do
            if value.name == "enemy" and value.isDead ~= true then
                if hero.direction == "right" then
                    if value.x >= hero.x and value.x < hero.x+150  then
                        value:hurt(hero.damage*1.8)
                    end
                else
                    if value.x <= hero.x and value.x > hero.x-150  then
                        value:hurt(hero.damage*1.8)
                    end
                end
                if value.hp <= 0 then
                    
                    dead(value.x, value.y)
                    value.isDead = true
                end
            end
        end
    end
end

local function earthshatter()
    if hero.earthshatterBool then
        hero.earthshatter()
        skill.earthshatter()
        
        for index, value in ipairs(enemies) do
            if value.name == "enemy" and value.isDead ~= true then
                if hero.direction == "right" then
                    if value.x >= hero.x + 90 and value.x < hero.x+190  then
                        value:hurt(hero.damage*2)
                    end
                else
                    if value.x <= hero.x - 90 and value.x > hero.x-190  then
                        value:hurt(hero.damage*2)
                        
                    end
                end
                if value.hp <= 0 then
                    
                    dead(value.x, value.y)
                    value.isDead = true
                end
            end
        end
    end
    
end

local function heal()
    hero:heal()
end

--


--

--
-- Scene events functions

function scene:create( event )
    local sceneGroup = self.view
    print("scene:create - stage 4")
    physics.start()

    BG = display.newGroup()
    _pauseGroup = display.newGroup()

    local background = display.newRect(BG , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    background.fill =  {color.hex2rgb("191c54")}
    
    sceneGroup:insert(BG)

    world = display.newGroup()
    sceneGroup:insert(world)
    world.pause = false
    --placing buttons
    local isSimulator = "simulator" == system.getInfo( "environment" )
    local isMobile = ( "ios" == system.getInfo("platform") ) or ( "android" == system.getInfo("platform") )
    if isMobile or isSimulator then
        back = vjoy.newButton("assets/menu/setting.png" , "back", sceneGroup)
        right = vjoy.newButton( "assets/menu/right-arrow.png", "mright", sceneGroup )
        left = vjoy.newButton( "assets/menu/left-arrow.png", "left" , sceneGroup)
        attack = vjoy.newButton("assets/menu/attack-button.png", "attack", sceneGroup)
        jump = vjoy.newButton("assets/main-character/skills/jump.png", "jump", sceneGroup)
        dash = vjoy.newButton("assets/main-character/skills/dash.png", "dash", sceneGroup)
        skill1 = vjoy.newButton("assets/main-character/skills/megaslash.png", "skill1", sceneGroup)
        skill1.name = "megaslash"
        skill2 = vjoy.newButton("assets/main-character/skills/heal.png", "skill2", sceneGroup)
        skill2.name = "heal"
        skill3 = vjoy.newButton("assets/main-character/skills/earthshatter.png", "skill3", sceneGroup)
        skill3.name = "earthshatter"
        skill4 = vjoy.newButton("assets/main-character/skills/imunity.png", "skill4", sceneGroup)
        skill4.name = "imunity"
        skill5 = vjoy.newButton("assets/main-character/skills/locked.png", "skill5", sceneGroup)
        --position
        back.x,back.y = display.actualContentWidth - 50 , 50
        attack.x,attack.y = display.actualContentWidth - 50 , _CY + 130
        dash.x,dash.y = display.actualContentWidth - 30 , _CY + 60
        jump.x,jump.y = display.actualContentWidth - 80 , _CY + 70
        skill1.x,skill1.y = display.actualContentWidth - 115 , _CY + 105
        skill2.x, skill2.y = display.actualContentWidth - 130 , _CY + 150
        skill3.x, skill3.y = display.actualContentWidth - 160 , _CY + 105
        skill4.x, skill4.y = display.actualContentWidth - 175 , _CY + 150
        skill5.x, skill5.y = display.actualContentWidth - 220 , _CY + 150
        right.x, right.y = display.screenOriginX + 130, display.screenOriginY + display.contentHeight - 40
        left.x, left.y =  display.screenOriginX + 70,display.screenOriginY + display.contentHeight - 40  
        --scale
        back.xScale, back.yScale = 1, 1
        jump.xScale, jump.yScale = 0.8, 0.8
        dash.xScale, dash.yScale = 0.8, 0.8
        skill1.xScale, skill1.yScale = 0.8, 0.8
        skill2.xScale, skill2.yScale = 0.8, 0.8
        skill3.xScale, skill3.yScale = 0.8, 0.8
        skill4.xScale, skill4.yScale = 0.8, 0.8
        skill5.xScale, skill5.yScale = 0.8, 0.8
        attack.xScale, attack.yScale = 1, 1
        right.xScale, right.yScale = 0.3 , 0.3
        left.xScale, left.yScale = 0.3, 0.3
    end
    --wall
    wall = display.newImageRect(world, "assets/background/border.png" , 300, 1000)
    wall.x, wall.y = -120, _CY - 350
    physics.addBody( wall, "static", {density = 100, bounce = 0, friction = 1})

    --player
    hero = heroes.new(hero,world)
    skill = skills.new(skill, hero, world)

    --healthbar
    healthbar = health.new(hero, sceneGroup)

    --decor
    decor = display.newGroup()
    world:insert(decor)
    --terrains
    --print(_CX .. _CY)
    terrain[1] = terrains.new(world,4,decor, 600 , 0, _CY)
    terrain[2] = terrains.new(world,4,decor, 600 , 0, _CY+300)
    terrain[3] = terrains.new(world,4,decor, 750, terrain[1].x_end, _CY+300)
    terrain[4] = terrains.new(world,4,decor, 700, terrain[3].x_end, _CY+270)
    terrain[5] = terrains.new(world,4,decor, 200, terrain[4].x_end - 320, _CY-150)
    terrain[6] = terrains.new(world,4,decor, 200, terrain[4].x_end - 320, _CY-350)
    terrain[7] = terrains.new(world,4,decor, 650, terrain[4].x_end - 120, _CY-350)
    terrain[8] = terrains.new(world,4,decor, 530, terrain[4].x_end, _CY+100)
    terrain[9] = terrains.new(world,4,decor, 400, terrain[8].x_end, _CY-350)
    terrain[10] = terrains.new(world,4,decor, 400, terrain[8].x_end, _CY+100)
    terrain[11] = terrains.new(world,4,decor, 700, terrain[10].x_end, _CY+100)
    terrain[12] = terrains.new(world,4,decor, 900, terrain[11].x_end, _CY+200)
    
    blockade = display.newRect(world, terrain[12].x_end + 120, _CY-150, 300, 1000)
    physics.addBody( blockade, "static", {density = 100, bounce = 0, friction = 1}) 
    
    --enemies
    musuh = display.newRect(world, 400, _CY-20 , 100, 100)
    musuh = enemy.new(musuh, "kuyang", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 450, _CY-20 , 100, 100)
    musuh = enemy.new(musuh, "kuyang", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 1000, _CY+250 , 100, 100)
    musuh = enemy.new(musuh, "buto", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 980, _CY+240 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 940, _CY+240 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 1700, _CY , 100, 100)
    musuh = enemy.new(musuh, "sundel", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 1750, _CY , 100, 100)
    musuh = enemy.new(musuh, "kuyang", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2350, _CY , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2400, _CY , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2500, _CY , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2900, _CY , 100, 100)
    musuh = enemy.new(musuh, "buto", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2950, _CY , 100, 100)
    musuh = enemy.new(musuh, "buto", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 4200, _CY , 100, 100)
    musuh = enemy.new(musuh, "sundel", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 4250, _CY , 100, 100)
    musuh = enemy.new(musuh, "sundel", hero)
    table.insert(enemies, musuh)

     --key
     function key(event)
        if event.phase == "up" and not world.pause then
            if event.keyName == "attack" or event.keyName == "t" then
                for index, value in ipairs(enemies) do
                    if value.name == "enemy" and value.isDead ~= true then
                        if hero.direction == "right" then
                            if value.x >= hero.x and value.x < hero.x+120  then
                                slashingsound()
                                value:hurt(hero.damage)
                            end
                        else
                            if value.x <= hero.x and value.x > hero.x-120  then
                                slashingsound()
                                value:hurt(hero.damage)
                            end
                        end
                        if value.hp <= 0 then
                            
                            dead(value.x, value.y)
                            value.isDead = true
                        end
                    end
                end
            end
            --skills
            if event.keyName == "skill1" or event.keyName == "t" then
                print(hero.direction)
                if skill1.name == "megaslash"  then
                    megaslash()
                    skill1:onCD()
                end
            end
            if event.keyName == "skill2" or event.keyName == "t" then
                if skill2.name == "heal" then
                    heal()
                    skill2:onCD()
                end
            end
            if event.keyName == "skill3" or event.keyName == "t" then
                if skill3.name == "earthshatter" then
                    earthshatter()
                    skill3:onCD()
                end
            end
            if event.keyName == "skill4" or event.keyName == "t" then
                if skill4.name == "imunity" then
                    hero:imunity()
                    skill4:onCD()
                end
            end
            if event.keyName == "back" or event.keyName == "escape" then
                print(world.pause)
                if world.pause then
                    removepauseMenu()
                else
                    createpauseMenu()
                end
                return true
            end
        end
    end 
    slashsound = audio.loadSound("assets/sound/slash.mp3")
    diessound = audio.loadSound("assets/sound/dies.wav")
    
    Runtime:addEventListener("key", key) 
end

local function enterFrame(event)
    if hero.healBool then
        skill2:offCD()
    end
    if hero.megaslashBool then
        skill1:offCD()
    end
    if hero.earthshatterBool then
        skill3:offCD()
    end
    if hero.imunityBool then
        skill4:offCD()
    end

    if hero.x < 3900 then
        local hx, hy = hero:localToContent(0, -100)
        hx, hy = _CX/2 - hx, _CY - hy
        world.x, world.y = world.x + hx, world.y + hy
    end

end

function scene:show( event )

    if ( event.phase == "will" ) then
        fx.fadeIn()	
        Runtime:addEventListener("enterFrame", enterFrame)
    elseif ( event.phase == "did" ) then
    end
end

function scene:hide( event )

    if ( event.phase == "will" ) then
    elseif ( event.phase == "did" ) then
        Runtime:removeEventListener("enterFrame", enterFrame)
        Runtime:removeEventListener( "key", key )
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