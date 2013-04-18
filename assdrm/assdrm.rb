require 'openssl'
#DRM Module for Awesome Sauce Software.
#Feel free to use. Requires a serverside encryptionkey though.
module ASSDRM
	#Encode a file.
	def ASSDRM.encode(file, key)
		contact = ASSDRM::Contact.new(key)
		a = contact.encode(File.read(file))
		contact.close
	end
	def ASSDRM.decode(file, key)
		contact = ASSDRM::Contact.new(key)
		a = contact.decode(File.read(file))
		contact.close
	end
	class Contact
		SERVER = "localhost"
		def initialize(key)
			@key = key
			@pass = key[0..7]
			@socket = TCPSocket.new(SERVER, 2232)
			@socket.puts("KEY #@pass")
		end
		def close
			@socket.close
		end
		def encode(file)
			@result = ""
			@socket.puts("ENCODE")
			if @socket.gets == "true"
				@socket.puts(file)
				@socket.puts("STSURSDSD")
				until (line=@socket.gets) == "STSURSDSD\n"
					@result << line
				end
			else
				fail "Unable to encode."
			end
			@result
		end
		def decode(file)
			@result = ""
			@socket.puts("DECODE")
			if @socket.gets == "true"
				@socket.puts(file)
				@socket.puts("STSURSDSD")
				until (line=@socket.gets) == "STSURSDSD\n"
					@result << line
				end
			else
				fail "Unable to decode."
			end
			@result
		end
	end
end