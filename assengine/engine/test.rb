require 'test/unit'
class NilClass
	#NilClass#to_c returns a period, which represents nothing.
	#IMPLEMENTATION
	def to_c
		"."
	end
end
class String
	#A char version of a string, would be the first char of the string
	#IMPLEMENTATION
	def to_c
		self[0]
	end
end
#Queries for coordinates.
def coordquery(p)
	return 0, 0
end
#Queries for anything.
def query(p)
	return 'test'
end
#Causes Object#gets to get all data from STDIN.
#IMPLEMENTATION
def gets
	STDIN.gets
end
#Logs something to the game console.
def gamelog(line)
	puts line
end
#Draws the map on the screen.
def drawmap(map,z=0)
end

module ASSEngine
	class Engine
		#Main loop.
		def run
			#Everything past here is basically required.
			#if File.exists? File.join(@datadir, "save.yml")
			#	load
			#	gamelog "Save file loaded"
			#else
			#	gamelog "No save file found."
			#end
			@setup.call if @setup
			5.times do
	#			gamelog "Running gamemode: "+@gamemode.to_s
				@gamemodes[@gamemode].run
			end
		end
	end
	class Gamemode
		#Queries for a command.
		def commandquery
			return 'test'
		end
	end
end
game "ASS ENGINE TEST GAME" do
end
class TestGame < Test::Unit::TestCase
	def test_game
		assert_instance_of(ASSEngine::Engine, $game)
		assert_equal($game.currentgamemode, $gamemode.name)
		assert_instance_of(ASSEngine::Gamemode, $gamemode)
	end
	def test_api
		assert_equal(coordquery(""), [0,0])
	end
end