class Player
  def initialize(num,x,y)
    @num=num
    @x=x
    @y=y
    @movX=0
    @movY=0
    @nextMove=""
    @bombas=1
    @poder=3
    @vida=3
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
  def putBomba()
    if(@bombas>0)
      @bombas-=1
      return true
    end
    return false

  end
  def addBomba()
    @bombas+=1
  end
  def addPoder()
    @poder+=1
  end
  def poderBomba()
    return @poder
  end
  def getRow()
    return (@y+20)/50
  end
  def getColumn()
    return (@x+20)/50
  end
  def quitarVida()
    @vida-=1
    if(vida==0)
      @x=-100
      @y=-100
    end
  end
  def vida()
    return @vida
  end
end