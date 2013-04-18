class Symbol
	def to_c
		to_s.to_c
	end
end
class NilClass
	def tick
	end
end
module Spectra
	class Machine
		def Machine.new(sym)
			case sym
				when :engine then Engine.new("Y")
				when :solarpanel then SolarPanel.new("#")
				when :fuelenergiser then FuelEnergiser.new("U")
				when :cockpit then CockPit.new("%")
			end
		end
		def initialize(sym)
			@resources = {:fuel => 0, :energy => 0, :steam => 0}
			@sym = sym
		end
		def tick
		end
		def use
			gamelog "Fuel: #{@resources[:fuel]} Energy: #{@resources[:energy]} Steam: #{@resources[:steam]}"
		end
		def to_c
			@sym
		end
	end
	class Engine < Machine
		def tick
			if @resources[:fuel] >= 5
				@resources[:fuel] -= 5
				@resources[:steam] += 5
				@resources[:energy] += 5
			end
		end
	end
	class SolarPanel < Machine
		def tick
			@resources[:energy] += 1
		end
	end
	class FuelEnergiser < Machine
		def tick
			if @resources[:energy] >= 5
				@resources[:energy] -= 5
				@resources[:fuel] += 1
			end
		end
	end
	class CockPit < Machine
		def use
			if @resources[:steam] >= 100
				@resources[:steam] -= 100
				$game.switchgamemode(:space)
			else
				gamelog "You need 100 steam to blast off."
			end
		end
	end
end