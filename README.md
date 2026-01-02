<h1> Multi-Tier Web Application Infrastructure</h1>

<h2>Description</h2>
In this project, I designed and deployed a secure, highly available, and scalable three-tier web application architecture on AWS using Infrastructure as Code with Terraform. This project automates the provisioning of all network components, compute resources, and database services thus minimizing manual configuration and demonstrating best practices for using cloud infrastructure.
<br />


<h2>Languages and Utilities Used</h2>

- <b>Terraform</b> 

<h2>Environments Used </h2>

- <b>Mac</b>

<h2>Installation</h2>

<p align="center">
**Installing Terraform (using Bash):**

  1. **Update your system and install necessary packages:**
        `sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl`
  3. **Add the HashiCorp GPG key:**
        `curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`
  4. **Add the official HashiCorp Linux repository:**
        `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
  5. **Update your package information and install Terraform:**
        `sudo apt-get update && sudo apt-get install terraform`
  6. **Verify the Installation**
        - After installation, open a new terminal window and verify it worked by checking the version:
          `terraform --version`
</p>

<h2>Features</h2>

- Custom VPC with Public subnets for applications and private subnets for applications and databases.These subnets are provisioned across two availability zones to ensure high availability.
- Internet gateway for public access and NAT gateways for the private subnets to allow outbound internet access for patching and updates.
- Security groups for the ALB, EC2 instances, and RDS database to strictly control traffic flow. The ALB accepts inbound traffic from the internet (port 80), the App Servers can only accept traffic from the ALB, and RDS accepts inbound traffic only from the App Servers (port 3306)
- Application Load Balancer (ALB) in the public subnets to distribute the incoming traffic.
- Auto Scaling Group (ASG) in the private application subnets, ensuring a minimum of two, and a maximum of four EC2 instances are running at all times. 
- Launch Template with the latest Amazon Linux 2 AMI and a startup script (user data) to automatically deploy a simple web server (HTTPD) on each new instance.
- MySQL 8.0 RDS instance in the private database subnets.
- Multi-AZ for high availability and automatic failover, ensuring it is not publicly accessible for maximum security.


<h2>Tech Stack/Built With</h2>
    
- **VPC (Virtual Private Cloud)** - creates a private, isolated cloud network with the IP range of 10.0.0.0/16 for all of the resources
    
- **Subnets** - segments the network for security and organization.In this project, there are 3 types of subnets working across two availability zones for high availability: Public Subnets (for access points), Private Application Subnets (for servers), and Private Database Subnets (for the database)
    
- **Internet Gateway (IGW)** - provides a pathway for the internet traffic to enter and exit the VPC. It is only attached to the Public Subnets.
    
- **NAT Gateway (with EIP)** - allows the private EC2 application servers to access the internet without exposing them to incoming internet traffic. This can be used for patching and updates.
    
- **Route Tables** - define the rules for traffic leaving the subnets. In this project, public subnets route to the Internet Gateway (IGW) and the private subnets route to the NAT GAteway.
    
- **Application Load Balancer (ALB)** - distributes the incoming traffic across healthy application servers in the private subnets. This ensures that no single server is overwhelmed and provides a single public entry point.
    
- **EC2 (Elastic Compute Cloud)** - these are the virtual machines that run the web server code. In this project, they are configured to automatically install a web server via a startup script upon launch.
    
- **Auto Scaling Group (ASG)** - this service ensures high availability by maintaining a minimum number of running EC2 instances (2 in this project). It also provides scalability by automatically launching a maximum number (4 in this project) during high traffic.
    
- **Launch Template** - acts as the blueprint for the ASG. It specifies the AMI (OS image), instance size, and which security group the new instances should use.
    
- **RDS (Relational Database Service)** - used to provision a MySQL database without having to manage the underlying operating system or patching. This provides high reliability and less maintenance overhead.
    
- **RDS Multi-AZ** - used to have AWS automatically maintain a synchronous standby copy of the database in a seperate Availability Zone. If the primary instance fails, traffic is automatically routed to the standby, ensuring zero downtime.
    
- **Security Groups (SGs)** - virtual firewalls the implement the seurity rules between tiers. 




<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
