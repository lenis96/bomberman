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
    @jugadores={1=>[0,0]}
    #send
    @server.puts( "ENTER PLAYER" )
    #@request.join
    #@response.join
  end
  def pos(j)
    return @jugadores[j]
  end
  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        #puts "#{msg}"
        msg=msg.split
        if(msg[0]=="XP") then
          @jugadores[Integer(msg[1])][0]=Integer(msg[2])
        elsif (msg[0]=="YP")then
          @jugadores[Integer(msg[1])][1]=Integer(msg[2])
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
		@sprite=Gosu::Image.new(self,"yuno1.png",false)
		server = TCPSocket.open( "192.168.250.37", 3000 )
		@con=Client.new( server )
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
    @con.send("XP 1")
    @con.send("YP 1")
    pos=@con.pos(1)
		@sprite.draw(pos[0],pos[1],0,scale_x=0.5,scale_y=0.5)
	end

end
game_window=GameWindow.new(800,600,false)
game_window.show