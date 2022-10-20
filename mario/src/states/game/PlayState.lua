--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.camX = 0
    self.camY = 0
	
    flagAnimation = Animation {
        frames = {1, 2, 3, 2},
        interval = 0.18
    }
	
	flagcurrentAnimation = flagAnimation
	
	obtained = false
	keycolor = 1
	
	self.nivel = params.nivel
	--print(self.nivel)
	if self.nivel > 1 then
		LEVEL_WIDTH = LEVEL_WIDTH + (10 * self.nivel)
	end
	--print(LEVEL_WIDTH)
	
    self.level = LevelMaker.generate(LEVEL_WIDTH, 10, self.nivel)
    self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0
	--self.nivel = 1
	

	self:postScene()


	
    self.gravityOn = true
    self.gravityAmount = 6

    self.player = Player({
        x = 0, y = 0,
        width = 16, height = 20,
        texture = 'green-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level
    })
	
	if params.score then
		self.player.score = params.score 
		--print(self.player.score)
	end
	

    self:spawnEnemies()

    self.player:changeState('falling')
end

function PlayState:update(dt)
    Timer.update(dt)
	flagcurrentAnimation:update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
	--print(obtained)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))	
		
	if obtained then		
		-- draw columns no inicio
		love.graphics.draw(gTextures['mushrooms'], gFrames['mushrooms'][5], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 5), TILE_SIZE * 5)	
		love.graphics.draw(gTextures['mushrooms'], gFrames['mushrooms'][5], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 5), TILE_SIZE * 4)
		love.graphics.draw(gTextures['mushrooms'], gFrames['mushrooms'][3], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 5), TILE_SIZE * 3)
				
		-- draw line of bushes after 1 mush
		love.graphics.draw(gTextures['bushes-garden'], gFrames['bushes-garden'][4], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 4), TILE_SIZE * 5)
		
		-- draw mushrooms no meio
		love.graphics.draw(gTextures['mushrooms'], gFrames['mushrooms'][31], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 3), TILE_SIZE * 5)
		
		-- draw mushrooms antes do post
		love.graphics.draw(gTextures['mushrooms'], gFrames['mushrooms'][23], LEVEL_WIDTH * TILE_SIZE - (TILE_SIZE * 2), TILE_SIZE * 5)	
	end
	
    self.level:render()
    self.player:render()
    love.graphics.pop()

	if obtained then
		-- draw key and particle system
		love.graphics.draw(psystem, 10, 24, 500)	
		love.graphics.draw(gTextures['keys'], gFrames['keys'][keycolor], 5, 15)
		
	end
	
	--love.graphics.draw(gTextures['flags'], gFrames['flags'][flagcurrentAnimation:getCurrentFrame()], 5, 20)  
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end


function PlayState:postScene()

		-- make sure first ground column is not empty and has a topper
	--print_r(self.level.objects)
	--print('entrou',self.level.tileMap.tiles[7])
	--print(self.level.tileMap.tiles[7][1].id)
	


	if self.level.tileMap.tiles[7][1].id == 5 then
		self.level.tileMap.tiles[7][1].id = 3				
		self.level.tileMap.tiles[7][1].topper = true
		self.level.tileMap.tiles[8][1].id = 3				
		self.level.tileMap.tiles[9][1].id = 3				
	end
	-- make sure post ground is solid and free to walk 
	for i = LEVEL_WIDTH, LEVEL_WIDTH - 5, -1 do

		self.level.tileMap.tiles[6][i].id = 5
		self.level.tileMap.tiles[5][i].id = 5
		self.level.tileMap.tiles[7][i].id = 3
		self.level.tileMap.tiles[7][i].topper = true
		self.level.tileMap.tiles[8][i].id = 3				
		self.level.tileMap.tiles[9][i].id = 3	
	end
	
	
	
	
	

	
end