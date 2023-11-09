#!/bin/bash

#declare variables
prod_ip=$(terraform output -raw prod_ip)
build_ip=$(terraform output -raw build_ip)

#keyscan ip
ssh-keyscan $prod_ip >> ~/.ssh/known_hosts
ssh-keyscan $build_ip >> ~/.ssh/known_hosts

#insert hosts in /etc/ansible/hosts
echo "[Prod]" >> /etc/ansible/hosts
echo "$prod_ip ansible_user=ubuntu ansible_port=22 ansible_ssh_private_key_file=/home/dmitry/cer/Cert/prod" >> /etc/ansible/hosts
echo "[Build]" >> /etc/ansible/hosts
echo "$build_ip ansible_user=ubuntu ansible_port=22 ansible_ssh_private_key_file=/home/dmitry/cer/Cert/build" >> /etc/ansible/hosts
