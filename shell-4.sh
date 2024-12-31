#!/bin/bash
echo "All variables passed: $@"
echo "Number of variables: $#"
echo "Script name: $0"
echo "Present working directory: $PWD"
echo "current user home directory: $HOME"
echo "Current user: $USER"
echo "Process id of current script: $$"
sleep 60 &
echo "process id of last command: $!"