#/bin/sh

#Add user cyrille, SSH keys and so on (http://deprec.failmode.com/documentation/initial-server-setup/):

# On my current AMI, I had to:
# 1. change PasswordAuthentication to yes in /etc/ssh/sshd_config
# 2. /etc/init.d/ssh reload

cd ~/sys
export HOSTS=174.129.33.107
# cap deprec:users:passwd USER=root
cap deprec:users:add USER=root #then type user name: cyrille and say that he should be admin: yes
cap deprec:ssh:setup_keys
# cap deprec:ssh:config_gen (only if the public key for cyrille is NOT in ~/sys/config/ssh/authorized_keys/cyrille)
cap deprec:ssh:config
unset HOSTS

#Now you can log on to the server:
#ssh cyrille@174.129.33.107

cap deprec:rails:install_stack
cap deprec:db:install
cap deploy:setup
cap deploy


#your Host key verification will fail! (you need to add the host key on GitHub)
#on the server (AS ROOT): ssh-keygen -t rsa
#then: cat ~/.ssh/id_rsa.pub
#on GitHub, go to Account settings and the key to the SSH public keys sections
# [see GitHub instructions here: http://github.com/guides/providing-your-ssh-key#linux]
# You might have to wait a few minutes for GitHub to load the key. Also the GitHub

#To debug, do it manually, for instance (on the server):
#sudo git clone -q git@github.com:cbonnet99/cbba.git /var/rails/be_amazing/shared/cached-copy

#the annoying libxml-ruby gem:
# sudo apt-get install libxml2-dev
# sudo gem install libxml-ruby

#Add the db user to /etc/postgresql/8.3/main/pg_hba.conf:
# local   be_amazing_staging      bam_user              password
# And restart postgres:
# sudo su - postgres
# /etc/init.d/postgresql-8.3 reload