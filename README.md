# machine_configure
This script set configuration of: network, domain/workgroup and machine's rename.

#Possibles configs in:

##Newtork
IPv4 only in the moment. If the user set for IPv6, one message the "unavailable" show in display.
In config for IPv4, is possible choose between in static and dynamic IP address. 

###Static IP
is possible set IP address, Gateway and Preferred & Alternate DNS's.

###Dynamic IP
configure in DHCP.
Both configs (static or dynamic) is reseted configs of network as soon as started. Being possible edited this configurations inside of run.

##Domain/Workgroup
the user choose between this options. In both options, set the values is enough.

##Rename
is enough set the values, too.

In options of Domain/Workgroup and Rename, restart the machine is necessary. If reboot is pending, is impossible set this options again. If the user will stop the run, a message for restart machine shows in display, before end run.

In all options, a confirm message is required.

Extras options:
Option 9 - Restart machine: will restart the machine in 10 seconds, with a progress bar.
Option 0 - Exit: back to the beginning or will stop the run.

Is recommended start run as admin mode.

#Author
Matheus Rocha
Brazil
https://www.linkedin.com/in/roch4/
