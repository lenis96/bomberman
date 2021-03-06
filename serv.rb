#!/usr/bin/env ruby -w
require "socket"
require_relative "Player"
require_relative "Game"
class Server
  def initialize( ip,port )
    @server = TCPServer.open( ip, port )
    puts "Servidor corriendo en #{ip} en el puerto #{port}"
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    @jugadores={1=>Player.new(1,0,0),2=>Player.new(2,550,0),3=>Player.new(3,0,500),4=>Player.new(4,500,500)}
    @numConnections=0
    @game=nil
    run

  end

  def run
    loop {
      Thread.start(@server.accept) do | client |
        
        msg = client.gets.chomp
        if(msg=="ENTER PLAYER") then
        #if(msg=="ENTER PLAYER")
          @numConnections+=1
        #@connections[:clients].each do |other_name, other_client|
          #if nick_name == other_name || client == other_client
           # client.puts "This username already exist"
            #Thread.kill self
          #end
        #end
        #puts "#{nick_name} #{client}"
          @connections[:clients][@numConnections] = client
          client.puts "PLAYER #{@numConnections}"
          puts("PLAYER #{@numConnections}")
          if(@numConnections==1) then
            jugar()
          end
            
          escuchar(@numConnections,client)
        end
        #listen_user_messages( nick_name, client )
        msg=msg.split
        if (msg[0]=="RECONNECT")
          @connections[:clients][Integer(msg[1])] = client
          client.puts "RECONNECT #{msg[1]}"
          puts("RECONNECT #{msg[1]}")
          escuchar(Integer(msg[1]),client)
        end
          
        #end
      end
    }.join
  end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      @connections[:clients].each do |other_name, other_client|
        #unless other_name == username
        other_client.puts "#{username.to_s}: #{msg}"
        #end
      end
    }
  end
  def escuchar(player,client)
    loop{
    msg=client.gets.chomp
    #puts"#{msg}"
    if msg=="KL"
      #puts ("#{msg} #{player}")
      @jugadores[player].nextMove="L"
      client.puts "KL"
    elsif msg=="KR"
      @jugadores[player].nextMove="R"
      client.puts "KR"
    elsif msg=="KU"
      @jugadores[player].nextMove="U"
      client.puts("KU")
    elsif msg=="KD"
      @jugadores[player].nextMove="D"
      client.puts("KD")
    end 
    msg=msg.split
    if(msg[0]=="PJ")
      client.puts("#{msg[0]} #{msg[1]} #{@jugadores[Integer(msg[1])].x} #{@jugadores[Integer(msg[1])].y}")
    elsif(msg[0]=="ROW")
      client.puts("#{msg[0]} #{msg[1]} #{@game.getRow(Integer(msg[1]))}")
    end
      
  }
  end
  def jugar()
    @game=Game.new()
    1.upto(4) do |i|
      @game.setPlayer(i,@jugadores[i])
    end
    Thread.new do
      while true do
        @game.update()
        sleep 0.05
      end
    end
  end
end



Server.new( Socket.ip_address_list[1].inspect_sockaddr,3000)