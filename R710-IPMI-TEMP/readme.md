# Safety BASH script
Based off of this [Reddit thread](https://www.reddit.com/r/homelab/comments/779cha/manual_fan_control_on_r610r710_including_script/) which was inspired by [this Reddit post](https://www.reddit.com/r/homelab/comments/72qust/r510_noise/dnkofsv/) by /u/whitekidney. 

Instead of running this script on a separate machine, my code runs directly on the host, therefore removing the dependency on another host to continually supply the queries for the original script to work (so the script host failing doesnt burn down my server). Also removes slack and healthcheck.io parts of the code.

This is running on my Dell R710 on the host Debian based Proxmox hypervisor.

Remember to make the script executable:
`chmod +x /etc/init.d/startupfan.sh`

*****

# Howto: Setting the fan speed of the Dell R610/R710

1. Enable IPMI in iDrac
2. Install ipmitool on linux, win or mac os
3. Run the following command to issue IPMI commands from the server terminal: 
`ipmitool -I lanplus -H <iDracip> -U root -P <rootpw> <command>`


**Enable manual/static fan speed:**

`raw 0x30 0x30 0x01 0x00`


**Set fan speed:**

(Use i.e http://www.hexadecimaldictionary.com/hexadecimal/0x14/ to calculate speed from decimal to hex)

*3000 RPM*: `raw 0x30 0x30 0x02 0xff 0x10`

*2160 RPM*: `raw 0x30 0x30 0x02 0xff 0x0a`

*1560 RPM*: `raw 0x30 0x30 0x02 0xff 0x09`

_Note: The RPM may differ from model to model_


**Disable / Return to automatic fan control:**

`raw 0x30 0x30 0x01 0x01`


**Other: List all output from IPMI**

`sdr elist all`


**Example of a command:**

`ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin  raw 0x30 0x30 0x02 0xff 0x10`


*****

**Disclaimer**

I'm by no means good at IPMI, BASH scripting or regex, etc. but it seems to work fine for me. 

TLDR; I take _NO_ responsibility if you mess up anything.

*****

