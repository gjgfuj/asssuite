#Console based interface for the ASSEngine.
#This file has been commented to help you write your own interface.


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
	print p
	if gets =~ /(\d+) (\d+)/
		return $1.to_i, $2.to_i
	else
		gamelog "Invalid coordinates."
	end
end
#Queries for anything.
def query(p)
	print p
	gets.chomp
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
	i = 0
	print "   "
	map.dims.times {print i.to_s + " " + (" " if i<10).to_s; i+=1}
	print "\n"
	(0...(map.dims)).each do |x|
		print x, " "
		print " " if x < 10
		(0...(map.dims)).each do |y|
			unless z > 0
				print map.get(x,y).to_c + "  "
			else
				print map.get3(x,y,z).to_c + "  "
			end
		end
		print "\n"
	end
end

module ASSEngine
	class Engine
		#Main loop.
		def run
			gamelog "#@name V#@version"
			gamelog "Copyright #@company #@year"
			gamelog "Running ASSEngine V#{Version}"
			gamelog "And console interface V0.1.0"
			gamelog "Copyright Awesome Sauce Software 2013" unless @company =~ /Awesome Sauce Software/
			gamelog ""
			gamelog "Loading Save file."
			#Everything past here is basically required.
			if File.exists? File.join(@datadir, "save.yml")
				load
				gamelog "Save file loaded"
			else
				gamelog "No save file found."
			end
			@setup.call if @setup
			until @exit
	#			gamelog "Running gamemode: "+@gamemode.to_s
				@gamemodes[@gamemode].run
			end
		end
	end
	class Gamemode
		#Queries for a command.
		def commandquery
			print "Enter Command ('help' for help)"
			line = gets.chomp
			#gamelog "Command: " + line
			begin
				@commands[line.to_sym].run
			rescue
				gamelog "Invalid/non-existant command: #{line}"
			end
		end
	end
end