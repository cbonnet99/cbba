ec2-run-instances ami-c27692ab -k cyrille-keypair -g bam_security
ec2-associate-address 75.101.132.186 -i XXXXXXX

To access the new server:

ssh -i ~/.ec2/id_rsa-cyrille-keypair cftuser@174.129.6.162


Playing with deprec:

(any Ubuntu AMI will do)
ec2-run-instances ami-01729468 -k cyrille-keypair -g bam_security
ec2-associate-address 75.101.132.186 -i XXXXXX

#### AFTER running initial setup below, you don't need to login as root: you can login as cyrille
###(delete any previous known hosts associated with 174.129.6.162 in ~/.ssh/known_hosts)
###ssh -i ~/.ec2/id_rsa-cyrille-keypair root@174.129.6.162

Add user cyrille, SSH keys and so on: http://deprec.failmode.com/documentation/initial-server-setup/

Then you can log on to the server:

ssh cyrille@174.129.6.162

In project:

depify . (run only once)
cap deprec:rails:install_stack
cap deploy:setup
cap deploy (if you get Host key verification failed, you need to add the host key on GitHub)