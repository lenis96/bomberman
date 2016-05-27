class Player
  def initialize(num,x,y)
    @num=num
    @x=x
    @y=y
    @movX=0
    @movY=0
    @nextMove=""
  end
  def moveLeft()
    if(@x>=10) then
      @x-=10
    end
  end
  def moveRight()
    if(@x<=600)
      @x+=10
    end
  end
  def moveUp()
    if(@y>=10)
      @y-=10
    end
  end
  def moveDown()
    if(@y<=600)
      @y+=10
    end
  end
  def nextMove=(nextMove)
    @nextMove=nextMove
  end
  def nextMove()
    return @nextMove
  end
  def x()
    return @x
  end
  def y()
    return @y
  end
  def movX=(x)
    @movX=x
  end
  def movY=(y)
    @movY=y
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