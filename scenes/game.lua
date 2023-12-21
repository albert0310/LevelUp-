--
-- Import

local composer = require"composer"
local relayout = require"libs.relayout"
local physics = require "physics"
local terrains = require "scenes.objects.terrain"
local heroes = require "scenes.objects.hero"
local skills = require "scenes.objects.skills"
local bosss = require "scenes.objects.boss"
local health = require "scenes.objects.healthbar"
local enemy = require "scenes.objects.enemy"
local vjoy = require( "com.ponywolf.vjoy" )
local color = require "com.ponywolf.ponycolor"
local fx = require "com.ponywolf.ponyfx" 
local json = require "json"
local bullet = require "scenes.objects.bullet"
require("com.ponywolf.joykey").start()
--


-- Layout
local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY 

-- Scene
local scene = composer.newScene()
local sceneGroup
-- Set variables

local terrain, terrainCount, spawnTerrain = {}, 1
local world, hero, musuh, wall, BG, blockade, decor, healthbar, wave, skill, timeSecond
timeSecond = 0
local crescent
local enemies = {}
local enemy_total = 5
local enemy_total_increase = 5
local difficulty = 1
local enemies = {}
local bblood = composer.getVariable("bloodOnOff")
local textS = ""
local textB = ""
local bsound = composer.getVariable("soundOnOff")
local diessound, slashsound
local timerTxt
local lvlTxt
local liveTxt
local skills_rarity_bg = {"common-skill.png", "rare-skill.png", "unique-skill.png"}
local chosenSkills = {}
local countDownTimer
local countSkill = 0
--buttons
local back,right,left,attack,jump,dash,skill1,skill2,skill3,skill4,skill5
-- Groups
local _grpMain, _pauseGroup, _skillGroup
-- Sounds


--
-- Local functions

local function removepauseMenu()
    for i = _pauseGroup.numChildren , 1 , -1 do
        display.remove(_pauseGroup[i])
    end

    if #_skillGroup > 0 then
        for i = #_skillGroup , 1 , -1 do
            display.remove(_skillGroup[i])
        end
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

--skill menu
local function chooseRarity()
    local rand = math.random(1, 100)
    
    if rand <= 65 then
        return 1  -- Common skill
    elseif rand <= 90 then
        return 2  -- Rare skill
    else
        return 3  -- Unique skill
    end
end

local function getAvailableSkills()
    local availableSkills = {
        { "heal", "megaslash", "imunity", "earthshatter" },  -- Common skills
        { "lifesteal", "crescentslash" },                    -- Rare skills
        { "omnislash" }                                      -- Unique skill
    }

    local filteredSkills = {}
    for _, raritySkills in ipairs(availableSkills) do
        local filteredRaritySkills = {}
        for _, skill in ipairs(raritySkills) do
            if not table.contains(chosenSkills, skill) then
                table.insert(filteredRaritySkills, skill)
            end
        end
        table.insert(filteredSkills, filteredRaritySkills)
    end

    return filteredSkills
end

function table.contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

local function removeSkillMenu()
    print(_skillGroup.numChildren .. "sk")
    if _skillGroup.numChildren > 0 then
        for i = _skillGroup.numChildren , 1 , -1 do
            display.remove(_skillGroup[i])
        end
    end

    world.pause = false
end

local function addDifficulty(rarity)
    if rarity == "common-skill.png" then
        difficulty = difficulty + 1    
        print(difficulty .. "inside sk")
    elseif rarity == "rare-skill.png" then
        difficulty = difficulty + 2
    else
        difficulty = difficulty + 3
    end
end

