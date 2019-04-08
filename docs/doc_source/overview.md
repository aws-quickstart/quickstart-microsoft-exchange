# Overview<a name="overview"></a>

## Microsoft Exchange Server on AWS<a name="exchange-server-on-aws"></a>

Microsoft Exchange Server is a messaging and collaboration solution with support for mailboxes, calendars, compliance, and e\-archival\. In an Exchange Server environment, your users can collaborate and—when you deploy the environment in AWS—you can scale your environment based on demand\. 

The AWS Cloud provides infrastructure services that enable you to deploy Exchange Server in a highly available, fault\-tolerant, and affordable way\. By deploying on AWS, you get the functionality of Exchange Server and the flexibility and security of AWS\.

In addition to this Quick Start, we’ve published a set of Microsoft\-based Quick Starts that you can use to deploy other common Microsoft workloads on AWS, such as the following:
+ Microsoft Active Directory
+ Remote Desktop Gateway \(RD Gateway\)
+ Microsoft SharePoint Server
+ Microsoft Lync Server
+ Microsoft SQL Server

Each of those Quick Starts includes a virtual private cloud \(VPC\) environment, which is deployed based on AWS best practices\. To read more about deploying Microsoft workloads by using our Quick Starts, see the Quick Starts in the [Microsoft Technologies category](https://aws.amazon.com/quickstart/#microsoft_technologies)\.

## Cost and Licenses<a name="licenses"></a>

You are responsible for all costs incurred by your use of the AWS services used while running this Quick Start reference deployment\. There is no additional cost for using the Quick Start\.

The template for this Quick Start includes configuration parameters that you can customize\. Some of these settings, such as instance type, will affect the cost of deployment\. For cost estimates, see the pricing pages for each AWS service you will be using\. Prices are subject to change\.

**Note**  
After you deploy the Quick Start, we recommend that you enable the [AWS Cost and Usage Report](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-gettingstarted-turnonreports.html) to track costs associated with the Quick Start\. This report delivers billing metrics to an Amazon Simple Storage Service \(Amazon S3\) bucket in your account\. It provides cost estimates based on usage throughout each month, and finalizes the data at the end of the month\. For more information about the report, see the [AWS documentation](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-reports-costusage.html)\.

Exchange Server can be deployed and licensed via the [Microsoft License Mobility through Software Assurance](https://aws.amazon.com/windows/mslicensemobility/) program\. For development and test environments, you can use your existing MSDN licenses for Exchange Server with Amazon Elastic Compute Cloud \(Amazon EC2\) Dedicated Instances\. For details, see the [MSDN on AWS](https://aws.amazon.com/windows/msdn/) page\.

This Quick Start deployment uses an evaluation copy of Exchange Server\. To upgrade your version, see the Microsoft Exchange Server website\.

This Quick Start launches the Amazon Machine Image \(AMI\) for Microsoft Windows Server 2012 R2 and Windows Server 2016, and includes the license for the Windows Server operating system\. The AMI is updated on a regular basis with the latest service pack for the operating system, so you don’t have to install any updates\. The Windows Server AMI doesn’t require client access licenses \(CALs\) and includes two Microsoft Remote Desktop Services licenses\. For details, see [Microsoft Licensing on AWS](https://aws.amazon.com/windows/resources/licensing/)\.

## AWS Services<a name="services"></a>

Before you deploy this Quick Start, we recommend that you become familiar with the following AWS services\. If you are new to AWS, see the [Getting Started](https://aws.amazon.com/getting-started/) section of the AWS documentation\.
+ [Amazon Virtual Private Cloud \(Amazon VPC\)](https://aws.amazon.com/documentation/vpc/) 
+ [Amazon Elastic Compute Cloud \(Amazon EC2\)](https://aws.amazon.com/documentation/ec2/) 
+ [Amazon Elastic Block Store \(Amazon EBS\)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html) 
+ [AWS CloudFormation](https://aws.amazon.com/documentation/cloudformation/)
+ [NAT Gateway](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html) 
+ [AWS Identity and Access Management \(IAM\)](https://aws.amazon.com/documentation/iam/) 
+ [Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/) 
+ [AWS Certificate Manager \(ACM\)](https://aws.amazon.com/documentation/acm/index.html#lang/en_us/)

In addition, you should be familiar with the following:
+ Windows Server 2012 R2 or Windows Server 2016
+ Microsoft Active Directory and Domain Name System \(DNS\)
+ Windows Server Failover Clustering \(WSFC\)
+ Exchange database availability groups \(DAGs\)

For information, see the Microsoft product documentation for these technologies\.