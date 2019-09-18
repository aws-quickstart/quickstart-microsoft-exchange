# Implementation Details<a name="design-ha"></a>

## Storage on the Exchange Nodes<a name="regions"></a>

Storage capacity and performance are key aspects of any production installation\. Although capacity and performance vary from one deployment to the next, this Quick Start provides a reference configuration that you can use as a starting point\. The AWS CloudFormation template deploys the Exchange nodes using the memory\-optimized r4\.2xlarge instance type by default\.

To provide highly performant and durable storage, we’ve also included Amazon EBS volumes in this reference architecture\. EBS volumes are network\-attached disk storage, which you can create and attach to EC2 instances\. Once these are attached, you can create a file system on top of these volumes, run a mailbox database, or use them in any other way you would use a block device\. EBS volumes are placed in a specific Availability Zone, where they are automatically replicated to protect you from the failure of a single component\.

Provisioned IOPS EBS volumes offer storage with consistent and low\-latency performance\. They are backed by solid state drives \(SSDs\) and are designed for applications with I/O\-intensive workloads such as databases\.

Amazon EBS\-optimized instances, such as the R4 instance type, deliver dedicated throughput between Amazon EC2 and Amazon EBS\. The dedicated throughput minimizes contention between Amazon EBS I/O and other traffic from your Amazon EC2 instance, and provides the best performance for your EBS volumes\. 

By default, on each Exchange node, the Quick Start deploys three 500\-GiB General Purpose \(GP2\) SSD volumes to store mailbox databases and transaction logs\. This is in addition to the root General Purpose SSD volume used by the operating system\. This volume type delivers a consistent baseline of 3 IOPS/GiB, which provides a total of 1,500 IOPS per volume for Exchange database and transaction log volumes\. You can customize the volume size, and you can switch to using dedicated IOPS volumes\. 

If you need more IOPS per volume, consider using Provisioned IOPS SSD volumes by changing the **Exchange Server Volume Type **and **Exchange Server Volume IOPS **parameters, or use disk striping within Windows\.

The default disk layout in this Quick Start uses the following EBS volumes: 
+ One General Purpose SSD volume \(100 GiB\) for the operating system \(C:\)
+ One General Purpose SSD volume \(500 GiB\) to host the Exchange Server database files \(D:\) 
+ One General Purpose SSD volume \(500 GiB\) to host the Exchange Server transaction log files \(E:\)

Figure 3 shows the disk layout on each Exchange Server node\. 