local function skillChosen(event) 
    local chosenSkill = event.target.name
    local rarity = event.target.rarity
    
    if event.phase == "ended" then
        countSkill = countSkill + 1
        if skill1.name == nil then
            display.remove(skill1)
            skill1 = vjoy.newButton("assets/main-character/skills/"..chosenSkill..".png", "skill1", sceneGroup)
            skill1.name = chosenSkill
            skill1.x,skill1.y = display.actualContentWidth - 115 , _CY + 105
            skill1.xScale, skill1.yScale = 0.8, 0.8
            table.insert(chosenSkills, chosenSkill)
            addDifficulty(rarity)
            removeSkillMenu()
            return true
        end
        if skill2.name == nil then
            display.remove(skill2)
            skill2 = vjoy.newButton("assets/main-character/skills/"..chosenSkill..".png", "skill2", sceneGroup)
            skill2.name = chosenSkill
            skill2.x, skill2.y = display.actualContentWidth - 130 , _CY + 150
            skill2.xScale, skill2.yScale = 0.8, 0.8
            table.insert(chosenSkills, chosenSkill)
            addDifficulty(rarity)
            removeSkillMenu()
            return true
        end
        if skill3.name == nil then
            display.remove(skill3)
            skill3 = vjoy.newButton("assets/main-character/skills/"..chosenSkill..".png", "skill3", sceneGroup)
            skill3.name = chosenSkill
            skill3.x, skill3.y = display.actualContentWidth - 160 , _CY + 105
            skill3.xScale, skill3.yScale = 0.8, 0.8
            table.insert(chosenSkills, chosenSkill)
            addDifficulty(rarity)
            removeSkillMenu()
            return true
        end
        if skill4.name == nil then
            display.remove(skill4)
            skill4 = vjoy.newButton("assets/main-character/skills/"..chosenSkill..".png", "skill4", sceneGroup)
            skill4.name = chosenSkill
            skill4.x, skill4.y = display.actualContentWidth - 175 , _CY + 150
            skill4.xScale, skill4.yScale = 0.8, 0.8
            table.insert(chosenSkills, chosenSkill)
            addDifficulty(rarity)
            removeSkillMenu()
            return true
        end
        if skill5.name == nil then
            display.remove(skill5)
            skill5 = vjoy.newButton("assets/main-character/skills/"..chosenSkill..".png", "skill5", sceneGroup)
            skill5.name = chosenSkill
            skill5.x, skill5.y = display.actualContentWidth - 220 , _CY + 150
            skill5.xScale, skill5.yScale = 0.8, 0.8
            table.insert(chosenSkills, chosenSkill)
            addDifficulty(rarity)
            removeSkillMenu()
            return true
        end
    end
end

