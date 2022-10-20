--[[
    GD50
    Breakout Remake

    -- Brick Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a brick in the world space that the ball can collide with;
    differently colored bricks have different point values. On collision,
    the ball will bounce away depending on the angle of collision. When all
    bricks are cleared in the current map, the player should be taken to a new
    layout of bricks.
]]

Block = Class{}

function Block:init(x, y)

    
    self.x = x
    self.y = y
    self.width = 32
    self.height = 16
    
    -- used to determine whether this brick should be rendered
    self.inPlay = true
end

--[[
    Triggers a hit on the brick, taking it out of play if at 0 health or
    changing its color otherwise.
]]
function Block:hit()
    -- sound on hit
    gSounds['brick-hit-2']:play()

    self.inPlay = false
end

function Block:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], gFrames['blocks'][1],
            self.x, self.y)
    end
end