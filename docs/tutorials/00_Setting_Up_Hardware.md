First you need to pick your hardware. I picked the following:

- 6x Raspberry Pi 5's 8gb
- 6x Raspberry Pi Active Coolers
- 6x GeekPi P33 PoE & m.2 SSD Hats
- 6x 250gb Samsung 980 m.2 SSD
- 1x NetGear GS308EPP
- 1x m.2 to USB adaptor

This gives the following resources:

- 24 cores CPU
- 48gb RAM
- 1.5tb Storage

Flashing the images onto the SSDs:
Download the official Raspberry Pi imager.
Using the SSD adaptor connect the SSD to the computer.
1. Select your Raspberry Pi Version
2. Select the Operating System, We will be using the LTS of Ubuntu Server
3. Customise the OS Settings:
  - Set a Hostname
  - Set a Username and Password
  - Enable SSH
4. Flash and repeat.

Setup the Switch (use your router to see device ip's)
Decrease your routers DHCP range leave 200-255 for the minilab
200-215 - Reserved for Hardware ip's
216-230 - Reserved for Metal lb
231-254 - Reserved for xyz.

Install ansible on your local machine.
Setup the anisble.config and inventories/hosts.yaml (make sure you name these after the set 
hostnames that you ssh onto your nodes!).
Run the ansible playbooks to setup the RPi's in the cluster in the /playbooks directory.

- ansible-playbook playbooks/host_ping.yaml
- ansible-playbook playbooks/node_setup.yaml --ask-become-pass
- ansible-playbook playbooks/cluster_setup.yaml --ask-become-pass
- ansible-playbook playbooks/node_system_info.yaml --ask-become-pass

This verifies that everything is setup correctly and the correct dependencies are installed.
