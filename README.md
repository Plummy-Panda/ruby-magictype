# ruby-magictype
This is for Network Security Project 1

First, you have to modify the ```config.rb``` file


### Stage 1 Play with magictype ###
run ``` ruby auto_typing.rb ```

It will start to play with the magictype automatically.
After it getting more than 3000 points, it will suicide to get the flag 1.

### Stage 2 Jump to the magic function! ###

run ``` ruby leaking.rb ```

When the server asks us which speed we want to play in (the server uses the dangerous `scanf`), send a string which is more than 20 character to make it buffer overflow.

Since we want to jump to the `magic()`, and its address is at `0x080488cd`, we set the `return_addr` as `"\xcd\x88\x04\x08"` (little endian), then send the `buf` to the server.
(Because there's 44 bytes between s[0] and return address, so we need to fill `'a'` or other character to replace the 44-bytes space. Details are in the comment of the `leaking.rb`)

The server will leak and jump to `magic()` function,
and shows the flag 2.

p.s you can also set the `return_addr` as `"\xed\x88\x04\x08"`, where the `congrats()` function locate, to get flag 1.

### Stage 3 Get the shell ###

Like stage 2, we also do leaking when the server asks us which speed we want to play in.

To get the flag 3, we need to get the shell control, by calling `system("sh")` and then send `cat /home/magictype/flag3` command.

So, first we should jump to the `system()` and its address is `0x080486f0`. We set the `return_addr` as `"\xf0\x86\x04\x08"` (little endian).

Next, we also have to put `"sh"` as the argument of `system()`. The `"sh"` is stores at the `.data` section (`char sh[3]` is a global string value) and its address is `0x0804b0a0`.
(Also, there's 4 bytes between return address and argument address, so we need to fill `'aaaa'` to replace the space. Details are in the comment of the `get_shell.rb`)

After the `buf` is prepared, we send it to server to get a shell.

Finally, we can just send the `command`, which has been set as `"cat /home/magictype/flag3\n"`, to let the server show  flag 3.

p.s you can also use this script to get flag 1 and flag 2, by simply changing the `command` variable.
