ec2-run-instances ami-c27692ab
ec2-associate-address 75.101.132.186 -i XXXXXXX
ec2-authorize default -p 22
ec2-authorize default -p 80
ec2-authorize default -p 9000