![\[Disk layout on Exchange Server node\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/disk-layout.png)

**Figure 3: Disk layout on Exchange Server node**

**Note**  
 You’ll find the installation software on each node in the **C:\\Exchangeinstall folder**\. Depending on the instance type selected, you might see additional drives for instance store \(ephemeral\) volumes such as \(Z:\)\. Data on instance storage will be lost when you stop your EC2 instance\. 

## IP Addresses on the Exchange Nodes<a name="ad-ds"></a>

In this configuration, each Exchange node instance in the cluster needs two IP addresses assigned:
+ One IP address is used as the primary IP address for the instance\.
+ A second IP address acts as the Failover Cluster IP resource\.

When you launch the AWS CloudFormation template, you can specify the addresses for each node, as shown in Figure 4\. By default, the 10\.0\.0\.0/19, 10\.0\.32\.0/19, and 10\.0\.64\.0/19 CIDR blocks are used for the private subnets\.

![\[Configuring IP addresses on the Exchange Server node\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/configuring-ip-addresses.png)

**Figure 4: Configuring IP addresses on the Exchange Server node**

## Database Availability Group<a name="database-availability-group"></a>

A failover cluster is automatically created for the database availability group \(DAG\)\. The AWS CloudFormation templates carry out this task when deploying the second node\. If you use the default parameter settings in the template, the Quick Start runs the following Windows PowerShell commands to complete this task:

```
Install-WindowsFeature failover-clustering –IncludeManagementTools

New-DatabaseAvailabilityGroup -Name DAG -WitnessServer FileServer 
                              -WitnessDirectory C:\DAG

Add-DatabaseAvailabilityGroupServer -Identity DAG 
                                    -MailboxServer ExchangeNode1


Add-DatabaseAvailabilityGroupServer -Identity DAG 
                                    -MailboxServer ExchangeNode2
```

**Note**  
By default, the database availability group is created with the name DAG\. To change this value, modify the DAGName default parameter value in the Configure\-ExchangeDAG\.ps1 file\. 

The first command runs on each instance during the bootstrapping process\. It installs the required components and management tools for the failover clustering services\. The rest of the commands run near the end of the bootstrapping process on the second node and are responsible for creating the cluster and for defining the server nodes and IP addresses\. 

By default, the Quick Start configures an even number of servers in the cluster\. You need a third resource to maintain a majority vote to keep the cluster online if an individual server fails\. For this, the Quick Start uses a dedicated file share witness instance, which can be either a domain\-joined server or a third Exchange node \(which cannot be part of the DAG itself\)\. By default, the Quick Start creates a Dedicated Instance in the first Availability Zone to act as the file share witness\. For production environments, you can also set the Third AZ parameter to witness to create a Dedicated Instance with a file share in a third Availability Zone\. 

Alternatively, you can use any domain\-joined server for this task\. \(This isn’t included in the Quick Start\.\) If you set the Third AZ parameter to full, the Quick Start keeps the quorum settings to the default node majority and creates a third Exchange Server node in the third Availability Zone\. Note that some AWS Regions support only two Availability Zones; for a current list, see AWS Global Infrastructure\. 

The Quick Start automated solution ends after creating the DAG and adding the two Exchange nodes to the DAG\. When the deployment is complete, you can create additional databases and make them highly available by creating copies on the second nodes\. This process is covered in step 3 of the [Deployment Steps](deployment.md)instructions\. 

## Edge Transport Nodes<a name="edge-transport-nodes"></a>

Edge Transport nodes relay inbound and outbound emails and provide smart host services within the Exchange organization\. The Edge nodes are installed in the public subnets and aren’t domain\-joined\. They do, however, require information from Active Directory, and configuring an Edge sync subscription is needed\.

Because Edge Transport role nodes aren’t required for end\-to\-end mail flow, by default, Edge nodes aren’t deployed\. For this to occur, you must select **yes** on the **Deploy Edge servers** launch option, as shown in Figure 5\. 

![\[Deploying Edge servers\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/edge-servers.png)

**Figure 5: Deploying Edge servers**

A pair of Edge servers is deployed in the public subnets \(which must be defined\), and the Exchange Server Edge Transport role is installed using default settings\. The EC2 instances aren’t domain\-joined, but the DNS suffix that corresponds to the domain name is configured on the network interface cards \(NICs\)\. Also, DNS records are created in Active Directory corresponding to their hostname\. 

The Local Administrator password is reset to the Domain Admin password, and an Edge subscription file is created, which can be found in C:\\EdgeServerSubscription\.xml\. 

Copy the subscription file to a mailbox server, and import the subscription by running the following command: 

```
New-EdgeSubscription -FileData ([byte[]]$(Get-Content -Path "C:\EdgeServerSubscription.xml" -Encoding Byte -ReadCount 0)) -Site "AZ1"
```

## Load Balancer<a name="load-balancer"></a>

Exchange servers running with the Client Access/Transport roles are usually situated behind a network load balancer \(NLB\) with a unified Exchange namespace such as “mail\.example\.com\.” The namespace resolves to the load balancer, which in turns distributes traffic to the Exchange servers\. 

The Exchange Server Quick Start contains an option to deploy an Application Load Balancer that distributes the traffic to the Exchange nodes\.

By default, the load balancer isn’t deployed because it requires an existing SSL certificate to be imported in AWS Certificate Manager\. 

For a load balancer to be deployed, you must:

****

1. Import or generate a certificate in AWS Certificate Manager\. 

1. Specify the full Amazon Resource Name \(ARN\) in the CertificateARN option\.

1. Select **true** in **Deploy Load Balancer**, when you launch the Quick Start\. 

## Volume Encryption<a name="volume-encryption"></a>

As part of the default setup, the Exchange Server Quick Start creates and attaches two EBS volumes to each Exchange node\. One EBS volume \(corresponding to the D:\\ drive\) holds the Exchange mailbox databases, while the other EBS volume \(E:\\\) holds the Exchange transaction logs\. Optionally, the Quick Start provides an option to encrypt the EBS volumes with either the default AWS Key Management Service \(AWS KMS\) encryption key or a custom KMS key, as shown in Figure 6\. 

![\[IEncrypting the EBS volumes\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/encrypting-ebs-volumes.png)

**Figure 6: Encrypting the EBS volumes **

**Note**  
The root volume of the Exchange nodes \(C:\\\) isn’t encrypted, if **Encrypt data volumes **is selected\.