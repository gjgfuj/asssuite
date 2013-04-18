require 'curses'
include Curses
def gamelog(message)
  width = message.length + 6
  win = Window.new(5, width,
               (lines - 5) / 2, (cols - width) / 2)
  win.box("|", "-")
  win.setpos(2, 3)
  win.addstr(message)
  win.refresh
  win.getch
  win.close
end
def coordquery(m)
end
def query(m)
end
def drawmap(map, z=0)
end
module ASSEngine
	class Engine
		def run
			init_screen
			gamelog "#@name V#@version"
			gamelog "Copyright #@company #@year"
			gamelog "Running ASSEngine V#{Version}"
			gamelog "And Curses interface V0.0.1"
			gamelog "Copyright Awesome Sauce Software 2013" unless @company =~ /Awesome Sauce Software/
			gamelog ""
			gamelog "Loading Save file."
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
		ensure
			close_screen
		end
	end
	class Gamemode
		def commandquery
		end
	end
end