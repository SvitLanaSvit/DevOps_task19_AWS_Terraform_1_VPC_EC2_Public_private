#!/bin/bash
apt-get update
apt-get install -y htop curl wget
echo "Public EC2 (Jump Host) - Ready!" > /home/ubuntu/server-info.txt
chown ubuntu:ubuntu /home/ubuntu/server-info.txt