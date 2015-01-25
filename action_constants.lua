local Stick = {
  Up = {lefty=-1, leftx=0, name="Up"},
  Down = {lefty=1, leftx=0, name="Down"},
  Right = {lefty=0, leftx=1, name="Right"},
  Left = {lefty=0, leftx=-1, name="Left"},
  None = {lefty=0, leftx=0, name="None"},
}

local Button = {
  A = 'a',
  B = 'b',
  X = 'x',
  Y = 'y',
  None = '.'
}

return {Stick = Stick, Button = Button}
