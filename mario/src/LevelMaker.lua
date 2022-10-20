--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height, nivel)
	--print('levelmaker nivel', nivel)
    local tiles = {}
    local entities = {}
    local objects = {}
	--print('levelmake',nivel)

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
	
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
		-- tile IDs
		--TILE_ID_EMPTY = 5
		--TILE_ID_GROUND = 3

        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
				-- tile id desenha sky ou ground aqui ta desenhando sky
        end

        -- chance to just be emptiness ACHO QUE É chasm no chão, background empty
		-- do nivel 7 pra baixo uma em cada sete vezes
		
		
		-- se em cada sete posicoes na tabela der chasm desenha vazio senao desenha tijolos
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
					--print(tiles[y].topper)
            end
        else
			-- quando radom nao der 7 é porque deve ser ground e nao desenha chasm desenha tijplos
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
			
			-- desenha blocos tipo cofre e chave com gem com altura de 4
			-- altura 
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
					-- define topper se tiver pillar? or nenhum topper
            end

            -- chance to generate a pillar
            if math.random(10) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end
			
--------------------------------------------------------------------------------
-- fim LOCKER no ar com KEYS
--------------------------------------------------------------------------------
			
            -- chance to spawn a LOCKER
            if math.random(5) == 1 then
			
			
                table.insert(objects,

                    -- jump LOCKS
                    GameObject {			
                        texture = 'locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        -- make it a random variant
                        frame = math.random(#LOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,
						
                        -- collision function takes itself
                        onCollide = function(obj)
	
						local keyframe = obj.frame
						--print('no objeto lock',obj.inplay,obj.texture)
						
						
						
						--------------------------------------------------------------------------------
						-- create a key								
						--------------------------------------------------------------------------------
						
                            -- spawn a KEY if we haven't already hit the block
                            if not obj.hit then
							--print(' not hit')

                                -- chance to spawn KEY, not guaranteed????
                                if math.random(3) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local key = GameObject {
                                        texture = 'keys',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = TILE_SIZE,
                                        height = TILE_SIZE,
										frame = keyframe,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
										
										

                                        -- KEYS has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 200
											obj.inplay = false
											obj.solid = false
											obtained =  true
											keycolor = keyframe
											--print(obtained)

											--print('qual objeto apagar',obj.texture, obj.inplay)
										
											
											if math.random(1) == 1 then
											
												-- maintain reference so we can set it to nil
												local post = GameObject {
													texture = 'posts',

													x = width * TILE_SIZE - TILE_SIZE,
													y = 48,																																																		
													width = TILE_SIZE,
													height = 48,
													frame =  3,--math.random(3, 6),
													collidable = true,
													solid = true,
													
													-- Post has its own function to add to the player's score
													onCollide = function(obj)

													end	
												}
												
												-- maintain reference so we can set it to nil
												local flag = GameObject {
													texture = 'flags',													
													x = post.x  - TILE_SIZE + 5,--width * TILE_SIZE - TILE_SIZE,
													y = post.y + 5,																																																		
													width = TILE_SIZE,
													height = TILE_SIZE,
													frame =  1,
													collidable = true,													
													solid = true,
													
													-- KEYS has its own function to add to the player's score
													onCollide = function(obj)
														gSounds['victory']:play()
														--print('next level')
														--gStateMachine:change('play')
														
														 gStateMachine:change('play', {
																score = player.score,
																nivel = nivel + 1
																
															})

													end	
												}
												
												
												
												
												
												--print(post.x)
												table.insert(objects, flag)
												table.insert(objects, post)
											end


											
                                        end
										
                                    }
									--print('key ',key.inplay,key.texture)

                                    -- make the key move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()
									--print(key)
							
                                    table.insert(objects, key)
                                end
								--print(key)
                                obj.hit = true
                            
							end

                            gSounds['empty-block']:play()
                        end ---  fim de criar objeto lock com key dentro
                    }
                )-- fim do insert locks em objects 
				

				
            end
			

			
			
--------------------------------------------------------------------------------
-- fim LOCKER no ar com KEYS
--------------------------------------------------------------------------------			

						
--------------------------------------------------------------------------------
--bloco no ar com gem
--------------------------------------------------------------------------------

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)
						
						--------------------------------------------------------------------------------
						-- create a gem								
						--------------------------------------------------------------------------------


                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(4) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
			
			
--------------------------------------------------------------------------------
-- fim bloco no ar com gem
--------------------------------------------------------------------------------			
			
			
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
	--print_r(map)
    
    return GameLevel(entities, objects, map)
end