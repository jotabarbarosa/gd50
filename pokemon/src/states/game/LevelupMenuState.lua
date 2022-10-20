--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelupMenuState = Class{__includes = BaseState}

function LevelupMenuState:init(player, starthp, startspeed, startattack, startdefense, battlestate)

self.battleState = battlestate
print('hp',starthp,'speed', startspeed,'attack', startattack,'defense', startdefense)
print('-------------------------------------------------------------------------------')
print_r(player)
	namePokemon = player.name
	HPPokemon = player.HP
	speedPokemon = player.speed
	attackPokemon = player.attack
	defensePokemon = player.defense
	
	
	increasehp = HPPokemon - starthp
	increasespeed = speedPokemon - startspeed
	increaseattack = attackPokemon - startattack
	increasedefense = defensePokemon - startdefense
print('-------------------------------------------------------------------------------')	
print('INhp',increasehp,'INspeed', increasespeed,'INattack', increaseattack,'INdefense', increasedefense)	
print('-------------------------------------------------------------------------------')
    
    self.levelupMenu = Menu {
		cursor = false,
        x = VIRTUAL_WIDTH / 2 - 100,
        y = VIRTUAL_HEIGHT / 2 - 75,
        width = 250,
        height = 170,
        items = {
            {
                text = tostring(namePokemon.. '  Stats'),
				onSelect = function()
					gStateStack:pop()
					gStateStack:push(PlayState())
                end
            },
            {
                text = 'Start    Increase    Result',
				onSelect = function()
					gStateStack:pop()
					gStateStack:push(PlayState())

                end

            },
			{
                text = tostring('HP: ' .. starthp .. '        ' .. increasehp ..'          '.. HPPokemon),
				onSelect = function()
                    gStateStack:pop()
					gStateStack:push(PlayState())

                end
            },
			{
                text = tostring('Speed: ' .. startspeed .. '    ' .. increasespeed .. '          ' .. speedPokemon),
				onSelect = function()
                    gStateStack:pop()
					gStateStack:push(PlayState())

                end
            },
			{ 
                text = tostring('Attack: ' .. startattack .. '   ' .. increaseattack .. '          ' .. attackPokemon),
				onSelect = function()
                    gStateStack:pop()
					gStateStack:push(PlayState())

                end
            },
			{
                text = tostring('Defense: ' .. startdefense .. '  ' .. increasedefense .. '          ' .. defensePokemon),
				onSelect = function()
                    gStateStack:pop()
					gStateStack:push(PlayState())

                end
            }
        }
    }
end

function LevelupMenuState:update(dt)
    self.levelupMenu:update(dt)
end

function LevelupMenuState:render()
    self.levelupMenu:render()
end