ec2-run-instances ami-c27692ab -k cyrille-keypair -g bam_security
ec2-associate-address 75.101.132.186 -i XXXXXXX

To access the new server:

ssh -i ~/.ec2/id_rsa-cyrille-keypair cftuser@174.129.6.162

