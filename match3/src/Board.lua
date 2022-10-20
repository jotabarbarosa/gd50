--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
	self.level = level
	
	--print('entrou no board init')
	--print('init board', level)
	--self.isShiny = false
	--print(self.level, level)
    self.x = x
    self.y = y
    self.matches = {}
    self:initializeTiles(self.level)
end

function Board:initializeTiles(level)
	--print('entrou no board inicialize tile')
	self.level = level
	
    self.tiles = {}
	--print('init tiles', self.level)
	--print_r(Tile)
	
	if level > 6 then
		level = 6
	end

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
		

            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(9), math.random(level)))
        end
    end
	

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles(level)
    end
end




--[[


Only allow swapping when it results in a match. If there are no matches available 
to perform, reset the board. There are multiple ways to try and tackle this problem;
 choose whatever way you think is best! The simplest is probably just to try and test
 for Board:calculateMatches after a swap and just revert back if there is no match!
 The harder part is ensuring that potential matches exist; for this, the simplest 
 way is most likely to pretend swap everything left, right, up, and down, using 
 essentially the same reverting code as just above! However, be mindful that the 
 current implementation uses all of the blocks in the sprite sheet, which 
 mathematically makes it highly unlikely we’ll get a board with any viable matches
 in the first place; in order to fix this, be sure to instead only choose a subset 
 of tile colors to spawn in the Board (8 seems like a good number, though tweak to 
 taste!) before implementing this algorithm!


]]

--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
	
]]
function Board:calculateMatches()
	
	self.isShiny = false
	--print(self.isShiny)
    local matches = {}
	
    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1

        -- every horizontal tile
        for x = 2, 8 do
				
		    -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color
				
                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
					--print('Encontrados matchs hor',matchNum)
							
					--verifico se is Shiny dentro dos matchs que encontrou que é maior ou igual a 3
					for i = 1, matchNum  do
						--print('Verifico se tem shiny',self.tiles[y][x-i].shiny)
						if self.tiles[y][x-i].shiny == true then
							self.isShiny = true
						end
					end		
				
					local match = {}
					
					if self.isShiny then
						--print('COM shiny hor')
						
						--pego a ultima 
						local faltafim = 8 -  self.tiles[y][x-1].gridX
						
						--insiro toda a linha na table inter					
						--local inter = {}
						
						for i = 8, 1 , -1 do
					
							table.insert(match,self.tiles[y][x -1 + faltafim] )
							faltafim = faltafim - 1
						
						end
					
						--print_r(match)
					
					
						table.insert(matches, match)
					else
						--print('SEM shiny hoz')
						
						-- Se NAO TEM shiny block send match table to playstate
						-- somente o numero de matchs
						-- go backwards from here by matchNum
						for x2 = x - 1, x - matchNum, -1 do
							
							-- add each tile to the match that's in that match
							table.insert(match, self.tiles[y][x2])
						end

						-- add this match to our total matches table
						table.insert(matches, match)
						
					end			
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
		end	
				
        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
			
            --print_r(self.tiles)
			--verifico se is Shiny dentro dos matchs que encontrou que é maior ou igual a 3
			
			for i = 8, 8 - matchNum + 1, -1 do
				if self.tiles[y][i].shiny == true then
					self.isShiny = true
					print(self.isShiny)
				end
            end
			
			
			
			
			if self.isShiny then
				print('COM shiny')
				
				for i = 8, 1 , -1 do
			
					table.insert(match,self.tiles[y][i] )
					print(self.tiles[y][i].gridX)
				
				end
			
				--print_r(match)
			
			
				table.insert(matches, match)
			else

				print('dentro horizontal',self.isShiny)
				-- go backwards from end of last row by matchNum
				for x = 8, 8 - matchNum + 1, -1 do
					table.insert(match, self.tiles[y][x])
				end
			end

            table.insert(matches, match)
        end
			
    end
	
	--print_r(matches)
	


    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
		
		
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else

                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
								
					--print('Encontrados matchs vert',matchNum)

					--verifico se is Shiny dentro dos matchs que encontrou que é maior ou igual a 3
					for i = 1, matchNum  do
						--print('Verifico se tem shiny vert',self.tiles[y-i][x].shiny)
						if self.tiles[y-i][x].shiny == true then
							self.isShiny = true
						end
					end	
					--print('is shiny',self.isShiny)
					
					
					
					
					if self.isShiny then
					
						local match = {}
						--print('COM shiny vert')
						
						--pego a última 
						local faltaf = 8 -  self.tiles[y-1][x].gridY
						
						--insiro toda a linha na table inter					
						--local inter = {}
						
						for i = 8, 1 , -1 do					
							table.insert(match,self.tiles[y - 1 + faltaf][x] )
							faltaf = faltaf - 1						
						end
					
						--print_r(match)										
						table.insert(matches, match)
						
					else
						--print('SEM shiny vert')
						local match = {}

						for y2 = y - 1, y - matchNum, -1 do
							table.insert(match, self.tiles[y2][x])
						end

						table.insert(matches, match)
					end
                end
			
				
                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then					
            local match = {}

				-- go backwards from end of last row by matchNum
				for y = 8, 8 - matchNum + 1, -1 do
					table.insert(match, self.tiles[y][x])
					
				end
			

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches
	--print_r(self.matches)
	

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles(level)
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then
			
				if self.level > 6 then
				self.level = 6
				end

                -- new tile with random color and variety
                local tile = Tile(x, y, math.random(18), math.random(self.level))
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end
	--print(tweens.tile.y)

	
    return tweens
end

function Board:render()
    --print_r(self.tiles)

	--print('entrou em board render')

    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
				--print(self.tiles[y][x].shiny)
			--if self.tiles[y][x].shiny == true then
            self.tiles[y][x]:render(self.x, self.y)
			--end
        end
    end
end