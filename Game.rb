class Game
	def initialize()
		@players={1=>nil,2=>nil,3=>nil,4=>nil}
		@mapa=[[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0]]
		puts "funciona"
	end
	def setPlayer(num,pl)
		@players[num]=pl
	end
	def update()
		puts "lol"
		@players.each do|key,value|
			dir=value.nextMove()
			x=value.x()
			y=value.y()
			if(dir=="R" and (@mapa[(x+40)/50][y/50]!=0 or@mapa[(x+40)/50][(y+39)/50]!=0))
				value.nextMove=""
			elsif (dir=="L" and (@mapa[(x-10)/50][y/50]!=0 or @mapa[(x-10)/50][(y+39)/50]!=0))
				value.nextMove=""
			elsif(dir=="U" and (@mapa[x/50][(y-10)/50]!=0 or @mapa[(x+39)/50][(y-10)/50]!=0))
				value.nextMove=""
			elsif(dir=="D" and (@mapa[x/50][(y+40)/50]!=0 or @mapa[(x+39)/50][(y+40)/50]!=0))
				value.nextMove=""
			end
			value.update()
		end
	end
	def getRow(row)
		r=""
		for i in @mapa[row]
			r+=i.to_s
		end
		return r
	end
end