local function createSkillmenu()
    world.pause = true
    local availableSkills = getAvailableSkills()
    
    -- Check if there are available skills
    if #availableSkills == 0 then
        print("No available skills.")
        return
    end

    -- Choose three random skills with the specified probabilities
    local skillOptions = {}
    local rarityOptions = {}
    for i = 1, 3 do
        local rarityIndex = chooseRarity()
        local raritySkills = availableSkills[rarityIndex]

        -- Keep trying until a skill of the chosen rarity is available
        while #raritySkills == 0 do
            rarityIndex = chooseRarity()
            raritySkills = availableSkills[rarityIndex]
        end

        local skillIndex = math.random(1, #raritySkills)
        local skill = raritySkills[skillIndex]

        table.insert(skillOptions, skill)
        table.insert(rarityOptions, rarityIndex)
        table.remove(availableSkills[rarityIndex], skillIndex)
    end

    for index, skill in ipairs(skillOptions) do
        local skillmenu = display.newImage( _skillGroup,"assets/menu/" .. skills_rarity_bg[rarityOptions[index]], 180, 180)
        skillmenu.x, skillmenu.y =  _CX - (300 - (index * 160 )) , 150
        skillmenu.name = skill
        skillmenu.rarity = skills_rarity_bg[rarityOptions[index]]

        local skillIcon = display.newImage (_skillGroup, "assets/main-character/skills/"..skill..".png")
        skillIcon.x, skillIcon.y =  _CX - (300 - (index * 160 )) , 120

        local skillTxt = display.newText( skill:gsub("^%l", string.upper),  _CX - (300 - (index * 160 )) , 170, "assets/fonts/Shadow of the Deads.ttf", 13)
        skillTxt.fill = {color.hex2rgb("#dba400")}
        _skillGroup:insert(skillTxt)

        skillmenu:addEventListener("touch", skillChosen)
    end

end

--spawn Enemy
local function spawnEnemy(m)
    local enemytypes
    local chance
    enemies = {}
    if difficulty < 10 then
        enemytypes = {"pocong"}
        chance = {100}
    elseif difficulty < 15  then
        enemytypes = {"pocong", "kuyang"}
        chance = {75, 25}
    elseif difficulty < 25 then
        enemytypes = {"pocong", "kuyang", "buto"}
        chance = {40, 45, 15}
    else
        enemytypes = {"pocong", "kuyang", "buto", "sundel"}
        chance = {30, 35, 20, 15}
    end
    for i = 1, enemy_total, 1 do
        local x = math.random(50, (terrain[1].width+terrain[2].width+terrain[3].width - 200))
        musuh = display.newRect(world, x, _CY - 20 , 100, 100)
        local randNum = math.random(1, 100)
        local temptipe
        for i = 1, #enemytypes do
            if randNum <= chance[i] then
                temptipe = enemytypes[i]
            else
                randNum = randNum - chance[i]
            end
        end
        musuh = enemy.new(musuh, temptipe, hero)
        musuh.x, musuh.y = x , terrain[1].y_start-100
        if m then
            musuh.hp = musuh.hp + (musuh.hp * m + (musuh.hp * (difficulty*0.01)))
            print(musuh.hp)
            musuh.damage = musuh.damage + (musuh.damage * m)
        end
        table.insert(enemies, musuh)
    end
end

local function countDifficulty()
    print(difficulty .. "difficulty")
    enemy_total = enemy_total + math.floor(enemy_total_increase * difficulty/100)
    print("enemy total : " .. enemy_total)
    local m = 0.01 * difficulty
    spawnEnemy(m)
end

local function dead(x,y)
    if bsound then
        audio.play(diessound)
    end
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
    local temp_dead = 0
    for index, value in ipairs(enemies) do
        if value.isDead then
            temp_dead = temp_dead + 1
        end
    end
    print(world.score .. " world.score")
    print( temp_dead .. " - " .. #enemies)
    if world.score % 25  == 0 and world.score > 0 then
        difficulty = difficulty + 1
    end
    if temp_dead == #enemies then
        countDifficulty()
    end
end

local function slashingsound()
    if bsound then
        audio.play(slashsound)
    end
end

local function heroLeveledUp()
    lvlTxt.text = "Level " .. hero.level
    difficulty = difficulty + 1
    if countSkill < 5 then
        if hero.level%5 == 0 then
            createSkillmenu()
        end
    end
end

local function decreaseDiff()
    difficulty = difficulty - 3
    if difficulty <= 0 then
        difficulty = 1
    end
    local m = 0.01 * difficulty
    for index, musuh in ipairs(enemies) do
        musuh.hp = musuh.hp - (musuh.hp * m + (musuh.hp * (difficulty*0.01)))
        print(musuh.hp)
        musuh.damage = musuh.damage - (musuh.damage * m)
        print("new health " .. musuh.hp .. ' - ' .. musuh.damage)
    end
end

local function updateTime( event )
    if not world.pause then
        timeSecond = timeSecond + 1
    end
    local minutes = math.floor( timeSecond / 60 )
    local seconds = timeSecond % 60
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
    timerTxt.text = timeDisplay
    if timeSecond % 30 == 0 and timeSecond > 0 then
        difficulty = difficulty + 1
    end
    liveTxt.text = ( 3 - world.player_death) .. "X"
    if world.decrease then
        decreaseDiff()
        world.decrease = false
    end
end

local function addScore(type)
    if type == "pocong" then
        world.score = world.score + 10
    elseif type == "kuyang" then
        world.score = world.score + 8
    elseif type == "buto" then
        world.score = world.score + 15
    elseif type == "sundel" then
        world.score = world.score + 20
    end
end

--
--skills
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
                    local tempE = hero.level
                    hero:gainExp(value.type, (difficulty * 0.05))
                    dead(value.x, value.y)
                    value.isDead = true
                    if tempE < hero.level then
                        heroLeveledUp()
                    end
                    value.isDead = true
                    addScore(value.type)
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
                    local tempE = hero.level
                    hero:gainExp(value.type, (difficulty * 0.05))
                    dead(value.x, value.y)
                    value.isDead = true
                    if tempE < hero.level then
                        heroLeveledUp()
                    end
                    value.isDead = true
                    addScore(value.type)
                end
            end
        end
    end
    
end

local function omnislash()
    if hero.omnislashBool then
        hero.omnislash()
        skill.omnislash()
        for index, value in ipairs(enemies) do
            if value.name == "enemy" and value.isDead ~= true then
                if hero.direction == "right" then
                    if value.x >= hero.x - 50 and value.x < hero.x+250  then
                        value:hurt(hero.damage*2.5)
                    end
                else
                    if value.x <= hero.x + 50 and value.x > hero.x-250  then
                        value:hurt(hero.damage*2.5)
                    end
                end
                if value.hp <= 0 then
                    local tempE = hero.level
                    hero:gainExp(value.type, (difficulty * 0.05))
                    dead(value.x, value.y)
                    value.isDead = true
                    if tempE < hero.level then
                        heroLeveledUp()
                    end
                    value.isDead = true
                    addScore(value.type)
                end
            end
        end
    end
end

local function heal()
    hero:heal()
end

local function crescentslash()
    if hero.crescentslashBool then
        hero:setSequence("attack-2")
        hero:play()
        hero.crescentslash()
        skill.crescentslash()
        for index, value in ipairs(enemies) do
            if value.name == "enemy" and value.isDead ~= true then
                if hero.direction == "right" then
                    if value.x >= hero.x  and value.x < hero.x+250  then
                        print("waa")
                        value:hurt(hero.damage*0.5)
                    end
                else
                    if value.x <= hero.x and value.x > hero.x-250  then
                        value:hurt(hero.damage*0.5)
                    end
                end
                if value.hp <= 0 then
                    local tempE = hero.level
                    hero:gainExp(value.type, (difficulty * 0.05))
                    dead(value.x, value.y)
                    value.isDead = true
                    if tempE < hero.level then
                        heroLeveledUp()
                    end
                    value.isDead = true
                    addScore(value.type)
                end
            end
        end
    end
end
--


-- Scene events functions

function scene:create( event )
    sceneGroup = self.view
    print("scene:create - ingame")
    physics.start()
    _pauseGroup = display.newGroup()
    _skillGroup = display.newGroup()

    BG = display.newGroup()
    local background = display.newRect(BG , _CX, _CY,  display.pixelWidth, display.pixelHeight)
    background.fill =  {color.hex2rgb("191c54")}
    sceneGroup:insert(BG)

    world = display.newGroup()
    world.score = 0
    world.player_death = 0
    world.decrease = false
    world.pause = false
    sceneGroup:insert(world)

    -- createSkillmenu()
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
        skill1 = vjoy.newButton("assets/main-character/skills/locked.png", "skill1", sceneGroup)
        skill2 = vjoy.newButton("assets/main-character/skills/locked.png", "skill2", sceneGroup)
        skill3 = vjoy.newButton("assets/main-character/skills/locked.png", "skill3", sceneGroup)
        skill4 = vjoy.newButton("assets/main-character/skills/locked.png", "skill4", sceneGroup)
        skill5 = vjoy.newButton("assets/main-character/skills/locked.png", "skill5", sceneGroup)
        --position
        back.x,back.y = display.actualContentWidth - 50 , 80
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
    --display heroes
    hero = heroes.new(hero,world)
    skill = skills.new(skill, hero, world)
    --healthbar
    healthbar = health.new(hero, sceneGroup)

    --timerTxt
    timerTxt = display.newText( sceneGroup,"00:00", _CX, _CY - 110, "assets/fonts/Shadow of the Deads.ttf", 15 )
    timerTxt:setFillColor( color.hex2rgb("#dba400") )
    countDownTimer = timer.performWithDelay( 1000, updateTime, -1)
    --lvlTxt
    local lvlBg = display.newImageRect(sceneGroup, "assets/menu/button.png", 150, 35)
    lvlBg.x , lvlBg.y= healthbar.x + 95 , healthbar.y + 30
    lvlTxt = display.newText( sceneGroup, "Level " .. hero.level, healthbar.x + 95 , healthbar.y + 30 , "assets/fonts/Shadow of the Deads.ttf", 12 )
    lvlTxt:setFillColor( color.hex2rgb("#dba400") )
    --liveTxt
    local lvlBg = display.newImageRect(sceneGroup, "assets/menu/button.png", 150, 35)
    lvlBg.x , lvlBg.y= healthbar.x + 700 , healthbar.y + 30
    liveTxt = display.newText( sceneGroup, ( 3 - world.player_death) .. "X", healthbar.x + 700 , healthbar.y + 30 , "assets/fonts/Shadow of the Deads.ttf", 12 )
    liveTxt:setFillColor( color.hex2rgb("#dba400") )
    --terrain
    decor = display.newGroup()
    world:insert(decor)

    terrain[1] = terrains.new(world, 1, decor, 700, 0, _CY)
    terrain[2] = terrains.new(world, 1, decor, 1000, terrain[1].x_end, 300)
    terrain[3] = terrains.new(world, 1, decor, 700, terrain[2].x_end, _CY)

    --blockadde
    blockade = display.newImageRect(world, "assets/background/border.png" , 300, 1000)
    blockade.x, blockade.y = terrain[3].x_end + 120, _CY-150
    blockade.xScale = -1
    physics.addBody( blockade, "static", {density = 100, bounce = 0, friction = 1})

    -- key
    function key(event)
        if event.phase == "up" then
            if event.keyName == "attack" or event.keyName == "t" then
                for index, value in ipairs(enemies) do
                    if value.isDead ~= true and value then
                        if hero.direction == "right" then
                            if value.x >= hero.x and value.x < hero.x+120  then
                                slashingsound()
                                value:hurt(hero.damage)
                                if hero.lifestealActive then
                                    hero:lifestealActivate()
                                end
                            end
                        else
                            if value.x <= hero.x and value.x > hero.x-120  then
                                slashingsound()
                                value:hurt(hero.damage)
                                if hero.lifestealActive then
                                    hero:lifestealActivate()
                                end
                            end
                        end
                        if value.hp <= 0 then
                            local tempE = hero.level
                            hero:gainExp(value.name, (difficulty * 0.05))
                            dead(value.x, value.y)
                            if tempE < hero.level then
                                heroLeveledUp()
                            end
                            value.isDead = true
                            addScore(value.type)
                        end
                    end
                end
            end
            if event.keyName == "skill1" then
                if skill1.name == "heal" then
                    heal()
                end
                if skill1.name == "megaslash" then
                    megaslash()
                end
                if skill1.name == "omnislash" then
                    omnislash()
                end
                if skill1.name == "earthshatter" then
                    earthshatter()
                end
                if skill1.name == "crescentslash" then
                    crescentslash()
                end
                if skill1.name == "imunity" then
                    hero:imunity()
                end
                if skill1.name == "lifesteal" then
                    hero:lifesteal()
                end
                if skill1.name then
                    skill1:onCD()
                end
            end
            if event.keyName == "skill2" then
                if skill2.name == "heal" then
                    heal()
                end
                if skill2.name == "megaslash" then
                    megaslash()
                end
                if skill2.name == "omnislash" then
                    omnislash()
                end
                if skill2.name == "earthshatter" then
                    earthshatter()
                end
                if skill2.name == "crescentslash" then
                    crescentslash()
                end
                if skill2.name == "imunity" then
                    hero:imunity()
                end
                if skill2.name == "lifesteal" then
                    hero:lifesteal()
                end
                if skill2.name then
                    skill2:onCD()
                end
            end
            if event.keyName == "skill3" then
                if skill3.name == "heal" then
                    heal()
                end
                if skill3.name == "megaslash" then
                    megaslash()
                end
                if skill3.name == "omnislash" then
                    omnislash()
                end
                if skill3.name == "earthshatter" then
                    earthshatter()
                end
                if skill3.name == "crescentslash" then
                    crescentslash()
                end
                if skill3.name == "imunity" then
                    hero:imunity()
                end
                if skill3.name == "lifesteal" then
                    hero:lifesteal()
                end
                if skill3.name then
                    skill3:onCD()
                end
            end
            if event.keyName == "skill4" then
                if skill4.name == "heal" then
                    heal()
                end
                if skill4.name == "megaslash" then
                    megaslash()
                end
                if skill4.name == "omnislash" then
                    omnislash()
                end
                if skill4.name == "earthshatter" then
                    earthshatter()
                end
                if skill4.name == "crescentslash" then
                    crescentslash()
                end
                if skill4.name == "imunity" then
                    hero:imunity()
                end
                if skill4.name == "lifesteal" then
                    hero:lifesteal()
                end
                if skill4.name then
                    skill4:onCD()
                end
            end
            if event.keyName == "skill5" then
                if skill5.name == "heal" then
                    heal()
                end
                if skill5.name == "megaslash" then
                    megaslash()
                end
                if skill5.name == "omnislash" then
                    omnislash()
                end
                if skill5.name == "earthshatter" then
                    earthshatter()
                end
                if skill5.name == "crescentslash" then
                    crescentslash()
                end
                if skill5.name == "imunity" then
                    hero:imunity()
                end
                if skill5.name == "lifesteal" then
                    hero:lifesteal()
                end
                if skill5.name then
                    skill5:onCD()
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

    countDifficulty()

    Runtime:addEventListener("key",key)
end

local function enterFrame(event)
    if hero.healBool then
        if skill1.name == "heal" then
            skill1:offCD()
        end
        if skill2.name == "heal" then
            skill2:offCD()
        end
        if skill3.name == "heal" then
            skill3:offCD()
        end
        if skill4.name == "heal" then
            skill4:offCD()
        end
        if skill5.name == "heal" then
            skill5:offCD()
        end
    end
    if hero.megaslashBool then
        if skill1.name == "megaslash" then
            skill1:offCD()
        end
        if skill2.name == "megaslash" then
            skill2:offCD()
        end
        if skill3.name == "megaslash" then
            skill3:offCD()
        end
        if skill4.name == "megaslash" then
            skill4:offCD()
        end
        if skill5.name == "megaslash" then
            skill5:offCD()
        end
    end
    if hero.earthshatterBool then
        if skill1.name == "earthshatter" then
            skill1:offCD()
        end
        if skill2.name == "earthshatter" then
            skill2:offCD()
        end
        if skill3.name == "earthshatter" then
            skill3:offCD()
        end
        if skill4.name == "earthshatter" then
            skill4:offCD()
        end
        if skill5.name == "earthshatter" then
            skill5:offCD()
        end
    end
    if hero.imunityBool then
        if skill1.name == "imunity" then
            skill1:offCD()
        end
        if skill2.name == "imunity" then
            skill2:offCD()
        end
        if skill3.name == "imunity" then
            skill3:offCD()
        end
        if skill4.name == "imunity" then
            skill4:offCD()
        end
        if skill5.name == "imunity" then
            skill5:offCD()
        end
    end
    if hero.omnislashBool then
        if skill1.name == "omnislash" then
            skill1:offCD()
        end
        if skill2.name == "omnislash" then
            skill2:offCD()
        end
        if skill3.name == "omnislash" then
            skill3:offCD()
        end
        if skill4.name == "omnislash" then
            skill4:offCD()
        end
        if skill5.name == "omnislash" then
            skill5:offCD()
        end
    end
    if hero.crescentslashBool then
        if skill1.name == "crescentslash" then
            skill1:offCD()
        end
        if skill2.name == "crescentslash" then
            skill2:offCD()
        end
        if skill3.name == "crescentslash" then
            skill3:offCD()
        end
        if skill4.name == "crescentslash" then
            skill4:offCD()
        end
        if skill5.name == "crescentslash" then
            skill5:offCD()
        end  
    end

    if hero.lifestealBool then
        if skill1.name == "lifesteal" then
            skill1:offCD()
        end
        if skill2.name == "lifesteal" then
            skill2:offCD()
        end
        if skill3.name == "lifesteal" then
            skill3:offCD()
        end
        if skill4.name == "lifesteal" then
            skill4:offCD()
        end
        if skill5.name == "lifesteal" then
            skill5:offCD()
        end
    end
    --scroll screen
    if hero.x < 1800 or ((hero.x > 1000 and hero.y <= terrain[3].y_start - 150) and hero.x < terrain[3].x_end) then
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