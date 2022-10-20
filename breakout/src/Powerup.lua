--[[
    GD50
    Breakout Remake

    -- Paddle Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a paddle that can move left and right. Used in the main
    program to deflect the ball toward the bricks; if the ball passes
    the paddle, the player loses one heart. The Paddle can have a skin,
    which the player gets to choose upon starting the game.
]]

Powerup = Class{}

--[[
    Our Paddle will initialize at the same spot every time, in the middle
    of the world horizontally, toward the bottom.
]]
function Powerup:init(x, y)
    -- x is placed in the middle
    self.x = x --VIRTUAL_WIDTH / 2 - 32

    -- y is placed a little above the bottom edge of the screen
    self.y = y --VIRTUAL_HEIGHT - 200
	
	
	self.inPlay = false

    -- start us off with no velocity
    self.dy = 0
    self.dx = 0

    -- starting dimensions
    self.width = 16
    self.height = 16

    -- the skin only has the effect of changing our color, used to offset us
    -- into the gPaddleSkins table later
    self.skin = 2

    -- the variant is which of the four paddle sizes we currently are; 2
    -- is the starting size, as the smallest is too tough to start with
    self.size = 1
	

end

function Powerup:hit()

	self.inplay = false
    gSounds['paddle-hit']:play()


end

function Powerup:update(dt)
--[[
	if self.x > 0 and self.y > 0 then
		self.falling = true
	end
	
	if self.falling == true then
		self.y = self.y + 1
	end
	]]
	
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt


end
function Powerup:collides(target)

    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end
    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end
--[[
    Render the paddle by drawing the main texture, passing in the quad
    that corresponds to the proper skin and size.
]]
function Powerup:render(quad)

    -- if powerup is in play draw ball
	if self.inPlay then
		love.graphics.draw(gTextures['main'], gFrames['powerup'][quad],
			self.x , self.y)
	end
end
