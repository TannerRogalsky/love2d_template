local Player = class('Player', Base)
Player.static.instances = {}

function Player:initialize(color, alpha_image, beta_image)
  Base.initialize(self)

  self.color = color

  self.alpha = Alpha:new(self, Vector(g.getWidth() / 2, g.getHeight() / 2), alpha_image)
  self.betas = {}

  self.spawning_cron_id = cron.every(1, function()
    local pos = self.alpha.position:clone()
    local beta = Beta:new(pos, self.alpha, beta_image)
    self.betas[beta.id] = beta
  end)

  Player.instances[self.id] = self
end

function Player:update(dt)
  for key,action in pairs(self.controls.keyboard) do
    if love.keyboard.isDown(key) then
      action(self, dt)
    end
  end

  self.alpha:update(dt)
  for _,beta in pairs(self.betas) do
    beta:update(dt)
  end
end

function Player:draw()
  self.alpha:draw()
  g.setColor(self.color:rgb())
  for _,beta in pairs(self.betas) do
    beta:draw(dt)
  end
end

function Player:up(dt)
  self.alpha._physics_body:move(0, -Alpha.SPEED * dt)
end

function Player:right(dt)
  self.alpha._physics_body:move(Alpha.SPEED * dt, 0)
end

function Player:down(dt)
  self.alpha._physics_body:move(0, Alpha.SPEED * dt)
end

function Player:left(dt)
  self.alpha._physics_body:move(-Alpha.SPEED * dt, 0)
end

function Player:destroy()
  cron.cancel(self.spawning_cron_id)
  Player.instances[self.id] = nil
  self.alpha:destroy()
end

return Player
