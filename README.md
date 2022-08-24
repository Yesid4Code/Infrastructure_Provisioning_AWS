# Infrastructure Provisioning on AWS with Terraform

In order to learn about the **Amazon Web Service (AWS)** cloud computing platform, the architecture shown in the figure below has been proposed as a starting point. To achieve this objective, three stages must be fulfilled:

* Explain the services required by the architecture.
* Generate a new graph showing the changes.
* Generate the code to implement the architecture.
  * For this, **Terraform** will be used. **Terraform** is a tool specialized in implementing infrastructure as code.

<p align="center">
    <img src="images/base_architecture.png" alt="Base architecture">
</p>

## Amazon Web Service - AWS

AWS is the leading platform for cloud services, with more than 200 complete services in data centers around the world. The goal of AWS is to reduce the operating costs of companies and make them more agile and productive. AWS is located in 26 regions around the world and continues to expand, in each region it has a different number of zones enabled for its data center. Visit the following link where you can see its infrastructure in detail [AWS Infrastructure][AWS Infraestrucutre].

To generate the infrastructure on the platform, it is necessary to register at the following link, [AWS Register][AWS Register].

### AWS Root user and Identity and Access Manager - IAM

When creating the user account in **AWS**, a **root** user is automatically generated for your account, however, this user has all the privileges (permissions) on the **AWS* account to access, modify and delete all the services available on the platform. For this reason it is recommended, as a first action, to generate an**IAM**user with administrator permissions, this permission is already more limited than the**root**user, so the risks are lower. It is advisable to establish different**IAM Users** for each of the roles you have on the platform and work with them ([IAM Identidites][IAM Identities]).

> The **root** user should not be used, only to perform some account and service administration tasks. It is advisable to save the access data with extreme caution.

As an **IAM** user, you must have access to the **AWS Management Console**, this will allow you to consult the operation of all **AWS** services. The first thing you need to do is generate the security credentials that will allow you to access **AWS** services from a *terminal*.

**Install awscli and use credentials**:
In order not to enter the access credentials directly in the code, in the command terminal execute the following instructions:

