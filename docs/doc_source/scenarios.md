# Deployment Options<a name="scenarios"></a>

This Quick Start provides two deployment options:
+ **Deploy Exchange Server into a new VPC \(end\-to\-end deployment\)**\. This option builds a new AWS environment consisting of the VPC, subnets, NAT gateways, security groups, bastion hosts, and other infrastructure components, and then deploys Exchange Server into this new VPC\.
+ **Deploy Exchange Server into an existing VPC**\. This option provisions Exchange Server in your existing AWS infrastructure\. Your AWS environment must include a VPC with two or three Availability Zones, public and private subnets in each Availability Zone, Remote Desktop Gateway and NAT gateways deployed into the public subnet, and Active Directory Domain Services deployed into the private subnet\.

The Quick Start also lets you configure additional settings such as CIDR blocks, instance types, and Exchange Server settings, as discussed later in this guide\.