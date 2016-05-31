class Game
	def initialize()
		@players={1=>nil,2=>nil,3=>nil,4=>nil}
		@mapa=[[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,2],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,0,1,0,1,0,1,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,0]]
		@time=120*20
		@played=true
	end
	def setPlayer(num,pl)
		@players[num]=pl
	end
	def update()
		#puts "lol"
		@players.each do|key,value|
			dir=value.nextMove()
			x=value.x()
			y=value.y()
			if(dir=="R" and (@mapa[y/50][(x+40)/50]!=0 or @mapa[(y+39)/50][(x+40)/50]!=0))
				value.nextMove=""
			elsif (dir=="L" and (@mapa[y/50][(x-10)/50]!=0 or @mapa[(y+39)/50][(x-10)/50]!=0))
				value.nextMove=""
			elsif(dir=="U" and (@mapa[(y-10)/50][x/50]!=0 or @mapa[(y-10)/50][(x+39)/50]!=0))
				value.nextMove=""
			elsif(dir=="D" and (y<610 and (@mapa[(y+40)/50][x/50]!=0 or @mapa[(y+40)/50][(x+39)/50]!=0)))
				value.nextMove=""
			end
			value.update()
		end
		timeLess()
		puts("#{time}")
	end
	def getRow(row)
		r=""
		for i in @mapa[row]
			r+=i.to_s
		end
		return r
	end
	def getMap()
		r=""
		for i in 0..12
			for j in @mapa[i]
				r+=i.to_s
			end
		end
		return r
	end
	def timeLess()
		if(@played)
			@time-=1
		end
		if(@time==0)
			@played=false
		end
	end
	def time()
		r=""
		r+=(@time/1200).to_s
		r+=":"
		r+=((@time/20)%60).to_s
		return r
	end
end