* `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
* `unzip awscliv2.zip`
* `sudo ./aws/install`

```linux
aws config
AWS Access Key ID [None]: AKIASSEALOGMARMYABHP
AWS Secret Access Key [None]: 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
Default region name [None]: us-east-2"
Default output format[None]: json
```

## AWS Services

The services used by the architecture are:

### Region and Availability Zone

**Regions** are the different distributions zones that **AWS** has around the world ([AWS Infrastructure][AWS Infraestrucutre]).

* [Regions ans Zones][Regions and zones]
* Every region has a **VPC** by default.

### Amazon Virtual Private Cloud - [Amazon VPC][Amazon VPC]

This is where the magic happens. **Amazon Virtual Private Cloud (Amazon VPC)** gives you full control over your virtual network environment, includin:

* Resource location,
* Connectivity, and
* Security.

 The **VPC** always belongs to a **region**, and a **region** can contain up to five **VPCs**, although you can request to increase this limit.

* A **VPC** spans the entire Availability Zone in the region.
* The **VPC** must have an associated IP address known as **CIDR**, it can be **IPv4** or **IPv6**.
  * All the IP addresses of the elements (hosts) that will be part of the **VPC** are derived from this **CIDR** block.
* Every region has a VPC by default and this in turn has a series of initially available resources such as subnets, security group, route table.
* See how to create a [**Amazon VPC**][Create a VPC]

### Classes Inter-Domain Routin - CIDR

Its purpose is to generate an IP range, an IP address is the addresses that computers use to communicate with each other. It is used for both the VPC and the subnets.

**IPv4** addresses are represented by four binary octets that make up a 32-bit IP address.

* 192.168.0.0 *IPv4* single (32-bit).
  * 192: 11000000 (8 bits).
  * 168: 10101000 (8 bits).
  * 0: &nbsp;&nbsp;&nbsp;&nbsp;00000000 (8 bits).
  * 0: &nbsp;&nbsp;&nbsp;&nbsp;00000000 (8 bits).
* An IPv4 address has a *network ID* and a group of *host IDs*.
  * The *subnet mask* is used to define the *network ID* and the *host ID*.
  * If the *network* is: 192.168.0.0 and
  * The *subnet mask* is: 255.255.255.0
    * It means that the network prefix (*network ID*) is: 192.168.0
    * It also means that there are 8 bits, from the fourth octet of the network, for *host IDs*.
    * 192.168.0.0/**24** is another way to represent the *subnet mask*.

The size of a **CIDR** block can be between **/16** and **/28**.

* Cannot be overlaid on top of another existing **CIDR** block associated with the VPC.
* Its size cannot be increased or reduced.
* The first four and last IP addresses will not be available for use.
* AWS recommends using **CIDR** blocks from the *RFC 1918* range.
  * 10.0.0.0 - 10.255.255.255 (10/8 prefix). Example **CIDR** 10.0.0.0/16 or smaller.
  * 172.16.0.0 - 172.31.255.255 (172.16/12 prefix). Example **CIDR** 172.31.0.0/16 or smaller.
  * 192.168.0.0 - 192.168.255.255 (192.168/16 prefix). Example **CIDR** 192.168.0.0/24 or smaller.

**Private IP** – Private IP addresses are derived from the *CIDR Block*, used to derive IP addresses for subnets and instances.

**Public IP**: In order for the instances to communicate with resources outside the **VPC**, they must have a public address assigned, so they will also have a private address for communication within the **VPC**and a public one for all communication outside the**VPC**. The reserved IP address is not fixed, it changes over time.

**Elastic IP**: they are public IP addresses and you also have to reserve them, unlike the previous ones, these are static addresses, they do not vary over time. If you have such an address but are not using it, you will be charged for its non-use, which is why it must be released.

**IPv6**: IPv6 addresses are public by default.

### Subnets

It is the place where the instances are created.

* Resides within an availability zone.
* Used to split **VPCs**.
* Use this tool to calculate subnets [Network00][Network00]

### Gateway

* **Internet Gateway/Egress only Internet Gateway**: The Amazon VPC side of a connection to the public Internet for IPv4/IPv6.

It is the means used to connect to the internet.

* **IGW** is attached to the **VPC**.
* The **VPC** can only have one **IGW**.
* Allows Internet access from a **VPC**.
* It is the gateway to the world outside the **VPC**.

To have access to the internet, you must establish a routing table and indicate that you have access to the internet through *Internet Gateway*.

**Main Route Table**:
| Destination | target |
|:-----------:|--------|
| 10.0.0.0/16 | local |
| 0.0.0.0/0 | igw-id |

**Subnet Route Table**:
| Destination | target |
|:-----------:|--------|
| 10.0.0.0/16 | local |
| 0.0.0.0/0 | igw-id |

After the routing table is established, the subnet can communicate outside the VPC through the Internet Gateway.

### Firewall, security groups and Router tables

Firewalls are rules that allow you to control incoming and outgoing traffic, they are configured both in security groups that are implemented in the instances or through access rules implemented in the routing table.

**Route table**:

You can't really see a router as such, however, it does exist by configuring a route table.

* The route table is used to configure the *VPC Router*.
* The *VPC router* handles routing inside the VPC and outside the PVC.
  * Allowed access must be specified.
* The router then takes care of making sure the data connection is sent to the right place.

**Security group**:

Security group filters traffic between instances on the same subnet or on another subnet.

* Instance level firewalls.
  * Allows control of access to instances.
* A security group can be applied to multiple instances, even from different *subnets*.
* An instance needs to have a rule configured for outgoing traffic, by associating it with a *security group* an outgoing rule is being created.

*Entry rules*:

| Type| Protocol | Port Range | Source |
| :-----: | :----: |:----: | :----: |
| SSH | TCP | 22 | 0.0.0.0/0 |
| RDP | TCP | 3389 | 0.0.0.0/0 |
| RDP | TCP | 3389 | ::/0 |
| HTTPS | TCP | 443 | 0.0.0.0/0

The **SG** only used allow rules. There is no such thing as a no entry rule. Before a request enters, **SG** check if it is allowed, if not, it does not allow traffic. You are implicitly denying the service, you don't have to specify it.

**Network ACL**:

* This type of **firewall** is applied at the subnet level.

There is also another type of access control, such as the case of the **Network Access Control List**, which, although not seen in any of the graphs, is implemented. If its creation is not specified, when creating the **VPC**, it automatically creates a **NACL** for each of its subnets, since it acts at the subnet level.

**Stateful vs. Stateless Firewalls**:

* **Security group** is a *stateful firewall*.
* **NACL** is a *stateless firewall*.
* A **stateful** firewall allows return traffic automatically (*sg*).
  * You don't have to worry about the answer. The firewall understands that the return is part of the connection.
* A **stateless** firewall looks for an allow rule for both connections.
  * You need an input rule and an output rule.
  * The firewall does not understand that the return traffic is part of the connection.

### Load Balancer, Application vs Networkd Load Balancer

There are different types of *Load Balancers*, in this case we will be using **Network Load Balancer** to distribute the traffic between the two instances. For this, the *Load Balancer* must be linked with each of the instances.

* To learn more about the *Load Balancers* watch the following video ([click][Load Balancer]), and do the following reading ([click][Load Balancing]) made by IBM.

AWS provides extensive documentation for each of its services and how to implement them. In this link you will find information on the specific characteristics of the *Load Balancers*, which are necessary for their correct operation, how to properly configure the **listeners** and the **Target groups**

* **Listeners**: specifies a rule that indicates the port through which it will receive resource requests and the protocol used for this purpose.
* **Target group**: is a group of instances, to which I want the **Load Balancer** to send the resource request, for this reason this *target group* must be linked with the *load balancer*
* [AWS Load Balancing][AWS Load Balancing].
* [Create a LB][Create a LB]

Instances are commonly accessed from the internet through an IP address, however, to access the *Load Balancer* and for it to randomly distribute access, it must be accessed through the **DNS Name of the Network Load Balancer**

* DNS name example: `NLB-92d2248494590dbc.elb.us-east-2.amazonaws.com`
* In the browser, type the *DNS Name* in the URL bar like any URL.
* In a terminal, type the following command: `dig NLB-92d2248494590dbc.elb.us-east-2.amazonaws.com` and wait for a response.
* In a terminal, type the following command: `curl NLB-92d2248494590dbc.elb.us-east-2.amazonaws.com`
  * This command retrieves the content of the page, in this case a "Hello World" message.

### Amazon Elastic Compute Cloud - Amazon EC2

This service provides scalable computing capacity in the Amazon Web Services (AWS) cloud. Using Amazon EC2 eliminates the need to invest in hardware, so companies can develop and deploy applications faster. You can use Amazon EC2 to launch as many or as few virtual servers as you need, set up security and networking, and manage storage. Amazon EC2 allows you to scale up or down to handle changes in requirements or spikes in popularity, reducing your need to forecast traffic [][EC2].

EC2 instances require a Network Interface, where a Public IP address will be assigned and linked to the Private IP address, thus ensuring that the EC2 Instance has communication outside and inside the **VPC**.

* If you want to access the instance through the SSH protocol, you must generate an access key.
  * This access key will be valid for all instances created within the same region. Each region requires its own access key for its EC2 instances.
* You can have installed any operating system that you find in the Amazon marketplace, however Ubuntu will be used for this purpose.
  * Apache2 will be installed on this operating system, which is a web server that allows generating web content. For this purpose, only a "Hello World" message will be displayed, followed by the name of the server that is being accessed.
  * If you want to access a specific server, you must enter the IP address provided to that server in the URL bar.
  * If you want the access to be random, you must enter the **DNS Name** of the router as the URL in the URL bar. This will distribute access between the two servers.
* Create you own EC2 and experience how it works [Launch an EC2 instance][Launch an EC2 instance]

## Terraform

**Terraform** is *HashiCorp** infrastructure as code tool. It lets you define resources and infrastrucure in human readable, declarative configurations files, and manges your infrastructure's lifecycle. Terraform can manage the infrastructure in multiple cloud platforms, however, for this case, the cloud platform used is **AWS**.

**Terraform** through the language **HCL** (abbreviation of HashiCorp Language) developed by HashiCorp, allows implementing a set of instructions in order to generate the infrastructure in a service provider, such as Amazon Web Services, in a single faster and more automated way.

The code in this repository is made with **Terraform**, so you can browse the different files and learn their syntax using the help of the **Terraform** documentation for **AWS**, [AWS Provider][AWS Provider].

The most prominent **Terraform** commands are the following:

* `terraform init`. Review the configuration in all terraform files and download the necessary plugins to interact with the AWS API.
  * Create a folder: '.terraform'.
* `terraform fmt` - Terraform format: Formats the Terraform code, not required for it to work, but is necessary as a good practice.
* `terraform validate`: validates the configuration files in a directory, referring only to the configuration and not accessing any remote services
* `terraform plan`. creates an execution plan, allows you to see the changes that will be made to the infrastructure. This plan is achieved by following these steps:
  * Reads the state file to verify that there is a change between the state of the last execution of the code, and the current code to apply. Verify changes in the infrastructure.
  * If there are changes, it proposes an execution plan.
  * `terraform plan -out=tfplan`, is a variation that allows you to save the proposed plan to a file called `tfplan`.
* `terraform apply` applies the changes. It requests a confirmation, this brings the advantage that you can review what you are about to implement.
  * `terraform apply --auto-approvve`: Execute the plan proposed by **Terraform** without asking for confirmation.
  * `terraform apply --auto-approve [file_name]`. aliases tfaa
    * Generate state: `terraform.tfstate` file.
  * Apply the code on the desired platform, in this case **AWS**.
* `terraform destroy --auto-approve`: Destroy the infrastructure.
* `terraform -help`: displays a list of commands that can be used with **Terraform**.

Version 1.0 of this repository contains the following infrastructure where the **Network Load Balancer** is not yet used, to access the instances it must be done through the Public IP generated at the time of linking the *Network Interface* with the EC2 instance.

* Version [1.0][V1.0]

<p align="center">
    <img src="images/IaCv1.0.png" alt="Base architecture">
</p>

Version 2.0 of this repository already has the infrastructure required for the development of the desired infrastructure.

* Version [V2.0][V2.0], or by default the main branch contains the latest update.

<p align="center">
    <img src="images/IaCv2.0.png" alt="Base architecture">
</p>

The generated crypts in the `/user_data/` folder:

* `/user_data/server_setup.sh`: is used by **Terraform** to make changes to the **EC2** instance upon creation.
* `/user_data/deploy.sh` - Create the infrastructure on **AWS**. Every time it is executed it deletes the infrastructure and recreates it.
  * Before executing the code you must enter the access credentials to **AWS** through the **AWS CLI**.
  * To run the code, at the command terminal type: `bash /user_data/deploy.sh`.
  * When making the infrastructure from scratch, the previous data, such as Public IP addresses and DNS Name, change.
  * If at any point in the execution of the code an error occurs, you should verify that all services have been removed, some unreleased resources could incur costs.

## Documentation

* AWS Infraestructure - [AWS][AWS Infraestrucutre]
* IAM - [Documentation][IAM Identities]
* AWS Security groups vs NACL key differences
* Load Balancing - [IBM][Load Balancing], [video][Load Balancer]
* EC2 - [Documentation][EC2]
* EC2 Launch Instance - [Guide][Launch an EC2 instance]
* HashiCorp - [click here][HashiCorp]
* Terraform - [click here][Terraform.io]
* AWS Provider for Terraform- [click here][AWS Provider]
* Terraform overview [Initial Guide][Terraform Overview]

[//]: # (References links used in the body of this file.)
[AWS Infraestrucutre]: <https://aws.amazon.com/about-aws/global-infrastructure/?pg=WIAWS>
[AWS Register]: <https://portal.aws.amazon.com/billing/signup?nc2=h_ct&src=header_signup&refid=f4d78a03-c6cb-4813-aa1c-58574d7d95a0&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start/email>
[IAM Identities]: <https://docs.aws.amazon.com/IAM/latest/UserGuide/id.html?icmpid=docs_iam_console>
[Amazon VPC]: <https://aws.amazon.com/vpc/>
[Create a VPC]: <https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#Create-VPC>
[Regions and zones]: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html>
[Work with subnets]:<https://docs.aws.amazon.com/vpc/latest/userguide/working-with-subnets.html>
[AWS Security groups vs nacl - key differences]: <https://digitalcloud.training/aws-security-group-vs-nacl-key-differences/>
[Load Balancing]: <https://www.ibm.com/cloud/learn/load-balancing?utm_medium=OSocial&utm_source=Youtube&utm_content=SOFWW&utm_id=YTDescription-Load-Balancer-LH>
[Load Balancer]: <https://www.youtube.com/watch?v=sCR3SAVdyCc&ab_channel=IBMTechnology>
[AWS Load Balancing]: <https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html>
[Create a LB]: <https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-network-load-balancer.html>
[EC2]: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html>
[Launch an EC2 instance]: <https://docs.aws.amazon.com/efs/latest/ug/gs-step-one-create-ec2-resources.html>
[Network00]: <https://network00.com/>
[Terraform.io]: <https://www.terraform.io/>
[HashiCorp]: <https://www.hashicorp.com/>
[AWS Provider]: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs>
[V1.0]: <https://github.com/Yesid4Code/Infrastructure_Provisioning_AWS/tree/v1.0>
[V2.0]: <https://github.com/Yesid4Code/Infrastructure_Provisioning_AWS/tree/v2.0>
[Terraform Overview]: <https://www.terraform.io/cli>
