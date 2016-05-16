class Game
	def initialize()
		@players={1=>nil,2=>nil,3=>nil,4=>nil}
		puts "funciona"
	end
	def setPlayer(num,pl)
		@players[num]=pl
	end
	def update()
		puts "lol"
		@players.each do|key,value|
			value.update()
		end
	end
end