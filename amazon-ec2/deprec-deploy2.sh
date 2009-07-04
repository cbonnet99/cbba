#/bin/sh

#Add user cyrille, SSH keys and so on (http://deprec.failmode.com/documentation/initial-server-setup/):

cd ~/sys
export HOSTS=174.129.6.162
# cap deprec:users:passwd USER=root
cap deprec:users:add USER=root #then type user name: cyrille and say that he should be admin: yes
cap deprec:ssh:setup_keys
# cap deprec:ssh:config_gen (only if the public key for cyrille is NOT in ~/sys/config/ssh/authorized_keys/cyrille)
cap deprec:ssh:config
unset HOSTS

#Now you can log on to the server:
#ssh cyrille@174.129.6.162

cap deprec:rails:install_stack
cap deprec:db:install
cap deploy:setup
cap deploy
#(if your get Host key verification failed, you need to add the host key on GitHub
# [see GitHub instructions here: http://github.com/guides/providing-your-ssh-key#linux]
#and the public key of GitHub in the known_hosts of your server [simply do: ])