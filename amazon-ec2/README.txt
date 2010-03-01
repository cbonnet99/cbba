(set up tools for EC2, see: http://docs.amazonwebservices.com/AWSEC2/2007-08-29/GettingStartedGuide/setting-up-your-tools.html
and next step:

* Start the AMI: https://elasticserver.com/ec2/images/5172-1582-7105
* Connect to the IP address on Elasticfox
* Grant yourself SSH access to the virtual server (in Security groups)
* Connect to the server via SSH, run: ssh-keygen -t rsa and copy /home/cftuser/.ssh/id_rsa.pub on to GitHub
* From the server, test the connection to GitHub (and accept the GitHub fingerprint)
* cap deploy:init

Then subsequently:
cap deploy