local Stick = {
  Up = {lefty=-1, leftx=0},
  Down = {lefty=1, leftx=0},
  Right = {lefty=0, leftx=1},
  Left = {lefty=0, leftx=-1},
  None = {lefty=0, leftx=1},
}

local Button = {
  A = 'a',
  B = 'b',
  X = 'x',
  Y = 'y',
  None = '.'
}

return {Stick = Stick, Button = Button}
