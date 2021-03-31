Paddle = Class {}
function Paddle:init(x, y, width, height, dy)
	self.x = x
	self.y = y
	self.width = width
	self.height = height 
	self.dy = 0
end

function Paddle:reset(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height 
end

function Paddle:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Paddle:move(dt)
	-- logic for boundary detection/handling
	if self.dy < 0 then 
		self.y = math.max(WINDOW_HEIGHT*0.005, self.y+self.dy*dt)
	elseif self.dy > 0 then 
		self.y = math.min(WINDOW_HEIGHT*0.995 - self.height, self.y+self.dy*dt)
	end
end

function Paddle:is_collided_with(ball)
	
	if self.x > ball.x + ball.width 
		or self.x + self.width < ball.x then 

		return false
	end

	if self. y > ball.y + ball.height
		or self.y + self.height < ball.y then 

		return false
	end

	return true
	
end


