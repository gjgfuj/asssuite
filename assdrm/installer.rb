require 'fileutils'
#ONLY TO FIND THE BIN DIR.
require 'rubygems'
puts 'Installing.'
FileUtils.mkdir(File.join(ENV['HOME'],".ass"), :verbose => true) unless File.exists? File.join(ENV['HOME'],".ass")
FileUtils.cp_r(Dir.glob("*"), File.join(ENV['HOME'],".ass"), :verbose => true)
FileUtils.install(Dir.glob("bin/*"), Gem.bindir, :verbose => true)
puts "Installed"