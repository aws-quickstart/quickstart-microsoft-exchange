# Best Practices<a name="best-practices"></a>

The architecture built by this Quick Start supports AWS best practices for high availability and security\. 

## High Availability and Disaster Recovery<a name="ha-disaster-recovery"></a>

Amazon EC2 provides the ability to place instances in multiple locations composed of AWS Regions and Availability Zones\. Regions are dispersed and located in separate geographic areas\. Availability Zones are distinct locations within a region that are engineered to be isolated from failures in other Availability Zones and that provide inexpensive, low\-latency network connectivity to other Availability Zones in the same region\.

By launching your instances in separate regions, you can design your application to be closer to specific customers or to meet legal or other requirements\. By launching your instances in separate Availability Zones, you can protect your applications from the failure of a single location\. Exchange provides infrastructure features that complement the high availability and disaster recovery scenarios supported in the AWS Cloud\.

These inputs determine the following:
+ Whether you should deduct an arbitrary overhead percentage from the resulting processor performance calculation based on the cost of virtualization
+ The number of processor cores that will be made available to the virtual machine
+ The optional SPECint2006 performance rating of the target platform onto which the Mailbox role will be deployed

## Automatic Failover<a name="automatic-failover"></a>

Deploying the Quick Start with the **default parameters **configures a two\-node database availability group \(DAG\) with a file share witness\. The DAG uses Windows Server Failover Clustering for automatic failover\. 

The Quick Start implementation supports the following scenarios:
+ Protection from the failure of a single instance
+ Automatic failover between the cluster nodes
+ Automatic failover between Availability Zones

However, the Quick Start default implementation doesn’t provide automatic failover in every case\. For example, the loss of Availability Zone 1, which contains the primary node and file share witness, would prevent automatic failover to Availability Zone 2\. This is because the cluster would fail as it loses quorum\. In this scenario, you could follow manual disaster recovery steps that include restarting the cluster service and forcing quorum on the second cluster node \(e\.g\., ExchangeNode2\) to restore application availability\. 

The Quick Start also provides an option to deploy into three Availability Zones\. This deployment option can mitigate the loss of quorum in the case of a failure of a single node\. However, you can select this option only in AWS Regions that include three or more Availability Zones; for a current list, see [AWS Global Infrastructure](https://aws.amazon.com/about-aws/global-infrastructure/)\. 

We recommend that you consult the [Microsoft Exchange Server documentation](https://docs.microsoft.com/en-us/Exchange/exchange-server?view=exchserver-2019) and customize some of the steps described in this guide or add ones \(e\.g\., deploy additional cluster nodes and configure mailbox database copies\) to deploy a solution that best meets your business, IT, and security requirements\. 

## Security Groups and Firewalls<a name="security-groups-firewalls"></a>

When the EC2 instances are launched, they must be associated with a security group, which acts as a stateful firewall\. You have complete control over the network traffic entering or leaving the security group, and you can build granular rules that are scoped by protocol, port number, and source or destination IP address or subnet\. By default, all traffic egressing a security group is permitted\. Ingress traffic, on the other hand, must be configured to allow the appropriate traffic to reach your instances\. 

[The Securing the Microsoft Platform on Amazon Web Services whitepaper](https://d0.awsstatic.com/whitepapers/aws-microsoft-platform-security.pdf) discusses the different methods for securing your AWS infrastructure\. Recommendations include providing isolation between application tiers using security groups\. We recommend that you tightly control ingress traffic, so that you reduce the attack surface of your EC2 instances\. 

Domain controllers and member servers require several security group rules to allow traffic for services such as AD DS replication, user authentication, Windows Time service, and Distributed File System \(DFS\), among others\. The nodes running Exchange Server permit full communication between each other, as recommended by Microsoft best practices\. For more information, see the [Exchange, Firewalls, and Support blog post](https://blogs.technet.microsoft.com/exchange/2013/02/18/exchange-firewalls-and-support-oh-my)\. 

Edge node servers \(if configured to be deployed\) allow port 25 TCP \(SMTP\) from the entire internet\. 

The Quick Start creates certain security groups and rules for you\. For a detailed list of port mappings, see the [Security section](https://docs.aws.amazon.com/quickstart/latest/active-directory-ds/security.html) of the Active Directory Domain Services Quick Start deployment guide, and the [Security](security.md) section of this guide\. 