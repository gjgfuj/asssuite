require ENV['HOME']+'/.ass/assdrm'
print "Key (8 chars long): "
key = gets
if ARGV[0] == "encode"
	ASSDRM.encode(ARGV[1], key)
elsif ARGV[0] == "decode"
	ASSDRM.encode(ARGV[1], key)
end