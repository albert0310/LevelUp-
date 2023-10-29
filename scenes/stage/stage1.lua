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
local bblood = true
-- Groups
local _grpMain

-- Sounds


--
-- Local functions
local function goBack()
    fx.fadeOut( function()
        composer.gotoScene( "scenes.menu")
    end )
end
local function resume()
    print(world.pause)
    print("before resume")
    world.pause = not world.pause
    print(world.pause)
    print("after resume")
end
local function sound()
    
end
local function blood()
    bblood = not bblood
end
local function dead(x,y)
    if bblood then
        for i = 0, 20, 1 do
            local radius = math.random(1, 10)
            local blood = display.newCircle(world, x, y, radius)
            local toX = blood.x + math.random(-100, 100)
            local toY = blood.y + math.random(-100,100)
            blood.fill = {color.hex2rgb("#ba1004")}
            transition.to(blood, {time = 500, x=toX, y=toY, alpha=0, rotation=180})
        end
    end
end

--
-- Scene events functions

function scene:create( event )
    local sceneGroup = self.view
    print("scene:create - stage 1")
    physics.start()

    BG = display.newGroup()

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
        local back = vjoy.newButton(60 , "back", sceneGroup)
        local right = vjoy.newButton( 60, "right", sceneGroup )
        local left = vjoy.newButton( 60, "left" , sceneGroup)
        local attack = vjoy.newButton("assets/menu/attack-button.png", "attack", sceneGroup)
        local jump = vjoy.newButton("assets/main-character/skills/jump.png", "jump", sceneGroup)
        local dash = vjoy.newButton("assets/main-character/skills/dash.png", "dash", sceneGroup)
        local skil1 = vjoy.newButton("assets/main-character/skills/mega-slash.png", "skill1", sceneGroup)
        local skil2 = vjoy.newButton("assets/main-character/skills/locked.png", "skill2", sceneGroup)
        local skil3 = vjoy.newButton("assets/main-character/skills/locked.png", "skill3", sceneGroup)
        local skil4 = vjoy.newButton("assets/main-character/skills/locked.png", "skill4", sceneGroup)
        local skil5 = vjoy.newButton("assets/main-character/skills/locked.png", "skill5", sceneGroup)
        --position
        back.x,back.y = display.actualContentWidth - 50 , 50
        attack.x,attack.y = display.actualContentWidth - 50 , _CY + 130
        dash.x,dash.y = display.actualContentWidth - 30 , _CY + 60
        jump.x,jump.y = display.actualContentWidth - 80 , _CY + 70
        skil1.x,skil1.y = display.actualContentWidth - 115 , _CY + 105
        skil2.x, skil2.y = display.actualContentWidth - 130 , _CY + 150
        skil3.x, skil3.y = display.actualContentWidth - 160 , _CY + 105
        skil4.x, skil4.y = display.actualContentWidth - 175 , _CY + 150
        skil5.x, skil5.y = display.actualContentWidth - 220 , _CY + 150
        right.x, right.y = display.screenOriginX + 130, display.screenOriginY + display.contentHeight - 40
        left.x, left.y =  display.screenOriginX + 70,display.screenOriginY + display.contentHeight - 40  
        --scale
        back.xScale, back.yScale = 0.4, 0.4
        jump.xScale, jump.yScale = 0.8, 0.8
        dash.xScale, dash.yScale = 0.8, 0.8
        skil1.xScale, skil1.yScale = 0.8, 0.8
        skil2.xScale, skil2.yScale = 0.8, 0.8
        skil3.xScale, skil3.yScale = 0.8, 0.8
        skil4.xScale, skil4.yScale = 0.8, 0.8
        skil5.xScale, skil5.yScale = 0.8, 0.8
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
    skill.CD = 400
    skill.CDtemp = 400
    --healthbar
    healthbar = health.new(hero, sceneGroup)

    --decor
    decor = display.newGroup()
    world:insert(decor)

    --terrains
    --print(_CX .. _CY)
    terrain[1] = terrains.new(world,1,decor, 700 , 0, _CY)
    terrain[2] = terrains.new(world,1,decor, 500, terrain[1].x_end, 300)
    terrain[3] = terrains.new(world,1,decor, 1000, terrain[2].x_end, _CY)
    terrain[4] = terrains.new(world,1,decor, 800,terrain[3].x_end, _CY-150)
    terrain[5] = terrains.new(world,1,decor, 200,terrain[4].x_end, _CY-150)
    
    blockade = display.newImageRect(world, "assets/background/border.png" , 300, 1000)
    blockade.x, blockade.y = terrain[5].x_end + 120, _CY-150
    physics.addBody( blockade, "static", {density = 100, bounce = 0, friction = 1})
    
    --enemies
    musuh = display.newRect(world, 500, _CY-20 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 800, 250 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 1500, _CY-20 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2000, _CY-20 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2400, _CY-160 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)
    musuh = display.newRect(world, 2350, _CY-160 , 100, 100)
    musuh = enemy.new(musuh, "pocong", hero)
    table.insert(enemies, musuh)

    --boss
    --boss = display.newRect(world, 300, _CY, 170, 280)
    boss = bosss.new(boss, world, hero, 1)
    boss.x, boss.y = 2900, _CY - 260 

    --key
    function key(event)
        if event.phase == "up" and not world.pause then
            if event.keyName == "attack" or event.keyName == "t" then
                for index, value in ipairs(enemies) do
                    --print( value.type .. " - " .. value.x .. " - " .. value.y)
                    --print( hero.x .. " - " .. hero.y)
                    json.prettify( hero )
                    json.prettify( enemies )
                    if value.type == "enemy" and index ~= temp and value.isDead ~= true then
                        if hero.direction == "right" then
                            if value.x >= hero.x and value.x < hero.x+120  then
                                print("damage" .. hero.damage)
                                print("level" .. hero.level)
                                value:hurt(hero.damage)
                                if value.hp <= 0 then
                                    hero:kill(value.name)
                                    dead(value.x, value.y)
                                    value.isDead = true
                                end
                            end
                        else
                            if value.x <= hero.x and value.x > hero.x-120  then
                                print("damage" .. hero.damage)
                                print("level" .. hero.level)
                                value:hurt(hero.damage)
                                if value.hp <= 0 then
                                    hero:kill(value.name)
                                    dead(value.x, value.y)
                                    value.isDead = true
                                end
                            end
                        end
                        
                    end
                end
                if boss and boss.isDead ~= true then
                    if hero.direction == "right" then
                        if boss and (boss.x >= hero.x and boss.x < hero.x+120)  then
                            boss:hurt(hero.damage)
                            if boss.isDead then
                                boss.isVisible = false
                                fx.fadeOut( function()
                                    composer.gotoScene( "scenes.menu")
                                end )
                            end
                        end
                    else
                        if boss and (boss.x <= hero.x and boss.x > hero.x-120)  then
                            boss:hurt(hero.damage)
                            if boss.isDead then
                                boss.isVisible = false
                                fx.fadeOut( function()
                                    composer.gotoScene( "scenes.menu")
                                end )
                            end
                        end
                    end
                end
            end
            --skills
            if event.keyName == "attack" or event.keyName == "t" then
                for index, value in ipairs(enemies) do
                    --print( value.type .. " - " .. value.x .. " - " .. value.y)
                    --print( hero.x .. " - " .. hero.y)
                    json.prettify( hero )
                    json.prettify( enemies )
                    if value.type == "enemy" and index ~= temp and value.isDead ~= true then
                        if hero.direction == "right" then
                            if value.x >= hero.x and value.x < hero.x+120  then
                                print("damage" .. hero.damage)
                                print("level" .. hero.level)
                                value:hurt(hero.damage)
                                if value.hp <= 0 then
                                    hero:kill(value.name)
                                    dead(value.x, value.y)
                                    value.isDead = true
                                end
                            end
                        else
                            if value.x <= hero.x and value.x > hero.x-120  then
                                print("damage" .. hero.damage)
                                print("level" .. hero.level)
                                value:hurt(hero.damage)
                                if value.hp <= 0 then
                                    hero:kill(value.name)
                                    dead(value.x, value.y)
                                    value.isDead = true
                                end
                            end
                        end
                        
                    end
                end
                if boss and boss.isDead ~= true then
                    if hero.direction == "right" then
                        if boss and (boss.x >= hero.x and boss.x < hero.x+120)  then
                            boss:hurt(hero.damage)
                            if boss.isDead then
                                boss.isVisible = false
                                fx.fadeOut( function()
                                    composer.gotoScene( "scenes.menu")
                                end )
                            end
                        end
                    else
                        if boss and (boss.x <= hero.x and boss.x > hero.x-120)  then
                            boss:hurt(hero.damage)
                            if boss.isDead then
                                boss.isVisible = false
                                fx.fadeOut( function()
                                    composer.gotoScene( "scenes.menu")
                                end )
                            end
                        end
                    end
                end
            end
            if event.keyName == "back" or event.keyName == "escape" then
                world.pause = true
                local pausemenu = display.newImage( sceneGroup,"assets/menu/pause-menu.png", 180, 180)
                pausemenu.x, pausemenu.y = 400, 150
                
                local txtSound = display.newText("Sound ", 350, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtSound.fill = {color.hex2rgb("#dba400")}

                local txtSoundOnOff = display.newText("Off ", 450, 120, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtSoundOnOff.fill = {color.hex2rgb("#dba400")}

                local txtBlood = display.newText("Blood ", 347, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtBlood.fill = {color.hex2rgb("#dba400")}

                local txtBloodOnoff = display.newText("On ", 450, 155, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtBloodOnoff.fill = {color.hex2rgb("#dba400")}

                local txtResume = display.newText("Resume ", 362, 190, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtResume.fill = {color.hex2rgb("#dba400")}

                local txtBack = display.newText("Back", 342, 225, "assets/fonts/Shadow of the Deads.ttf", 15)
                txtBack.fill = {color.hex2rgb("#dba400")}

                txtBlood:addEventListener("tap", blood)
                txtResume:addEventListener("tap", resume)
                txtSound:addEventListener("tap", sound)
                txtBack:addEventListener("tap", goBack)

                print(world.pause)
                print("in the event")
                if not world.pause then
                    pausemenu = nil
                    txtBack:removeEventListener("tap")
                    txtBlood:removeEventListener("tap")
                    txtSound:removeEventListener("tap")
                    txtResume:removeEventListener("tap")
                    display.remove(pausemenu)
                    display.remove(txtBack)
                    display.remove(txtBlood)
                    display.remove(txtSound)
                    display.remove(txtResume)
                end
            end
        end
    end 

    
    --
    --local uniqueskill = display.newImage( sceneGroup,"assets/menu/unique-skill.png", 150, 180)
    --uniqueskill.x, uniqueskill.y = 400, 180
    --local uniqueskillicon = display.newImage( sceneGroup,"assets/main-character/skills/multi-slash.png")
    --uniqueskillicon.x, uniqueskillicon.y = 400, 160
    --local uniqueskillTxt = display.newText("Multi Slash ", 400, 210, "assets/fonts/Shadow of the Deads.ttf", 10)
    --uniqueskillTxt.fill = {color.hex2rgb("#dba400")}
--
    --local commonskill = display.newImage( sceneGroup,"assets/menu/common-skill.png", 150, 180)
    --commonskill.x, commonskill.y = 200, 180
    --local commonskillIcon = display.newImage( sceneGroup,"assets/main-character/skills/mega-slash.png")
    --commonskillIcon.x, commonskillIcon.y = 200, 160
    --local commonskillTxt = display.newText("Mega Slash ", 200, 210, "assets/fonts/Shadow of the Deads.ttf", 10)
    --commonskillTxt.fill = {color.hex2rgb("#dba400")}
--
    --local rareskill = display.newImage( sceneGroup, "assets/menu/rare-skill.png", 150, 180)
    --rareskill.x, rareskill.y = 600, 180
    --local rareskillIcon = display.newImage( sceneGroup,"assets/main-character/skills/earth-shatter-icon.png")
    --rareskillIcon.x, rareskillIcon.y = 600, 160
    --local rareskillTxt = display.newText("Earth Shatter", 600, 210, "assets/fonts/Shadow of the Deads.ttf", 10)
    --rareskillTxt.fill = {color.hex2rgb("#dba400")}
    --

    Runtime:addEventListener("key",key)
end

    
    --local aa = display.newRect(world, 125, 400, 10, 10)
local function enterFrame(event)

    if hero.x < 2570 then
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