
push = require 'push'

Class = require 'class'

require 'StateMachine'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/CountDownState'
require 'states/BaseState'
require 'states/PauseState'
require 'states/ScoreState'

require 'Bird'
require 'Pipe'
require 'PipePair'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

local bird = Bird()
local pipes = {}
local pipePairs = {}
local spawnTimer = 0

local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	math.randomseed(os.time())

	love.window.setTitle('Fifty Bird')

	-- arquivos de fontes
	smallFont = love.graphics.newFont('font.ttf', 8)
	mediumFont = love.graphics.newFont('flappy.ttf', 14)
	flappyFont = love.graphics.newFont('flappy.ttf', 28)
	hugeFont = love.graphics.newFont('flappy.ttf', 56)
	love.graphics.setFont(flappyFont)

    --  arquivos de som
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static'),
        ['pause'] = love.audio.newSource('pong.wav', 'static')
    }

    -- musica de entrada
    sounds['music']:setLooping(true)
    sounds['music']:play()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
	{
		vsync = true,
		fullscreen = false,
		resizable = true
	})


        gStateMachine = StateMachine {
            ['title'] = function() return TitleScreenState() end,
            ['countdown'] = function() return CountdownState() end,
            ['play'] = function() return PlayState() end,
            ['score'] = function() return ScoreState() end

        }


        gStateMachine:change('title')

	    love.keyboard.keysPressed = {}

    	-- initialize mouse input table
    	love.mouse.buttonsPressed = {}
end


function love.resize(w, h)
	push:resize(w,h)
end

function love.keypressed(key)

	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end

end


function love.mousepressed(x, y, button)
    --print(button)
    love.mouse.buttonsPressed[button] = true
end


function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    --print(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)

    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
    % BACKGROUND_LOOPING_POINT

    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
    % VIRTUAL_WIDTH


    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    --print(love.mouse.buttonsPressed[button])

end



function love.draw()
	push:start()
	love.graphics.draw(background, -backgroundScroll,0)
	
		

	for k, pair in pairs(pipePairs) do
    	pair:render()
	end
    
	
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-16)
    
    gStateMachine:render()

	push:finish()
end


