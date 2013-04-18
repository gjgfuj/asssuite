game "ASSEngine Mapper Tool", "0.0.1" do
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
	command :newmap, "Create a new map." do
		name = query("Name of map? ").to_sym
		size = query("Size of map? ").to_i
		$game.world.addmap(name, Matrix.new(size))
		$game.world.switchmap(name)
	end
	command :switchmap, "Switch to an existing map." do
		name = query("Name of map? ").to_sym
		$game.world.switchmap(name)
	end
	commandalias :tile, :place
	commandalias :t, :tile
	commandalias :p, :place
	commandalias :nm, :newmap
	commandalias :map, :switchmap
	commandalias :m, :map
	commandalias :x, :exit
end