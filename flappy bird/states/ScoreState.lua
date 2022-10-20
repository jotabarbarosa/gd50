--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

local gmedal = love.graphics.newImage('gmedal.png')
local smedal = love.graphics.newImage('smedal.png')
local bmedal = love.graphics.newImage('bmedal.png')
local backgroundScroll = 0

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]


function ScoreState:enter(params)
    --print(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('You lost!', 0, 64, VIRTUAL_WIDTH, 'center')





    love.graphics.setFont(hugeFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    if self.score == 1 then
	    love.graphics.draw(bmedal, VIRTUAL_WIDTH - 130, 90)
    else 
        if self.score == 2 then
            love.graphics.draw(smedal, VIRTUAL_WIDTH - 130, 90)
        else
            if self.score >= 3 then
                love.graphics.draw(gmedal, VIRTUAL_WIDTH - 130, 90)
            end
        end
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter to Play Again!', 0, 170, VIRTUAL_WIDTH, 'center')
end
