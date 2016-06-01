class Game
	def initialize()
		@players={1=>nil,2=>nil,3=>nil,4=>nil}
		@mapa=[[0,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,1,0,1,0,1,2,1,0,1,0,1,0],
		[0,0,0,0,0,0,2,0,0,0,0,0,0],
		[0,1,0,1,0,1,2,1,0,1,0,1,2],
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
		@bombas=[]
		@explosiones=[]
	end
	def setPlayer(num,pl)
		@players[num]=pl
	end
	def update()
		puts("#{@players[1].vida} #{@players[2].vida} #{@players[3].vida} #{@players[4].vida} ")
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
		@bombas.delete_if do|value|
			if(value[3]==0)
				true
			else
				value[3]-=1
				if(value[3]==0)
					@mapa[value[1]][value[2]]=4
					@explosiones<<[value[1],value[2],20]
					i=1
					while(i<value[4] and value[1]+i<13 and @mapa[value[1]+i][value[2]]!=1)
						@mapa[value[1]+i][value[2]]=4
						@explosiones<<[value[1]+i,value[2],20]
						i+=1
					end
					i=1
					while(i<value[4] and value[1]-i>-1 and @mapa[value[1]-i][value[2]]!=1)
						@mapa[value[1]-i][value[2]]=4
						@explosiones<<[value[1]-i,value[2],20]
						i+=1
					end
					i=1
					while(i<value[4] and value[2]+i<13 and @mapa[value[1]][value[2]+i]!=1)
						@mapa[value[1]][value[2]+i]=4
						@explosiones<<[value[1],value[2]+i,20]
						i+=1
					end
					i=1
					while(i<value[4] and value[2]-i>-1 and @mapa[value[1]][value[2]-i]!=1)
						@mapa[value[1]][value[2]-i]=4
						@explosiones<<[value[1],value[2]-i,20]
						i+=1
					end

					@players[value[0]].addBomba()
					quitarVida()

					#agrgar explosion
				end
				false
			end
			#completar logica para el control de bombas
		end
		@explosiones.delete_if do|v|
			if(v[2]==0)
				true
				@mapa[v[0]][v[1]]=0
			else
				v[2]-=1
				false
			end
		end
		timeLess()
		
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
	def addBomba(jugador,r,c,t,p)
		@mapa[r][c]=3
		@bombas<<[jugador,r,c,t,p]
	end
	def quitarVida()
		#puts("lol")
		@players.each do|key,value|
			x=value.x()
			y=value.y()
			dx=x+39
			dy=y+39
			puts("lol-1")
			if(@mapa[y/50][x/50]==4 or @mapa[dy/50][x/50]==4 or @mapa[y/50][dx/50]==4 or @mapa[dy/50][dx/50]==4)
				puts("lal")
				value.quitarVida()
			end
			puts("lol")
		end
		puts "paso aqui"
	end
end