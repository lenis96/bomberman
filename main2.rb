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
		Timeout::timeout(0.05) do
			begin
				@socket=TCPSocket.new(@host,@port)
				@socket.puts(messege)
				begin#ojo
					while line=@socket.gets
						r+= line
					end
				rescue Exception => e#ojo
					return "ERROR"
				end#ojo
				

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
		super(800,700,false)
		#@sprite1=Gosu::Image.new(self,"jugador1.png",false)
    	#@sprite2=Gosu::Image.new(self,"jugador2.png",false)
    	@spritesJugadores=[Gosu::Image.new(self,"jugador1.png",false)]
    	@spritesJugadores<<Gosu::Image.new(self,"jugador2.png",false)
    	@spritesJugadores<<Gosu::Image.new(self,"jugador3.png",false)
    	@spritesJugadores<<Gosu::Image.new(self,"jugador4.png",false)
    	@estadoFont=Gosu::Font.new(20)
    	@timeFont=Gosu::Font.new(20)
    	@estado="Conectando"
    	@time="2:00"
    	@muro1=Gosu::Image.new(self,"muro.png",false)
    	@muro2=Gosu::Image.new(self,"muro2.png",false)
    	@bomba=Gosu::Image.new(self,"bomba.png",false)
    	@explosion=Gosu::Image.new(self,"explosion.png",false)
=begin
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
=end
		@client=Client.new("172.17.3.223",3000)
		@jugadores={1=>[0,0],2=>[0,0],3=>[0,0],4=>[0,0]}
		@mapa=["","","","","","","","","","","","",""]
		@inicioX=0
		@inicioY=0
		@contador=0
		@pressedSpaceBar=false
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
	    if Gosu::button_down? Gosu::KbSpace and not @pressedSpaceBar
	    	@client.send("KS #{@client.getNumJugador}")
	    	@pressedSpaceBar=true
	    	puts "BOOOOOOOOM"
	    end
	   	    if not Gosu::button_down? Gosu::KbSpace
	    	#@client.send("KS #{@client.getNumJugador}")
	    	@pressedSpaceBar=false
	    end
	end
	def draw
		msg=@client.send("PJS")
		if(msg!="ERROR")
			msg=msg.split
			for i in 1..4
				@jugadores[i]=[msg[(i*2)-1].to_i,msg[i*2].to_i]
			end
		end
		for i in 1..4
			#@jugadores[@client.getDato(msg,1).to_i]=[@client.getDato(msg,2).to_i,@client.getDato(msg,3).to_i]
			@spritesJugadores[i-1].draw(@jugadores[i][0],@jugadores[i][1],0)	
		end
		if(@contador==8)
			@contador=0
		end
		if(@contador==0)

			msg=@client.send("MAP")
			if(msg!="ERROR")
				msg=msg.split
				for i in 0..12
					@mapa[i]=msg[i+1]
				end				
        	end
        	msg=@client.send("ESTADO")
        	if(msg!="ERROR")
        		msg=msg.split(/\n/)
        		@estado=msg[0]
        		@time=msg[1]
        	else
        		@estado="INTENTANDO RECONECTAR"
        	end
    	end
    	for i in 0..12
    		l=@mapa[i]
	    	for j in 0..l.length-1
				if(l[j]=="1")
		         	@muro1.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j]=="2")
		        	@muro2.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j]=="3")
		        	@bomba.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        elsif(l[j]=="4")
		        	@explosion.draw(@inicioX+(j*50),@inicioY+(i*50),0)
		        else
		         	#@muros[i][Integer(j)].draw(-100,50,0)
		        end
			end
		end
    	@estadoFont.draw(@estado,10,660,0,1.0,1.0,0xff_ffffff)
    	@timeFont.draw(@time,700,10,0,1.0,1.0,0xff_ffffff)
        puts("#{Gosu::fps}")
    	@contador+=1
	end
end
game_window=GameWindow.new()
game_window.show()