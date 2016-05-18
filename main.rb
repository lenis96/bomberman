require 'gosu'
#require "chingu"
#!/usr/bin/env ruby -w
require "socket"
class Client
  def initialize( server )
    @server = server
    @request = nil
    @response = nil
    listen
    @jugadores={1=>[0,0],2=>[0,0]}
    #send
    @server.puts( "ENTER PLAYER" )
    @mapa=["","","","","","","","","","","","",""]
    #@request.join
    #@response.join
  end
  def pos(j)
    return @jugadores[j]
  end
  def row(j)
    return @mapa[j]
  end
  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        #puts "#{msg}"
        msg=msg.split
        if(msg[0]=="PJ") then
          @jugadores[Integer(msg[1])][0]=Integer(msg[2])
          @jugadores[Integer(msg[1])][1]=Integer(msg[3])
        elsif(msg[0]=="ROW") then
          @mapa[Integer(msg[1])]=msg[2]
        end
      }
    end
  end

  def send(msg)
    #puts "Enter the username:"
    #msg = $stdin.gets.chomp
    
    #@request = Thread.new do
      #loop {
        #print ">>>"
        #msg = $stdin.gets.chomp
        @server.puts( msg )
        #return @server.gets.chomp
        
      #}
    #end
  end
end
class GameWindow < Gosu::Window
	def initialize width, height,fullscreen
		super(width, height, fullscreen)
		@sprite1=Gosu::Image.new(self,"jugador1.png",false)
    @sprite2=Gosu::Image.new(self,"jugador2.png",false)
    @muros=[]
    for i in 0..12
      @muros<<[]
      for j in 0..12
        @muros[i]<<Gosu::Image.new(self,"muro.png",false)
      end
    end
		server = TCPSocket.open( "192.168.250.235", 3000 )
		@con=Client.new( server )
    @inicioX=0
    @inicioY=0
	end

	def update
		if Gosu::button_down? Gosu::KbLeft then
			@con.send("KL")
		end
		if Gosu::button_down? Gosu::KbRight  then
			@con.send("KR")
    end
    if Gosu::button_down? Gosu::KbUp then
      @con.send("KU")
    end
    if Gosu::button_down? Gosu::KbDown then
      @con.send("KD")
    end
      #puts("#{Gosu::fps}")
	end

	def draw
    @con.send("PJ 1")
    @con.send("PJ 2")
    #@con.send("PJ 2")
    #@con.send("YP 1")
    pos=@con.pos(1)
    @sprite1.draw(pos[0],pos[1],0)#,scale_x=0.5,scale_y=0.5)
    pos=@con.pos(2)
    @sprite2.draw(pos[0],pos[1],0)#,scale_x=0.5,scale_y=0.5)
    for i in 0..12
      @con.send("ROW #{i}")
      l=@con.row(i)
      if(l!="")
      end
      for j in 0..l.length
        if(l[j]=="1")
          @muros[1][Integer(j)].draw(@inicioX+(j*50),@inicioY+(i*50),0)
        else
          #@muros[1][Integer(j)].draw(-100,50,0)
        end
      end
    end
	end

end
game_window=GameWindow.new(800,600,false)
game_window.show