Class = require 'class'
require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 640
max_FPS = 60

PADDLE_SPEED = WINDOW_HEIGHT/1.5

PLAYER1_SCORE = 0
PLAYER2_SCORE = 0
TOTAL_SCORE = 0
BEST_OF = 5

game_state = 'start'

function love.load()
	min_dt = 1/max_FPS
    next_time = love.timer.getTime()
	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = false
		})

	love.window.setTitle('Pong')

	math.randomseed(os.time())

	player1 = Paddle(WINDOW_WIDTH*0.012, WINDOW_HEIGHT/2, 
		WINDOW_WIDTH/100, WINDOW_HEIGHT/8)

	player2 = Paddle(WINDOW_WIDTH*0.98, WINDOW_HEIGHT/2, 
		WINDOW_WIDTH/100, WINDOW_HEIGHT/8)

	ball = Ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 
		WINDOW_WIDTH/100, WINDOW_HEIGHT/50)

	score_sound = love.audio.newSource('score.wav', 'static')
	paddle_hit_sound = love.audio.newSource('paddle_hit.wav', 'static')
	wall_hit_sound = love.audio.newSource('wall_hit.wav', 'static')
end


function love.draw()

	love.graphics.clear(0.1,0.1,0.1,1)
	main_font = love.graphics.newFont('ARCADECLASSIC.TTF',WINDOW_WIDTH/40)
	love.graphics.setFont(main_font)

	if game_state == 'start' then 
		love.graphics.printf("Press   Enter   to   Begin!",
		0, WINDOW_HEIGHT*0.4, (WINDOW_WIDTH),
		'center')
		draw_play_screen()
	end

	if game_state == 'play' then
		draw_play_screen()
	end


	if game_state == 'Player 1 Win' then 
		draw_game_over('Player   1')
	end
	
	if game_state == 'Player 2 Win' then 
		draw_game_over('Player   2')
	end
	local cur_time = love.timer.getTime()
    if next_time <= cur_time then
      next_time = cur_time
      return
    end
    love.timer.sleep(next_time - cur_time)
end

function love.update(dt)

	next_time = next_time + min_dt
	if game_state == 'play' then 

		ball:move(dt)

		if love.keyboard.isDown('w') then 
			player1.dy = -PADDLE_SPEED
			player1:move(dt)
		end

		if love.keyboard.isDown('s') then 
			player1.dy = PADDLE_SPEED
			player1:move(dt)
		end


		if love.keyboard.isDown('up') then 
			player2.dy = -PADDLE_SPEED
			player2:move(dt)
		end

		if love.keyboard.isDown('down') then 
			player2.dy = PADDLE_SPEED
			player2:move(dt)
		end

		if ball.x < -player1.width then 
			PLAYER2_SCORE = PLAYER2_SCORE + 1
			TOTAL_SCORE = TOTAL_SCORE + 1
			ball:reset()
			love.audio.play(score_sound)
			game_state = 'start'
		end

		if ball.x > WINDOW_WIDTH then 
			PLAYER1_SCORE = PLAYER1_SCORE + 1
			TOTAL_SCORE = TOTAL_SCORE + 1
			ball:reset()
			love.audio.play(score_sound)
			game_state = 'start'
		end

		if PLAYER1_SCORE == BEST_OF then 
			game_state = 'Player 1 Win'

		elseif PLAYER2_SCORE == BEST_OF then 
			game_state = 'Player 2 Win'
		end
	end

end



function love.keypressed(key)
	if key == 'escape' then 
		love.event.quit()
	end
	if game_state == 'start' then
		if key == 'return' then 
			game_state = 'play'
		end
	end

	if game_state == 'Player 1 Win' 
	or game_state == 'Player 2 Win' then 
		if key == 'return' then 
			game_state = 'start'
			PLAYER1_SCORE = 0
			PLAYER2_SCORE = 0
			TOTAL_SCORE = 0
			ball:reset()
		end
	end
end


function draw_game_over(winner)
	large_font = love.graphics.newFont('ARCADECLASSIC.TTF',WINDOW_WIDTH/18)
	love.graphics.setFont(large_font)

	love.graphics.printf(winner.. "  Wins!",
	0, WINDOW_HEIGHT*0.4, (WINDOW_WIDTH),
	'center')

	love.graphics.printf("Press   Enter   to   Play   Again!",
	0, WINDOW_HEIGHT/2, (WINDOW_WIDTH),
	'center')
end

function draw_play_screen()
	displayFPS()

	love.graphics.setColor(1,1,1,1)

	love.graphics.printf('WELCOME   TO   PONG!',
		0, WINDOW_HEIGHT/64, (WINDOW_WIDTH),
		'center')

	score_font = love.graphics.newFont('ARCADECLASSIC.TTF',WINDOW_WIDTH/16)
	love.graphics.setFont(score_font)

	love.graphics.printf(tostring(PLAYER1_SCORE),
	WINDOW_HEIGHT/16, WINDOW_HEIGHT/16, (WINDOW_WIDTH*0.85),
	'center')

	love.graphics.printf(tostring(PLAYER2_SCORE),
	WINDOW_HEIGHT/16, WINDOW_HEIGHT/16, (WINDOW_WIDTH),
	'center')


	-- drawing paddles on either side of screen

	player1:draw()
	player2:draw()
	

	-- drawing ball (square) at center

	ball:draw()


end

function displayFPS()
    -- simple FPS display across all states
    fps_font = love.graphics.newFont('ARCADECLASSIC.TTF', WINDOW_WIDTH/48)
	love.graphics.setFont(fps_font)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS ' .. tostring(love.timer.getFPS()), 10, 10)
end

function love.resize(w, h)
	player1 = Paddle(w*0.012, h/2, w/100, h/8)

	player2 = Paddle(w*0.98, h/2, w/100, h/8)

	ball = Ball(w/2, h/2, w/100, h/50)

	ball.dy = math.random(2) == 1 and -w/10 or w/10
	ball.dx = math.random(2) == 1 and -w/4 or w/4

	PADDLE_SPEED = h/1.5

	WINDOW_HEIGHT = h

	WINDOW_WIDTH = w 


	love.draw()
end


