#!bin/bash

#declare variables
prod_ip=$(terraform output -raw prod_ip)
build_ip=$(terraform output -raw build_ip)

#install python package in build/prod stage 
ssh -i /home/dmitry/cer/Cert/prod ubuntu@$prod_ip 'sudo apt install python -y;'
ssh -i /home/dmitry/cer/Cert/build ubuntu@$build_ip 'sudo apt install python -y;'
