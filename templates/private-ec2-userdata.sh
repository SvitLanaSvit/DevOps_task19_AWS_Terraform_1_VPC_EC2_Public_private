#!/bin/bash
apt-get update
apt-get install -y htop curl wget
echo "Private EC2 - Ready!" > /home/ubuntu/server-info.txt
chown ubuntu:ubuntu /home/ubuntu/server-info.txt