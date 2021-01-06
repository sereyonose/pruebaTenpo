#!/bin/sh
sudo apt-get update &&
sudo apt install software-properties-common --assume-yes && 
sudo apt-add-repository --yes --update ppa:ansible/ansible &&
sudo apt-get update && sudo apt install ansible --assume-yes &&
wget https://raw.githubusercontent.com/csereya/pruebaTenpo/main/scripts/api.yml &&
ansible-playbook api.yml -i localhost