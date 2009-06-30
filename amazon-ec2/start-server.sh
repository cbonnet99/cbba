ec2-run-instances ami-c27692ab -k cyrille-keypair -g bam_security
ec2-associate-address 75.101.132.186 -i XXXXXXX

To access the new server:

ssh -i ~/.ec2/id_rsa-cyrille-keypair cftuser@174.129.6.162


Playing with deprec:

(any Ubuntu AMI will do)
ec2-run-instances ami-01729468 -k cyrille-keypair -g bam_security
ec2-associate-address 174.129.6.162 -i XXXXXX

(delete any previous known hosts associated with 174.129.6.162 in ~/.ssh/known_hosts)
ssh -i ~/.ec2/id_rsa-cyrille-keypair root@174.129.6.162
passwd (change root passwd)

Add user cyrille, SSH keys and so on (http://deprec.failmode.com/documentation/initial-server-setup/):

cd ~/sys
export HOSTS=174.129.6.162
# cap deprec:users:passwd USER=root
cap deprec:users:add USER=root
cap deprec:ssh:setup_keys
cap deprec:ssh:config_gen
cap deprec:ssh:config
unset HOSTS

Then you can log on to the server:

ssh cyrille@174.129.6.162

(in the instance I chose, Apache2 is not installed: sudo apt-get install apache2)

In project:

depify . (run only once)
cap deprec:rails:install_stack
cap deprec:db:install
cap deploy:setup
cap deploy
(if you get Host key verification failed, you need to add the host key on GitHub
 [see GitHub instructions here: http://github.com/guides/providing-your-ssh-key#linux]
and the public key of GitHub in the known_hosts of your server [simply do: ])