--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Pokemon = Class{}

function Pokemon:init(def, level)
    self.name = def.name

    self.battleSpriteFront = def.battleSpriteFront
    self.battleSpriteBack = def.battleSpriteBack

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseSpeed = def.baseSpeed

    self.HPIV = def.HPIV
    self.attackIV = def.attackIV
    self.defenseIV = def.defenseIV
    self.speedIV = def.speedIV

    self.HP = self.baseHP
    self.attack = self.baseAttack
    self.defense = self.baseDefense
    self.speed = self.baseSpeed

    self.level = level
	print_r(self.level)
	---print(level)
    self.currentExp = 0
    self.expToLevel = self.level * self.level * 5 * 0.75
	
--[[
print('------------------------------------------------------------')
print('inicialize stats')
print('base HP', self.baseHP)
print('base Attack', self.baseAttack)
print('base Defense', self.baseDefense)
print('base Speed', self.baseSpeed)
print('------------------------------------------------------------')
]]
    self:calculateStats()

    self.currentHP = self.HP
	self.sobelevel = false
end

function Pokemon:calculateStats()
    for i = 1, self.level do
        self:statsLevelUp()
    end
end

function Pokemon.getRandomDef()
    return POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]]
end

--[[
    Takes the IV (individual value) for each stat into consideration and rolls
    the dice 3 times to see if that number is less than or equal to the IV (capped at 5).
    The dice is capped at 6 just so no stat ever increases by 3 each time, but
    higher IVs will on average give higher stat increases per level. Returns all of
    the increases so they can be displayed in the TakeTurnState on level up.
]]
function Pokemon:statsLevelUp()
--[[
print('----------------------------------------------------------------')
print('Antes de increase')
print('HP', self.HP, 'Speed', self.speed, 'Defense',self.defense, 'Atack', self.attack)
print('----------------------------------------------------------------')
]]
    local HPIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 1
            HPIncrease = HPIncrease + 1
        end
    end

    local attackIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attackIncrease = attackIncrease + 1
        end
    end

    local defenseIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defenseIncrease = defenseIncrease + 1
        end
    end

    local speedIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.speedIV then
            self.speed = self.speed + 1
            speedIncrease = speedIncrease + 1
        end
    end
	--[[
	if self.sobelevel then
print('----------------------------------------------------------------')
print('Com increase')
print( 'HP Increase',HPIncrease, 'Attack Increase',attackIncrease, 'Defense Increase' ,defenseIncrease, 'SpeedIncrease', speedIncrease)
		self.sobelevel = false
print('----------------------------------------------------------------')

	end
	]]
    return HPIncrease, attackIncrease, defenseIncrease, speedIncrease
end

function Pokemon:levelUp()
    self.level = self.level + 1
    self.expToLevel = self.level * self.level * 5 * 0.75
	--print(self.expToLevel)
	self.sobelevel = true
    return self:statsLevelUp()
end