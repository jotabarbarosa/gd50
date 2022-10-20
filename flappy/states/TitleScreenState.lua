--[[
    TitleScreenState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The TitleScreenState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- transition to countdown when enter/return are pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    -- simple UI code
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Play', 0, 100, VIRTUAL_WIDTH, 'center')


    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press P to Pause/Resume', 0, 120, VIRTUAL_WIDTH, 'center')

end


--[[
    Called when this state is transitioned to from another state.
]]
function TitleScreenState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function TitleScreenState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
