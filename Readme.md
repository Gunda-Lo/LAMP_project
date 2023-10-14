This documentation will provide an explanation to the script for the automated creation, configuration and installation of two virtual machines, one running master and the other slave, with a LAMP stack on both and an Nginx load balancer, configured on the master.

Initialize the Vagrant environment with the Ubuntu Bionic64 box.
Create a Vagrantfile with machine
definitions.

Define the "master" VM.
Set the hostname for the "master."
Specify the box to use for the "master" VM.
Configure a private network for the "master."
Provision the "master" VM with shell commands.
Update and upgrade the system packages.
Install the 'sshpass' tool for password-based SSH.
Enable password-based SSH authentication (commented out), and restart SSH.
Install Avahi Daemon and supporting libraries.

Set the hostname for the "slave."
Specify the box to use for the "slave" VM.
Configure a private network for the "slave."
Provision the "slave" VM with shell commands.
Install the 'sshpass' tool for password-based SSH.
Enable password-based SSH authentication, and restart SSH.
Install Avahi Daemon and supporting libraries.

Set the VM's memory to 1024 MB (1 GB).
Allocate 2 CPU cores to the VM.

Bring up the VMs.

Source leads to another script for further actions.

Create the "altschool" user and add it to the "sudo" group.
Set the password for the "altschool" user.
Add the "altschool" user to the "root" group.
Create a user with UID and GID of 0 (superuser).
Generate an SSH key pair for "altschool."
Copy the public key to a file.
Generate an SSH key pair for "vagrant."
Copy "vagrant" SSH key to "master" VM.
Copy "altschool" SSH key to "master" VM.
Create a directory for data transfer.
Transfer data from "slave" to "master."
Get a list of running processes.

On the master:
Update APT packages and upgrade to the latest patches
Install Apache
Add a firewall rule to allow incoming traffic to Apache
Display the UFW status
Install MySQL
Set permissions for the /var/www directory
Install PHP and related modules
Enable Apache modules
Modify the Apache DirectoryIndex to include Index.php
Restart Apache
Install Nginx
Configure Nginx as a load balancer
Create a symbolic link to enable the Nginx configuration
Test the Nginx configuration
Restart Nginx to apply the changes

On the slave:
Update APT packages and upgrade to the latest patches
Install Apache
Add a firewall rule to allow incoming traffic to Apache
Display the UFW status
Install MySQL
Set permissions for the /var/www directory
Install PHP and related modules
Enable Apache modules
Modify the Apache DirectoryIndex to include Index.php
Restart Apache

SSH into the master
Create a test php file and add content to it.
Copy the test.php file to the /var/www/html directory on the master
Copy the test.php file to the /var/www/html directory on the slave (using SSH)
Save and exit
Access the test PHP page from your web browser by entering the following URL: http://192.168.56.5/test/test.php
Using the ip address of either the master or slave (to access the respective machine) and providing the path to the test file.
