# QuickConnect
A CLI-Based program that allows you to quickly connect into remote machines via SSH or RDP.

The program reads your ~/.ssh/config file and list all of the available hosts to connect to, listing them in a sorted list.
Select a system by pressing the corresponding number.  

<br> 

__Installing Optional Pre-requisites__  
_Only needed for RDP connections and password-based SSH connections_  
```bash
# Debian-based distros
sudo apt-get update
sudo apt install sshpass -y 
sudo apt-get install freerdp-x11 -y
sudo apt-get install rdesktop -y
```

<br>

### Installation:
```bash
git clone https://github.com/bobby-valenzuela/QuickConnect.git
cd QuickConnect/
chmod +x quickconnect.sh
mv quickconnect.sh /usr/local/bin/quickconnect
````

<br>

### Usage:
```bash
quickconnect
```

<br />

<br>

__Simple Installation:__  
Use this installation if you just want to download the script and run it from a path you choose.
```bash
git clone https://github.com/bobby-valenzuela/QuickConnect.git
cd QuickConnect/
chmod +x quickconnect.sh
```

<br>

Usage:
```bash
bash quickconnect.sh
```


<br>


## Connecting with password and no key (not recommended)
If you're connecting to a machine that's only password-protected, include your password as a comment in your `config` file.  
```
Host {my-server-name}
HostName {myserver.io}
User {user}
Port {port}
# Pass {password}
```
If you have sshpass installed it will pass in your password so you won't be bothered with a prompt. :)  

<br>

To install sshpass run:
```bash
sudo apt install sshpass -y # Debian-based distros
```

<br>

## Connecting via RDP
You can include machines in your ~/.ssh/config file that you intend on connecting to via RDP.  
Format these entries as follows (replacing the bits in curly braces):
```
Host RDP-{my-server-name}
HostName {myserver.io}
User {user}:::{password}
Port {port}
```

<br />

Adding 'RDP-' to the start of the Host field lets the program know these entries should be connected to via RDP instead of SSH.  
Include the `-r` option to connect to machines via RDP.

Usage:
```bash
bash quickconnect.sh -r
```

_Note: Connecting via RDP requires xfreerdp and rdesktop to be installed._

<br />

### Trouble Shooting (WSL)

I've been using this without issue in WSL, butin case you're having issues, it could be to do with your `DISPLAY1 environment variable.
If you still get the “cannot open display” error, set the DISPLAY variable as shown below.
```bash
echo "export DISPLAY=localhost:0.0" >> ~/.bashrc
```
Note: IP is the local workstation’s IP where you want the GUI application to be displayed.  

__Helpful Related Links (WSL + GUI)__
- [Link 0](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
- [Link 1](https://aalonso.dev/blog/how-to-use-gui-apps-in-wsl2-forwarding-x-server-cdj)
- [Link 2](https://wiki.ubuntu.com/WSL#Running_Graphical_Applications)
- [Link 3](https://wiki.iihe.ac.be/Use_X11_forwarding_with_WSL)

<br />

There is a "lite" version included, which only has the bits of the script needed to read the ssh config file and connect via ssh (no RDP connections/packages to worry about).
