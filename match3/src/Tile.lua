--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety)

	-- set number of shiny block to generate
	-- according to variety
	-- if variety increases with level then decreases number of shiny
	
	-- math.random(16) == 2 creates less shiny
	-- math.random(32) == 2 less and less shinees
	
	shinycount = 16
	
	if variety > 1 then
		shinycount = shinycount * variety
	end
	--if math.random(shinycount) == 2 then

	if math.random(shinycount) == 2 then
		self.shiny = true
	else
		self.shiny = false
	end
	
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
end

function Tile:render(x, y)
	--print(self.shiny)
	--if self.shiny == true then
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)
	
    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
		
		
		
	---local circulo = {r = 9}
	--Timer.tween(3,[circulo], {r= 6})
		
	if self.shiny == true then
	
	
	 --self.tile:renderParticles()
	 
		love.graphics.setLineWidth(1)
		love.graphics.setColor(255/255, 255/255, 255/255, 1)		
		love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 10)			
			
		love.graphics.setLineWidth(1)
		love.graphics.setColor(190/255, 140/255, 0/255, 1)		
		love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 9)
		
		
	--love.graphics.setLineWidth(1)	
	love.graphics.setColor(255/255, 205/255, 70/255, 1)
		love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 7)
		
		
	love.graphics.setColor(255/255, 205/255, 70/255, 1)		
		love.graphics.circle('fill', self.x+x+16,
        self.y+y+16, 6)
		
   -- love.graphics.setColor(255/255, 255/255, 0/255, 120/255)
    --love.graphics.rectangle('fill', self.x+x+6, self.y+y+6, 20, 20, 4)

	
	--love.graphics.setLineWidth(1)
		love.graphics.setColor(252/255, 255/255, 20/255, 1)		
		love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 5)
		

		
		love.graphics.setColor(255/255, 255/255, 2/255, 1)		
		love.graphics.circle('fill', self.x+x+16,
        self.y+y+16, 4)
		
		love.graphics.setColor(255/255, 255/255, 51/255, 1)
		love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 4)
		
		
		love.graphics.setColor(255/255, 255/255, 255/255, 1)		
		love.graphics.circle('fill', self.x+x+18,
        self.y+y+14, 3)
		--[[
		-- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.circle('fill', self.x+x+16,
        self.y+y+16, 8)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
		]]

		love.graphics.draw(psystem, self.x+x+18, self.y+y+14, 500)
		--love.graphics.draw(psystem2, self.x+x+18, self.y+y+14, 500)
	end	
		
	--[[	
	love.graphics.setColor(255/255, 153/255, 51/255, 1)
			love.graphics.circle('line', self.x+x+16,
        self.y+y+16, 6)	
		
			love.graphics.setColor(255/255, 255/255, 1/255, 1)
			love.graphics.circle('fill', self.x+x+16,
        self.y+y+16, 3)	
		]]
    --end
	
	
		--love.graphics.draw(psystem, love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5)

	
	
end

function Tile:renderParticles()
    love.graphics.draw(self.psystem, self.x + x+16, self.y +y+ 8)
end