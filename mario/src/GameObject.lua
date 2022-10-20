 --[[
    GD50
    -- Super Mario Bros. Remake --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.texture = def.texture
    self.width = def.width
    self.height = def.height
    self.frame = def.frame
    self.solid = def.solid
    self.collidable = def.collidable
    self.consumable = def.consumable
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
	self.inplay = true
	self.obtained = false
	--print(self.inplay)
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:render()


	if self.inplay == true then
		if self.texture == 'flags' then
			--print(self.texture)			
			love.graphics.draw(gTextures[self.texture],
							   gFrames[self.texture][flagcurrentAnimation:getCurrentFrame()],							   
							   -- x to the flag center
							   math.floor(self.x) + self.width / 2,
							   -- y to the flag center
							   math.floor(self.y) + self.height / 2, 
							   -- 0 rotation
							   0,
							   -- flipped x axis
							   -1,
							   -- normal y axis
							   1,
							   -- offset to half flag width and height
							   self.width / 2,
							   self.height / 2

							   )
							   


		else
			if self.texture == 'keys' or self.texture == 'gems' then
				if self.texture == 'keys' then
					love.graphics.draw(psystem, self.x + TILE_SIZE / 2, self.y + TILE_SIZE / 2, 500)
					love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
				else
					love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
					love.graphics.draw(psystem, self.x + TILE_SIZE / 2 - 2, self.y + TILE_SIZE / 2 - 2, 500)
				end
				

			else
				
				love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame], self.x, self.y)
			end
	
		end
	end
	
end