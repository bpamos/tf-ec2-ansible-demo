# tf-ec2-ansible-demo
Simple demo to run ansible in an EC2


local-exec is where you execute commands from your local machine.
This means you need to have ansible installed on your local machine and the path needs to be updated.

Steps:

create virtual environment
* python3 -m venv ./venv
Check if you have pip
* python3 -m pip -V
Install ansible
* python3 -m pip install --user ansible
If it tells you the path needs to be updated, update it
* echo $PATH
* export PATH=$PATH:/path/to/directory

Run terraform init, plan, apply