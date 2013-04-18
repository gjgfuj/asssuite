#This file SHOULD NOT need to be touched.
require 'yaml'
module ASSEngine
	#The general map class
	class Matrix
		def initialize(cols)
			@data = []
			@dims = cols
		end
		#Fetches the data for a specific coordinate.
		def get(x, y)
			if x<@dims && y<@dims
				@data[(@dims*x)+y]
			else
				fail "Unable to retrieve more than dimensions."
			end
		end
		#Sets the data for a specific coordinate.
		def set(x, y, n)
			if x<@dims && y<@dims
				@data[(@dims*x)+y] = n
			else
				fail "Unable to store more than dimensions."
			end
		end
		def dims
			@dims
		end
		def each(&b)
			@data.each(&b)
		end
		#Displays the map on the screen.
		def display(z=0)
			drawmap(self, z)
		end
	end
	#NOT WORKING
	#3 Dimensional Matrix class.
	class Matrix3 < Matrix
		#Gets something in 3 dimensions.
		def get3(x, y, z)
			if x<@dims && y<@dims && z<@dims
				@data[(@dims*x)+(@dims*x*y)+z]
			else
				fail "Unable to retrieve more than dimensions."
			end
		end
		#Sets something in 3 dimensions.
		def set3(x, y, z, n)
			if x<@dims && y<@dims && z<@dims
				@data[(@dims*x)+(@dims*x*y)+z]
			else
				fail "Unable to store more than dimensions."
			end
		end
		#:NODOC:
		def get(x,y)
			get3(x,y,0)
		end
		def set(x,y,n)
			set3(x,y,0,n)
		end
		#:DOC:
		#Displays the matrix on the screen.
		def display
			i = 0
			@dims.times do
				gamelog "Floor "+i.to_s
				super(i)
				i += 1
			end
		end
	end
	#Core Engine Class.
	class Engine
		Version = "0.1.0"
		#Initializes the engine.
		def initialize(name="ASSEngine", version="1.0", initialmap=Matrix.new(20), company="Awesome Sauce Software", year="2013", gamemodesy=:default, &b)
			@name = name
			@version = version
			@company = company
			@year = year
			@gamemodes = {}
			@gamemode = gamemodesy
			$gamemode = gamemode(gamemodesy) {}
			@world = World.new(initialmap)
			@save = Save.new
			@datadir = File.join(ENV['HOME'],".ass", $gamename)
			unless File.exists? File.join(ENV['HOME'],".ass")
				Dir.mkdir File.join(ENV['HOME'],".ass")
			end
			unless File.exists? @datadir
				Dir.mkdir @datadir
			end
			@b = b
		end
		#Runs the block associated with Engine#new
		def runblock
			@b.call
		end
		#Returns the current gamemode.
		def currentgamemode
			@gamemode
		end
		#Makes a new gamemode.
		def gamemode(name, &b)
			@gamemodes[name] = Gamemode.new(name, &b)
		end
		#Switches the gamemode of the engine to name.
		def switchgamemode(name)
			#gamelog "Switching gamemode to #{name}"
			@gamemode = name
		end
		attr_reader :gamemodes
		#Loads the game.
		def load
			@save = YAML.load(File.new(File.join(@datadir,"save.yml")))
		end
		#Accesses the savefile.
		def savefile
			@save
		end
		#Loads the world from the savefile.
		def loadworld
			@world = @save.world
		end
		#Saves the game.
		def save
			#File.delete(File.join(@datadir, "save.yml")) if File.exists? File.join(@datadir, "save.yml")
			YAML.dump(@save, f = File.new(File.join(@datadir,"save.yml"), "w"))
			f.close
		end
		attr_reader :world
		#Exits the game.
		def exit
			@exit = true
		end
		#Sets a setup block.
		def setup(&b)
			@setup = b
		end
	end
	#Save file.
	class Save
		def initialize
			@data = {}
		end
		#Sets and gets data from the save file.
		def method_missing(name, *args)
			@data[name] = args[0] if args.length > 0
			@data[name]
		end
		#Does the data exist?
		def exists? name
			unless @data[name].nil?
				true
			else
				false
			end
		end
	end
	#Gamemode object.
	class Gamemode
		def initialize(name, &b)
			@name = name
			@commands = {}
			command :help, "This message" do
				gamelog "Help message."
				@commands.keys.each do |cmd|
					if cmd == @commands[cmd].name
						gamelog "#{cmd.to_s}: #{@commands[cmd].help}"
					else
						gamelog "#{cmd.to_s}: Alias for #{@commands[cmd].name}"
					end
				end
			end
			command :exit, "Exit the program" do
				$game.exit
			end
			@callback = Proc.new { }
			@setup = Proc.new { }
			@b = b
		end
		attr_reader :name
		#Runs the block associated with Gamemode.new
		def runblock
			@b.call
		end
		attr_reader :commands
		#Sets a command for the gamemode.
		def command(name, help, &b)
			@commands[name] = Command.new(name, help, &b)
		end
		#Defines a callback to run each turn.
		def definecallback(&b)
			@callback = b
		end
		#Defines a callback to run when the gamemode initializes.
		def setupgamemode(&b)
			@setup = b
		end
		#Displays the current map.
		def worlddisplay
			$game.world.map.display
		end
		#Aliases a command to another.
		def commandalias(command, a)
			@commands[a] = @commands[command]
		end
		#Runs the gamemode.
		def run
			unless @setupran
				@setupran = true
				@setup.call if @setup
			end
			@callback.call if @callback
			worlddisplay
			commandquery
		end
	end
	#A command class.
	class Command
		def initialize(name, help, &b)
			@name = name
			@help = help
			@b = b
		end
		#Called when the command is entered.
		def run
			@b.call
		end
		attr_reader :name, :help
	end
	#A world class to store all maps.
	class World
		def initialize(map)
			@map = :init
			@maps = {:init => map, :blank => Matrix.new(0)}
		end
		#Adds a map to the world.
		def addmap(sym, map)
			@maps[sym] = map
		end
		#Switches the current map to a symbol.
		def switchmap(sym)
			@map = sym
		end
		#Gets the current map.
		def map
			@maps[@map]
		end
		#Fetches a map sym.
		def [](sym)
			@maps[sym]
		end
	end
end
include ASSEngine
#Command to make the engine.
def game(*args, &b)
	$game = ASSEngine::Engine.new(*args, &b)
	$game.runblock
	$game
end
#Command to make a command.
def command(*args, &b)
	$gamemode.command(*args, &b)
end
#Command to define a callback.
def definecallback(&b)
	$gamemode.definecallback(&b)
end
#Command to setup a gamemode.
def gamemodesetup(&b)
	$gamemode.setupgamemode &b
end
#Command to make a new gamemode.
def gamemode(*args, &b)
	$gamemode = $game.gamemode(*args, &b)
	$gamemode.runblock
	$gamemode = $game.gamemodes[:default]
end
#Command to alias a command.
def commandalias(command, a)
	$gamemode.commandalias(command, a)
end
#Command to add a game setup function.
def setup(&b)
	$game.setup(&b)
end
def force_engine(engine)
	$enginename = engine
end
#Stub methods for engines.
#Actual content is in an engine file.

#Queries for coordinates.
def coordquery(p)
end
#Queries for anything.
def query(p)
end
#Logs something to the game console.
def gamelog(line)
end
#Draws the map on the screen.
def drawmap(map,z=0)
end

module ASSEngine
	class Engine
		#Main loop.
		def run
		end
	end
	class Gamemode
		#Queries for a command.
		def commandquery
		end
	end
end