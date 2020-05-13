# Architecture<a name="architecture"></a>

## Architectural Considerations<a name="architectural-considerations"></a>

Before you deploy the template in this Quick Start, decide whether to use two Availability Zones or three, and whether to use a [file share witness](https://docs.microsoft.com/en-us/windows-server/failover-clustering/manage-cluster-quorum) or a full node\.

By default, the Exchange Server Quick Start uses two Availability Zones, with one Exchange node in each zone\. The file share witness is launched in the same Availability Zone as the first Exchange node\.

**Note**
Where possible, we recommend deploying the Exchange Server Quick Start using three Availability Zones\. This enables automatic failover of database availability groups \(DAGs\), without the need for manual intervention\.

You can deploy a full Exchange node instead of a file share witness\. In addition, you can specify whether to deploy the full node or the file share witness in a third Availability Zone\.

To learn more about Exchange DAGs and quorum models, see [TechNet – database availability groups](https://technet.microsoft.com/en-us/library/dd979799)\.

In addition, you can deploy an internal Application Load Balancer \(ALB\) to provide high availability and distribute traffic to the Exchange nodes\. In this configuration, you need to import a Secure Sockets Layer \(SSL\) certificate into AWS Certificate Manager \(ACM\), before you launch the template\.

## Architecture Overview<a name="architecture-overview"></a>

Deploying this Quick Start for a new VPC with **default parameters** builds the following Exchange Server environment in the AWS Cloud\.



![\[Exchange Server architecture on AWS\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/exchange-architecture.png)

**Figure 1: Exchange Server architecture on AWS **

You can also choose to build an architecture with three Availability Zones, as shown in Figure 2\.



![\[Exchange Server architecture with Edge nodes and three Availability Zones\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/exchange-architecture-3AZs.png)

**Figure 2: Exchange Server architecture with Edge nodes and three Availability Zones**

The Quick Start sets up the following:
+ A virtual private cloud \(VPC\) configured with public and private subnets across two Availability Zones\. This provides the network infrastructure for your Exchange Server deployment\. You can optionally choose a third Availability Zone for the file share witness or for an additional Exchange node, as shown in Figure 2\.\*
+ An internet gateway to allow access to the internet\.\*
+ In the public subnets, Windows Server–based Remote Desktop Gateway \(RD Gateway\) instances and network address translation \(NAT\) gateways for outbound internet access\.\*
+ Elastic IP addresses associated with the NAT gateway and RD Gateway instances\.\*
+ In the private subnets, Active Directory domain controllers\.\*
+ In the private subnets, Windows Server–based instances as Exchange nodes\.
+ Exchange Server Enterprise Edition on each node\. This architecture provides redundancy and a witness server to ensure that a quorum can be established\. The default architecture mirrors an on\-premises architecture of two Exchange Server instances spanning two subnets placed in two different Availability Zones, as shown in Figure 1\.
+ Security groups to enable the secure flow of traffic between the instances deployed in the VPC\.
+ \(Optional\) In the public subnets, Exchange Edge Transport servers for routing internet email in and out of your environment\.

\* The template that deploys the Quick Start into an existing VPC skips the tasks marked by asterisks and prompts you for your existing VPC configuration\.