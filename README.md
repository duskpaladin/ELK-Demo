# ELK-Demo
A demonstration of a basic ELK Stack deployment on a Microsoft Azure cloud network as part of the Github Fundamentals portion of Week 13 of UCI's 2020 Cybersecurity Bootcamp.

# Background and Purpose #
The cloud and cloud services have become a core part of many industries. Cloud services offers a wide variety of productivity, security and cost benefits to companies, but the virtualized nature of most of the equipment and functions on a cloud network require us to take a different approach to securing the network from malicious actors compared to an on-premises network. To better understand how best to protect a cloud network against cyberthreats, this project will create and deploy a cloud infrastructure environment on a popular cloud computing service like Microsoft Azure with an ELK stack to log and monitor traffic. Understanding the unique facets of cloud architecture is vital for securing a virtual network against cyberthreats.

# Scope #
The project utilizes a relatively simplistic deployment of a cloud network on Microsoft Azure's Cloud Computing Services running DVWA Docker containers. An ELK stack was added to supplement a cybersecurity professional's ability to log and monitor traffic and better respond to indicators of attack and/or indicators of compromise. For this project, Filebeats and Metricbeats were configured and installed as part of the ELK stack.

# Implementation #
In order to deploy an ELK Stack, we will first need to create a virtual network with virtual machines for the ELK stack to monitor. Once our initial virtual network and its virtual machines are up and running, we can then create a seperate virtual network and virtual machine for the ELK stack. We can then configure both networks to ensure the ELK stack receives logs from the first virtual network for review by a cybersecurity professional.

## Virtual Net Creation ##
1) Create a virtual network with a network IP range of 10.1.0.0/16
2) Create a default subnet with an IP range of 10.1.0.0/24

## Establish Network Security Group (NSG) ##
1) Create a new NSG for the newly created virtual net
2) Create an inbound security rule at the lowest priority blocking all incoming traffic
3) Create inbound security rules of higher priority to allow traffic from specific sources as infrastructure in the virtual network is created and added

## Creating Virtual Machines (VMs) ##
1) Create a new SSH key pair
2) Create a new Azure VM with a static public IP address to function as the Jump Box into the virtual network
    
    a. Set authentication type as SSH key pair and use the public key generated from step #1
3) Create additional Web VMs as needed (three in our case)
    
    a. Also be sure to have these VMs authenticate with SSH keys; having seperate SSH keys for each VM is best    
    b. Ensure all Web VMs do not have public IP addresses; they will be connected to within the virtual network via the Jump Box VM

## Configure the Jump Box VM and Docker Container ##
1) Add a new inbound security rule allowing SSH connections to the Jump Box VM from the IP you wish to use to connect to the network with (such as your home IP)
2) Install Docker onto the Jump Box VM
3) Create a new inbound security rule allowing SSH connections from the Jump Box to the rest of the virtual network
4) Attach the container to the Jump Box VM and add the private IP addresses of the Web VMs to the Ansible hosts file
5) Add the admin user name in the remote_user section of the Ansible configuration file

## Create and Deploy an Ansible Playbook for Docker and DVWA ##
1) Create a playbook that installs the following:

    a. docker.io    
    b. python3-pip    
    c. docker    
    d. The Damn Vulnerable Web App (DVWA) container
2) Deploy the playbook

## Load Balancing ##
1) Create a load balancer with a static IP address on Azure
2) Add a health probe to regularly confirm that all VMs can receive web traffic
3) Create a backend pool and add all your Web VMs to it
4) Create a load balancing rule to forward port 80 of the balancer to the Jump Box and Web VM's virtual network
5) Create a new inbound security rule in the NSG to allow port 80 traffic from your IP to the virtual network 

## ELK Stack Installation ##
1) Create a new virtual network with a network IP range of 10.0.0.0/16 for the ELK Stack server
2) Create a default subnet for the new virtual network with an IP range of 10.0.0.0/24
3) Create a peer connection between the two virtual networks
4) Create a new VM to run ELK with a public IP address

    a. The ELK VM will need at least 4GB to function, so choose an appropriate VM option
5) Create a new NSG for the ELK VM
6) Create a new Ansible Playbook for ELK installation that does the following:

    a. docker.io    
    b. python3-pip    
    c. docker        
    d. The Docker ELK container
    
        i. The ELK container will need to be started with the following ports:
        5601:5601
        9200:9200
        5044:5044
7) Run the playbook

## Filebeats Installation ##
1) Navigate to the Kibana web app using the public IP of your ELK server VM (http://[your.VM.IP]:5601/app/kibana)
2) From the homepage:

    a. Click on **Add Log Data**    
    b. Select **System Logs**    
    c. Click on the **DEB** tab    
3) Obtain a Filebeat configuration file and edit the file as follows:

    a. Under **output.elasticsearch**, change the hosts IP to the private IP address of your ELK server VM    
    b. Under **setup.kibana**, change the host IP to your ELK server VM's private IP address
4) Save the edit configuration file in the /etc/ansible/files directory (name it something like filebeat-config.yml for convenience)
5) Create an Ansible playbook that does the following:

    a. Download the Filebeat .deb file    
    b. Install the .deb file    
    c. Copies the filebeat-config.yml to where Filebeat is installed    
    d. Enables and configures the Filebeat system module    
    e. Setup Filebeat    
    f. Start the Filebeat service
6) Run the Filebeat playbook
7) On the Kibana web app, scroll to the bottom and click **Verify Incoming Data** to verify the ELK stack is receiving logs

## Metricbeat Installation ##
1) Return to the Kibana web app homepage and perform the following:
 
    a. Click on **Add Metric Data**   
    b. Select **Docker Metrics**   
    c. Click on the **DEB** tab
2) Obtain a Metricbeat configuration file and modify all host IP address to match the private IP address of the ELK server VM
3) Place the Metricbeats configuration file in the /etc/ansible/files directory
4) Create a new playbook or modify the Filebeats playbook to perform the following:

    a. Download the Metricbeat .deb file    
    b. Install the .deb file    
    c. Copy the Metricbeat configuration file to where Metricbeat is installed    
    d. Enable the Metricbeat system module    
    e. Setup Metricbeat    
    f. Start the Metricbeat service
5) Return to the Kibana web app, scroll to the bottom and click **Check Data** to verify the ELK stack is receiving the logs

Once the cloud network has been set up, it should look something like this:

![](diagrams/Example_Cloud_Network_and_ELK Stack.png)

# Repository Contents #
This project repository contains three folders. The first folder contains a few Linux Bash scripts created during the Linux portion of the cirriculum, meant to showcase some of the foundational skills needed for the project. The second folder is dedicated to the various Ansible configuration files and playbooks used to create and configure the DVWA containers and ELK stack on the two virtual networks created as part of the project. The final folder is dedicated to diagrams of various network setups for use in the repository as well as to display understanding of a proper network setup.