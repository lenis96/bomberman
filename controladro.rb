require 'socket'
require 'timeout'
class Controlador
	def initialize(ip,port)
		@host=ip
		@port=port
		correr
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
	def correr()
		print(">>")
		r=$stdin.gets.chomp()
		r=send(r)
		puts("#{r}")
	end
end
Controlador.new("192.168.250.245",3000)