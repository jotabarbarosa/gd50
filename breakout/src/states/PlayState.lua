--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}
--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level
	self.keys = params.keys 
	--print(#self.bricks)



    self.recoverPoints = 10000

    -- give ball random starting velocity
    self.ball[1].dx = math.random(-200, 200)
    self.ball[1].dy = math.random(-80, -100)
	
	inds = {}
		-- take x and y from las brick locked
	for k, brick in pairs(self.bricks) do
		if brick.inPlay then			
			x = brick.x
			y = brick.y
			ind = k
			table.insert(inds, k)
		end
	end
	--[[
	for k, x in pairs(inds) do
	
		print(inds[k])
	end
	print(#inds)
	]]
	x = self.bricks[math.random(#inds)].x
	y = self.bricks[math.random(#inds)].y
	
	-- initialize Powerup
    self.powerup = Powerup(x, y)
	self.powerup.inPlay = false
	
	-- initialize Powerkey
	x =  self.bricks[math.random(#inds)].x - 32
	y =  self.bricks[math.random(#inds)].y
	
	self.powerkey = Powerkey(x, y)
	self.powerkey.inPlay = false
	
	paddleg = 1500
	if self.score >= 1500 then
		paddleg = 5000
	end
	if self.score >= paddleg then
		grow = false
	else
		grow = true
	end
	collected = false
	gone = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
	
	for k, b in pairs(self.ball) do
		b:update(dt)
	end
	
	self.powerup:update(dt)
	self.powerkey:update(dt)
	
	if self.powerup:collides(self.paddle) then
		--self.powerup.inPlay = false
        -- reverse Y velocity if collision detected between paddle and powerup
		self.powerup.inPlay = false        
		self.powerup.dy = 0
		self.powerup.y = self.powerup.y + 200

        gSounds['paddle-hit']:play()
		
		--SOLUTION FROM https://github.com/khanna-aditya/CS-50-Assignments/blob/master/A2:%20Breakout/src/states/PlayState.lua
		for i = 1, 4 do
			b = Ball()
			b.skin = math.random(7)
			b.x = self.ball[i].x
			b.y = self.ball[i].y
			b.dx = self.ball[i].dx + math.random(-15, -15)
			b.dy = self.ball[i].dy + math.random(-10, -10)
			table.insert(self.ball, b)
		end
    end
	
	if self.powerkey:collides(self.paddle) then	
		--self.powerkey.inPlay = false
        -- move powerkey out of screen 300px and stop velocity
        --self.powerkey.inplay = false
		self.powerkey.dy = 0
		self.powerkey.y = self.powerkey.y + 300
		collected = true
		--table.remove(self.powerkey)		
        gSounds['paddle-hit']:play()
	end
		
		
		

	-- detect collition balls and paddles	
	for k, bola in pairs(self.ball) do	
		if bola:collides(self.paddle) then
			-- raise ball above paddle in case it goes below it, then reverse dy
			bola.y = self.paddle.y - 8
			bola.dy = -bola.dy

			--
			-- tweak angle of bounce based on where it hits the paddle
			--

			-- if we hit the paddle on its left side while moving left...
			if bola.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				bola.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - bola.x))
			
			-- else if we hit the paddle on its right side while moving right...
			elseif bola.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				bola.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - bola.x))
			end

			gSounds['paddle-hit']:play()
		end
	end



conta = 0




for l, bola in pairs(self.ball) do	
    -- detect collision across all bricks with the ball
    for k, brick in pairs(self.bricks) do
		--print(k, brick.x, #self.bricks)
        -- only check collision if we're in play
        if brick.inPlay and bola:collides(brick) then


			-- check if locked brick and if powerkey is collected
			-- if so score 200
			if brick.locked == true and collected == true then
					--if collected == true then
						brick.inPlay = false
						collected = true
						gSounds['brick-hit-1']:play()
						
						--add to the score
						self.score = self.score + 200
						

			else	
					--if locked and powerkey not collected do no score and 
					-- send another powerkey
					if brick.locked == true and collected == false then		
						if self.powerkey.y >= VIRTUAL_HEIGHT then
						
							x =   brick.x
							y =   brick.y
							x = math.random(32, VIRTUAL_WIDTH - 64)
							self.powerkey = Powerkey(x, y)
							self.powerkey.inPlay = true
							self.powerkey.dy = math.random(80, 100)
							gSounds['brick-hit-1']:play()
							
							

						end
							
					else
					

							
							
						--add to the score
						-- if not locked
						self.score = self.score + (brick.tier * 200 + brick.color * 25)
					end
			end
			
			if brick.locked == false then 
				if self.powerup.y >= VIRTUAL_HEIGHT then
					self.powerup = Powerup(math.random(64, VIRTUAL_WIDTH - 64), y )
					self.powerup.inPlay = true
					self.powerup.dy = math.random(100, 150)
					gSounds['brick-hit-1']:play()
				end
			end


			
           -- if score > 1000 e paddle can grow, then increase paddle width
			if self.score >= paddleg and grow == true then
					--print(self.paddle.size, self.paddle.width)
					self.paddle.size = self.paddle.size + 1
					self.paddle.width = self.paddle.width + 32
					--print(self.paddle.size, self.paddle.width)
					grow = false
			end
			
			-- trigger the brick's hit function, which removes it from play
			brick:hit()


			-- if brick locked send powerkey down for grabs
			if brick.locked then
				self.powerkey.inPlay = true
				self.powerkey.dy = math.random(80, 100)
			else				
				self.powerup.inPlay = true
				self.powerup.dy = math.random(60, 70)
			end
			


            -- if we have enough points, recover a point of health
            if self.score > self.recoverPoints then
                -- can't go above 3 health
                self.health = math.min(3, self.health + 1)

                -- multiply recover points by 2
                self.recoverPoints = math.min(100000, self.recoverPoints * 2)

                -- play recover sound effect
                gSounds['recover']:play()
            end

            -- go to our victory screen if there are no more bricks left
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory', {
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = bola,
					keys = self.keys,
                    recoverPoints = self.recoverPoints
                })
            end

            --
            -- collision code for bricks
            --
            -- we check to see if the opposite side of our velocity is outside of the brick;
            -- if it is, we trigger a collision on that side. else we're within the X + width of
            -- the brick and should check to see if the top or bottom edge is outside of the brick,
            -- colliding on the top or bottom accordingly 
            --

            -- left edge; only check if we're moving right, and offset the check by a couple of pixels
            -- so that flush corner hits register as Y flips, not X flips
            if bola.x + 2 < brick.x and bola.dx > 0 then
                
                -- flip x velocity and reset position outside of brick
                bola.dx = -bola.dx
                bola.x = brick.x - 8
            
            -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
            -- so that flush corner hits register as Y flips, not X flips
            elseif bola.x + 6 > brick.x + brick.width and bola.dx < 0 then
                
                -- flip x velocity and reset position outside of brick
                bola.dx = -bola.dx
                bola.x = brick.x + 32
            
            -- top edge if no X collisions, always check
            elseif bola.y < brick.y then
                
                -- flip y velocity and reset position outside of brick
                bola.dy = -bola.dy
                bola.y = brick.y - 8
            
            -- bottom edge if no X collisions or top collision, last possibility
            else
                
                -- flip y velocity and reset position outside of brick
                bola.dy = -bola.dy
                bola.y = brick.y + 16
            end

            -- slightly scale the y velocity to speed up the game, capping at +- 150
            if math.abs(bola.dy) < 150 then
                bola.dy = bola.dy * 1.02
            end

            -- only allow colliding with one brick, for corners
            break
        end
    end
end

	for j, bola in pairs(self.ball) do
		-- if ball goes below bounds, revert to serve state and decrease health
		if bola.y >= VIRTUAL_HEIGHT then
			table.remove(self.ball, j)
		end	
	end
	
	if #self.ball == 0 then
        self.health = self.health - 1
		collected = false
		
		if self.paddle.size > 2 then
			self.paddle.size = self.paddle.size - 1
			self.paddle.width = self.paddle.width - 32
		end
		
		
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level,
				keys = self.keys,
                recoverPoints = self.recoverPoints
            })
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end


function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
	
	--SOLUTION FROM https://github.com/khanna-aditya/CS-50-Assignments/blob/master/A2:%20Breakout/src/states/PlayState.lua
	for k, b in pairs(self.ball) do
		b:render()
	end
	
	self.powerup:render(4)
	
	
	self.powerkey:render(10)
	
--[[	
	if gone == true then
		ind = {}
		-- take x and y from las brick locked
		for k, brick in pairs(self.bricks) do
			if brick.inPlay then			
				table.insert(ind, k)
			end
		end
				-- initialize Powerkey
		x =  self.bricks[math.random(#ind)].x - 32
		y =  self.bricks[math.random(#ind)].y
		
		self.powerkey = Powerkey(x, y)
		self.powerkey.inPlay = false
		self.powerkey:render(10)
	end
]]	

    renderScore(self.score)
    renderHealth(self.health)
	
	-- if powerkey in play draw a powerkey icon close to hearts
	if collected then
        love.graphics.draw(gTextures['main'], gFrames['powerup'][10], VIRTUAL_WIDTH - 116,
			VIRTUAL_HEIGHT - 240, 0, 0.7) 
	end
	
	

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end