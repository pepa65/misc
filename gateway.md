# Setup NAT-busting gateway-SSH system
* Connections to multiple remote users (with separate connection ports) possible.
* Passwordless connection if the local user's public ssh key has been added to the remote user's `~/.ssh/authorized_keys`
* Connection example when setup: `ssh a_connection`
* Connection example without setup: `ssh -p 4444 -l user1 gateway.example.com`
* Connection syntax without setup: `ssh -p <a_connection_port> -l <a_remote_user> <gateway_server_domain_or_ip>`
* Example connection setup on the local machine in `~/.ssh/config`:
```
Host a_connection
  Hostname <gateway_server_domain_or_ip>
	User <a_remote_user>
	Port <a_connection_port>
```

## Gateway server
* Add a special user (say `GatewayUser`) to system with shell `/usr/sbin/nologin`
* Add special user to `AllowUsers` line in `/etc/ssh/sshd_config`: `AllowUsers GatewayUser`
* Add line `GatewayPorts yes` to `/etc/ssh/sshd_config`
* For added security, the ssh port could be changed: `Port <gateway_ssh_port>`
* Restart ssh server: `sudo systemctl restart sshd.service`
* For passwordlessness, add remote user's public ssh key to `/home/GatewayUser/.ssh/authorized_keys`
  - `sudo mkdir /home/GatewayUser/.ssh`
  - `sudo nano /home/GatewayUser/.ssh/authorized_keys` # paste the key
  - `sudo chmod 700 /home/GatewayUser/.ssh`
  - `sudo chmod 600 /home/GatewayUser/.ssh/authorized_keys`
  - `sudo chown GatewayUser /home/GatewayUser/.ssh -R`

## Remote machine
* The ssh server needs to be running for the connection to work: `sudo systemctl start sshd.service`
  - For added safety, setup a special user with a long badname, like `RemoteUser1234` and
    restrict ssh-login to that user only by adding the line `AllowUsers RemoteUser1234` to `/etc/ssh/sshd_config`.
    This user can login to a normal user with: `su -l <normal_user>`
* To faculitate passwordless access, add the local user's public ssh key to `~/.ssh/authorized_keys`
* The below is ever more robust with `autossh` (install with: `apt install autossh`).
  Below, replace `ssh` with:
```
autossh -M 0 -o "ServerAliveInterval 90" -o "ExitOnForwardFailure yes" -o "ServerAliveCountMax 2"
```
* To allow the connection, run:
```
ssh -fNR <a_connection_port>:localhost:<remote_ssh_port> -p <gateway_ssh_port> GatewayUser@<gateway_server_domain_or_ip>
```
* Or when setup: `ssh -fNR <a_gateway_port>:localhost:<remote_ssh_port> gateway`
* Concrete example: `ssh -fNR 4444:localhost:22 gateway`
* The setup in `~/.ssh/config`:
```
Host gateway
  Hostname <gateway_server_domain_or_ip>
  User GatewayUser
  Port <gateway_ssh_port>
```
