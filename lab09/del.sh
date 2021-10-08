#!/bin/bash

#delete lab-9 users

deluser cis191
deluser frodo
deluser gollum
deluser legolas
deluser glorfindel
deluser gimli

delgroup cis191
delgroup hobbits
delgroup elves
delgroup dwarves
delgroup wizards

sudo rm -R /home/cis191
sudo rm -R /home/frodo
sudo rm -R /home/smeagol
sudo rm -R /home/gollum
sudo rm -R /home/legolas
sudo rm -R /home/gimli

sudo rm /var/preserve/*
