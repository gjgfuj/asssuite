module ASSMap
	class Tool
		def initialize
			game "ASSEngine Mapping Tool.", "0.0.1" do
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
					name = query "Map name? "
					size = query "Size of map? "
					$game.world.addmap(name.to_sym, Matrix.new(size.to_i))
					$game.world.switchmap(name.to_sym)
				end
			end.run
		end
	end
end