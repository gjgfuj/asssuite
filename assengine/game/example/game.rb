#This game is a showcase for the ASSEngine.

#To create a game, use the game method.
game "ASS Engine Test Game", "0.0.8" do
	#To create a command, you use the command method.
	command :die, "You Die" do
		puts "You Die."
		$game.exit
	end
	#The gamemode defaults to :default.
	command :place, "Place object on the world." do
		#You can use Object#query to ask the player something.
		obj = query "Which object? "
		#You can use coordquery to ask the player some coords on the grid.
		x, y = coordquery "Where to place the object? "
		if x && y
			#As you can see here, this is how you set an object.
			$game.world.map.set(x.to_i, y.to_i, obj)
		end
	end
	command :test, "Switch gamemode to test." do
		#To switch a gamemode, you use this command.
		$game.switchgamemode :test
		#To add a map, you use this command.
		$game.world.addmap(:test, Matrix.new(5))
		#To switch to that map, you use this command.
		$game.world.switchmap :test
	end
	#To alias a command, use this command.
	commandalias :place, :p
	commandalias :die, :d
	commandalias :help, :h
	commandalias :die, :exit
	#To make a new gamemode, use this command.
	gamemode :test do
		command :place, "Place object on the world." do
			obj = query "Which object? "
			x, y = coordquery "Where to place the object? "
			if x && y
				$game.world.map.set(x.to_i, y.to_i, obj)
			end
		end
		commandalias :place, :p
		commandalias :help, :h
		definecallback do
			$game.savefile.world $game.world
			$game.savefile.gamemode $game.currentgamemode
			$game.save
		end
	end
	#To add a setup file to do something when the game starts, do this.
	setup do
		if $game.savefile.exists?(:world) && $game.savefile.exists?(:gamemode)
			#To load the world, use this.
			$game.loadworld
			$game.switchgamemode $game.savefile.gamemode
		else
			print "Size of map? "
			$game.world.addmap(:init, Matrix.new(gets.to_i))
			$game.world.map.set(5, 3, "T")
			$game.world.map.set(5, 4, "E")
			$game.world.map.set(5, 5, "S")
			$game.world.map.set(5, 6, "T")
			$game.save
		end
	end
	#Define a GAMEMODE SPECIFIC callback for the world.
	definecallback do
		$game.savefile.world $game.world
		$game.savefile.gamemode $game.currentgamemode
		$game.save
	end
end