# HBlink and HBmonitor installation

Download script to your Server/Raspberry pi (now only for debian based Linux systems)

make it executable by entering  
- chmod +x HBlink_install.sh

run it under root user

--------------------
# TG rules generator

Rules generator script was written by Jean-Marc F1SCA

How to use:

in same directory where you downloaded script make 3 files: masters.txt openbridge.txt tg.txt

masters.txt:
name_of_master_same_as_in_hblink_conf:static1:static2:.......
Max 5 statics talkgroups.

e.g.:
MASTER-1

openbridge.txt:
name_of_master_same_as_in_hblink_conf

e.g.:
OBP-1

tg.txt:
talkgroup_number:timeslot

talkgroup number:timeslot

e.g.:
91:2

92:1
