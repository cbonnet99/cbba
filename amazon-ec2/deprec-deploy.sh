#/bin/sh

ruby ./init_server.rb

sed '/^174\.129\.6\.162,/d' ~/.ssh/known_hosts #delete any previous known hosts associated with 174.129.6.162 in ~/.ssh/known_hosts
ssh -i ~/.ec2/id_rsa-cyrille-keypair root@174.129.6.162
#passwd (change root passwd)

