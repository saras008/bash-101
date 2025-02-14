#!/bin/bash

cd /home/saras008/backup/ && git add -A && git commit -m "auto commit - `date +\"%Y-%m-%d\"`" && git push origin master;

*note 

run the script on crontab