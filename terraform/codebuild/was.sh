#!/bin/bash
sudo su
source /etc/profile
cd /mnt/efs/app/spring-petclinic/target/
java -jar -Dspring.profiles.active="mysql" *.jar