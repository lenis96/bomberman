class Player
  def initialize(num,x,y)
    @num=num
    @x=x
    @y=y
    @nextMove=""
  end
  def moveLeft()
    if(@x>=10) then
      @x-=10
    end
  end
  def moveRight()
    @x+=10
  end
  def moveUp()
    @y-=10
  end
  def moveDown()
    @y+=10
  end
  def nextMove=(nextMove)
    @nextMove=nextMove
  end
  def x()
    return @x
  end
  def y()
    return @y
  end
  def update()
    if(@nextMove=="L") then
      moveLeft()
    elsif (@nextMove=="R")then 
      moveRight()
    elsif (@nextMove=="U")then 
      moveUp()
    elsif (@nextMove=="D")then 
      moveDown()
    end
    @nextMove=""
  end
end