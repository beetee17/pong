Ball = Class {}
function Ball:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height 
	self.dy = math.random(2) == 1 and -WINDOW_WIDTH/10 or WINDOW_WIDTH/10
	self.dx = math.random(2) == 1 and -(WINDOW_WIDTH/4) or (WINDOW_WIDTH/4)
end

function Ball:reset()
	self.x = WINDOW_WIDTH/2
	self.y = WINDOW_HEIGHT/2
	self.width = WINDOW_WIDTH/100
	self.height = WINDOW_HEIGHT/50
	self.dy = math.random(2) == 1 and -WINDOW_WIDTH/10 or WINDOW_WIDTH/10
	if TOTAL_SCORE > 0 then 
		self.dx = math.random(2) == 1 and -(WINDOW_WIDTH/4)-(TOTAL_SCORE*70) or (WINDOW_WIDTH/4)+(TOTAL_SCORE*70)
	else
		self.dx = math.random(2) == 1 and -(WINDOW_WIDTH/4) or (WINDOW_WIDTH/4)
	end
end

function Ball:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:move(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	if self.x > WINDOW_WIDTH*0.2 and self.x < WINDOW_WIDTH*0.8 then 
		has_collided = false
	end

	if not has_collided then 
		if player1:is_collided_with(self) then 
		self.dx = -self.dx*1.07
		has_collided = true
		love.audio.play(paddle_hit_sound)
		
		elseif player2:is_collided_with(self) then 
			self.dx = -self.dx*1.07
			has_collided = true
			love.audio.play(paddle_hit_sound)
		end
	end

	if self.y < self.height then 
		self.dy = -self.dy*1.07
		self.dx = self.dx*0.98
		love.audio.play(wall_hit_sound)

	elseif self.y > WINDOW_HEIGHT - self.height then 
		self.dy = -self.dy*1.07
		self.dx = self.dx*0.98
		love.audio.play(wall_hit_sound)
	end

end