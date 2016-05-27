require 'socket'
require 'timeout'
require 'gosu'
class Client
	def initialize(ip,port)
		@host=ip
		@port=port
		
		@numJugador=getDato(send("PLAYER"),2)
		while(@numJugador=="ERROR")
			@numJugador=getDato(send("PLAYER"),2)
		end
		puts("#{@numJugador}")
	end
	def getDato(str,i)
		str=str.chomp().split()
		if(i<str.length)
			return str[i]
		else
			return str.last
		end
	end
	def getNumJugador()
		return @numJugador
	end
	def send(messege)
		r=""
		Timeout::timeout(0.1) do
			begin
				@socket=TCPSocket.new(@host,@port)
				@socket.puts(messege)
				begin
					while line=@socket.gets
						r+= line
					end
				rescue Exception => e
					return "ERROR"
				end
				

				@socket.close
				return r
			rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
				r= ("ERROR")
			end
		end
		rescue Timeout::Error
			r= "ERROR"
		return r
	end
end
class GameWindow < Gosu::Window
	def initialize()
		super(800,600,false)
		#@sprite1=Gosu::Image.new(self,"jugador1.png",false)
    	#@sprite2=Gosu::Image.new(self,"jugador2.png",false)
    	@spritesJugadores=[Gosu::Image.new(self,"jugador1.png",false)]
    	@spritesJugadores<<Gosu::Image.new(self,"jugador2.png",false)
	    @muros=[]
	    for i in 0..12
			@muros<<[]
	      	for j in 0..12
	        	if(i%2==1 and j%2==1)
	          		@muros[i]<<Gosu::Image.new(self,"muro.png",false)
	        	else
	          		@muros[i]<<Gosu::Image.new(self,"muro2.png",false)
	        	end
	      	end
	    end
		@client=Client.new("192.168.250.245",3000)
		@jugadores={1=>[0,0],2=>[0,0]}
		@mapa=["","","","","","","","","","","","",""]
		@inicioX=0
		@inicioY=0
		@contador=0
	end
	def update
		if Gosu::button_down? Gosu::KbLeft then
			@client.send("KL #{@client.getNumJugador}")
		end
		if Gosu::button_down? Gosu::KbRight  then
			@client.send("KR #{@client.getNumJugador}")
	    end
	    if Gosu::button_down? Gosu::KbUp then
	      	@client.send("KU #{@client.getNumJugador}")
	    end
	    if Gosu::button_down? Gosu::KbDown then
	      	@client.send("KD #{@client.getNumJugador}")
	    end
	end
	def draw
		for i in 1..2
			msg=@client.send("PJ "+i.to_s)
			if(msg!="ERROR")
				@jugadores[@client.getDato(msg,1).to_i]=[@client.getDato(msg,2).to_i,@client.getDato(msg,3).to_i]
				@spritesJugadores[i-1].draw(@jugadores[i][0],@jugadores[i][1],0)
			end
		end
		if(@contador==8)
			@contador=0
		end
		if(@contador==0)
			for i in 0..12
				msg=@client.send("ROW "+i.to_s)
				if(msg!="ERROR")
					l=@client.getDato(msg,2)
					@mapa[i]=l
	        	end
	        end
    	end
    	for i in 0..12
    		l=@mapa[i]
	    	for j in 0..l.length-1
				if(l[j]=="1" or l[j]=="2")
		         	@muros[i][Integer(j)].draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        else
		         	#@muros[i][Integer(j)].draw(-100,50,0)
		        end
			end
		end
    	@contador+=1
        puts("#{Gosu::fps}")
	end
end
game_window=GameWindow.new()
game_window.show()