local M = {}
function M.new(hero, parent)
    local group = display.newGroup()
    local bar = display.newImageRect(parent, "assets/main-character/skills/outer-healthbar.png" , 200, 30)
    local health = display.newImageRect(parent, "assets/main-character/skills/inner-health.png" , 200, 30)
    bar.x , bar.y = 120, 70
    health.x , health.y = 120, 70
    group:insert(health)
    group:insert(bar)

    local width = 200
    local temp = 1
    local function count(percent)
        
    end

    local function enterFrame()
        local percent = (hero.hp/hero.maxHP)
        if temp > percent then
            temp = percent
            health.width = width * percent
            health.x = 120 * percent
        end
    end

    function group:finalize()
        print("lol")
        Runtime:removeEventListener("enterFrame", enterFrame)
    end

    group:addEventListener("finalize")  
    Runtime:addEventListener("enterFrame", enterFrame)
    parent:insert(group)
    return group
end
return M