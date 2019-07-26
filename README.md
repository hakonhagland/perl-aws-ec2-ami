# perl-aws-ec2-ami

Recipe for setting up an AWS EC2 Ubuntu instance as a webserver that can be
controlled by a Perl real-time web framwork like [`Mojolicious`](https://metacpan.org/pod/Mojolicious). 

## Set up a Virtual Private Cloud (VPC)

Before creating and launching the an Amazon Machine Image (AMI), we
should decide on how the image should relate to the outside world (the
internet). That is,  which inbound and outbound traffic are allowed.
See
[Getting Started with IPv4 for Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html) for
detailed instruction on how to set up a nondefault VPC with a single
IPv4 public subnet that can access the internet.

### Create a security group for your instance

A security group acts as a virtual firewall to control the traffic for
its associated instances. To use a security group, you add the inbound
rules to control incoming traffic to the instance, and outbound rules
to control the outgoing traffic from your instance.  

See
[Create a Security Group](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html#getting-started-create-security-group) for
more information.


## Create and launch an Amazon Machine Image (AMI)
 
Go to https://aws.amazon.com/ec2/ and sign into the console. Click `EC2`
to go to the EC2 Dashboard. Click the button "Launch instance" under
the heading "Create instance".

- Step 1: Choose an AMI.  
Choose e.g. Ubuntu Server 18.04 LTS (HVM), SSD Volume Type, 64-bit (x86), and click the
"Select" button.

- Step 2: Choose an instance type.  
Choose e.g.
t2.micro (Variable ECUs, 1 vCPUs, 2.5 GHz, Intel Xeon Family, 1 GiB memory, EBS only). 
Click "Next configure instance".

- Step 3: Configure Instance Details.  
On the Configure Instance Details page, select the VPC that we 
created from the Network list, and the subnet that you created in the
previous step from the Subnet
list. Leave the rest of the default settings, and go through the next
pages of the wizard until you get to the Add Tags page 

- Step 4: Add Storage.  
Select the default settings, and click "Next: Add Tags".

- Step 5: Add Tags.  
On the Add Tags page, you can tag your instance with a Name tag; for
example `Name=PerlWebServer`. This helps you to identify your instance in
the Amazon EC2 console after you've launched it. Choose Next:
Configure Security Group when you are done. 

- Step 6: Configure Security Group.  
On the Configure Security Group page, choose the Select an existing security group
option, select the group that you created previously, and
then choose Review and Launch. 

- Step 7: Review Instance Launch.  
On the Review Instance Launch page, check the details of your
instance, and then choose Launch. 
  
    In the "Select an existing key pair or create a new key pair" dialog
box, you can choose an existing key pair, or create a new one. If you
create a new key pair, ensure that you download the PEM file and store it
in a secure location. You'll need the contents of the private key to
connect to your instance after it's launched. Check the acknowledge
button, and click "Launch instance".

Go to the EC2 dashboard and click the "instances" tab. Wait until the
instance is up and running (i.e. the status checks shows a green
checkmark). This takes usually only a couple of minutes.

## Assign an Elastic IP Address to Your Instance

Go to the EC2 dashboard and click the "instances" tab. 
Select your instance, and view its details in the Description tab. The
Private IPs field displays the private IP address that's assigned to
your instance from the range of IP addresses in your subnet. 

The instance in your subnet also needs a public IPv4 address
to be able to communicate with the Internet. By default, an instance
in a nondefault VPC is not assigned a public IPv4 address. In this
step, you'll allocate an Elastic IP address to your account, and then
associate it with your instance, see [Assign an Elastic IP Address to Your Instance
](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html#getting-started-assign-eip) for
more information.

- Open the Amazon [VPC console](https://console.aws.amazon.com/vpc/).

- In the navigation pane, choose Elastic IPs.

- Choose Allocate new address, and then Allocate.

- Select the Elastic IP address from the list, choose Actions, and
  then choose Associate Address. 

- Choose your instance from the Instance list. Also enter its private
  IP, as found in the previous section. Choose Associate when you're done.

Your instance is now accessible from the Internet. You can connect to
your instance through its Elastic IP address using SSH or Remote
Desktop from your home network. 

## Login to the AMI via SSH

On your current machine, go the folder where you saved the PEM
security file that was created for the AMI. Then from the terminal
window, type:

```
ssh -i $pem_file_name ubuntu@$perl_aws_web_server_ip
```

where `$pem_file_name` is the name of the PEM file, and
`$perl_aws_web_server_ip` is the elastic IP you generated for the AMI
in the previous step.

## Clone this repository

The `git` and `vim` commands are already installed, so the following should work:

```
git config --global user.name "Your_user Name"
git config --global user.email your_user_name@example.com
git config --global core.editor vim
git clone https://github.com/hakonhagland/perl-aws-ec2-ami.git
cd perl-aws-ec2-ami/bin
./install_ubuntu_packages.sh
```

- After running the last
   script, [`tmux`](https://github.com/tmux/tmux/wiki) should be
   installed. Now run it   
   ```
   tmux
   ```
- and continue working from within the `tmux` session. Install
`perlbrew` and `perl` version 5.30 by running the following script:   

   ```
   ./install_perlbrew.sh
   ```
   It will take some minutes to complete. In the meanwhile, open a new
   `tmux` window by pressing `CTRL+b c` and type:   
   ```
   tail -f ~/perlbrew/build.perl-5.30.0.log
   ```
- Install Perl module `Mojolicious`:  
    ``` 
    cpanm Mojolicious
   ```

- Install apache2 config file for with reverse proxy settings:  
   ```
   sudo install_apache_conf.sh
   ```
   
