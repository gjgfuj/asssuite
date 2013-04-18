#!/usr/bin/env ruby
#Console script to launch the engine.
require 'optparse'
$enginename = "console"
$searchpaths = []
optparse = OptionParser.new do |opts|
	opts.banner = "Usage: ass.rb [-g|--game GAME] [-e|--engine ENGINE]"
	opts.on("-g", "--game GAME", "Specify a game to run") do |game|
		$gamename = game
	end
	opts.on("-e", "--engine ENGINE", "Specify an engine to use to run the game. (defaults to console)") do |engine|
		$enginename = engine
	end
	opts.on("-r", "--reset GAME", "Reset a game's savefile.") do |game|
		File.delete(File.join(ENV['HOME'], ".ass", game, "save.yml")) rescue puts "No savefile for #{game}."
	end
	opts.on("-s", "--searchpath PATH", "Add a searchpath to the path list") do |path|
		$:.unshift(path)
	end
	opts.on("-h", "--help", "Show this message then exit") do
		puts opts
		exit
	end
end.parse!
begin
	unless $gamename
		puts "Please choose a game."
		for i in Dir.glob(File.join(ENV['home'], ".ass", "game", "*"))
			puts File.basename(i)
		end
		#puts "Please ignore all the stuff up to '.ass/game\'"
		print "Choice? "
		$gamename = gets.chomp
	end
	$:.unshift(".")
	$:.unshift($gamename)
	$:.unshift(File.join(ENV['HOME'], ".ass", "game", $gamename))
	$:.unshift(File.join(ENV['HOME'], ".ass"))
	require 'assenginecore'
	if File.exists?(File.join(ENV['HOME'], ".ass", "game", $gamename, 'game.rb'))
		require 'game'
		Dir.glob(File.join(File.join(ENV['HOME'], ".ass", "game", $gamename, "*"))).each do |f|
			require f
		end
		require File.join("engine", $enginename.to_s)
		$game.run
	else
		fail "Invalid/nonexisting Game directory: #$gamename"
	end
rescue RuntimeError
	$gamename = nil
	retry
end