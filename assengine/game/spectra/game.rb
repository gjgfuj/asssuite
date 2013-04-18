game "Spectra", "0.0.1" do
	$game.switchgamemode :ship
	gamemode :ship do
		setup do
			gnum = query "What is your galaxy number? "
			gnum = gnum.to_i
			$game.world.addmap(:ship, Matrix.new(gnum))
			$game.world.switchmap(:ship)
			difficulty = query "What is your difficulty (0 for easy, 1 for medium, 2 for hard)? "
			if difficulty =~ /0/
				$game.savefile.inventory [:engine, :engine, :solarpanel, :solarpanel, :fuelenergiser, :cockpit]
				$game.savefile.resources :fuel => 100, :energy => 100, :steam => 100
			elsif difficulty =~ /1/
				$game.savefile.inventory [:engine, :solarpanel, :fuelenergiser, :cockpit]
				$game.savefile.resources :fuel => 50, :energy => 50, :steam => 50
			elsif difficulty =~ /2/
				$game.savefile.inventory [:engine, :solarpanel, :cockpit]
				$game.savefile.resources :fuel => 10, :energy => 10, :steam => 10
			else
				fail "Unrecognized difficulty."
			end
		end
		definecallback do
			$game.world.map.each do |tile|
				tile.tick
			end
			$game.savefile.world $game.world
			$game.savefile.gamemode $game.currentgamemode
			$game.save
		end
		command :inventory, "Check inventory." do
			$game.savefile.inventory.each do |i|
				gamelog i.to_s
			end
		end
		command :place, "Place a machine on your ship." do
			gamelog "Your inventory."
			$game.savefile.inventory.each do |i|
				gamelog i.to_s
			end
			machine = query "What machine do you wish to place? "
			machine = machine.chomp.to_sym
			x, y = coordquery "Where do you wish to place the machine? "
			machineinthere = false
			for i in $game.savefile.inventory
				if i == machine
					machineinthere = true
				end
			end
			if machineinthere
				machinesthatmatch = $game.savefile.inventory.select {|x| x == machine}
				othermachines = $game.savefile.inventory.reject {|x| x == machine}
				machinesthatmatch.pop
				$game.savefile.inventory(machinesthatmatch + othermachines)
				$game.world.map.set(x,y,Spectra::Machine.new(machine))
			else
				gamelog "You don't have one of those machines in your inventory?"
			end
		end
		command :use, "Use a machine." do
			x, y = coordquery "Which machine? "
			$game.world.map.get(x,y).use
		end
		command :resources, "Check your resources." do
			gamelog "Fuel: #{$game.savefile.resources[:fuel].to_i} Energy:#{$game.savefile.resources[:energy].to_i} :Steam#{$game.savefile.resources[:steam].to_i}"
		end
	end
end