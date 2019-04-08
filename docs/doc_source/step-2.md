# Step 2\. Launch the Quick Start<a name="step-2"></a>

**Note**  
You are responsible for the cost of the AWS services used while running this Quick Start reference deployment\. There is no additional cost for using this Quick Start\. For full details, see the pricing pages for each AWS service you will be using in this Quick Start\.

****

1. Choose one of the following options to launch the AWS CloudFormation template into your AWS account\. For help choosing an option, see [Deployment Options](scenarios.md) earlier in this guide\.  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)
**Important**  
If you’re deploying Exchange Server into an existing VPC, make sure that your VPC has at least two private subnets in different Availability Zones\. These subnets require [NAT gateways or NAT instances](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat.html) in their route tables, to allow the instances to download packages and software without exposing them to the internet\. You will also need the domain name option configured in the DHCP options as explained in the [Amazon VPC documentation](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_DHCP_Options.html)\. You will be prompted for your VPC settings when you launch the Quick Start\.

   Each deployment takes about 90 minutes to complete\.

1. Check the region that’s displayed in the upper\-right corner of the navigation bar, and change it if necessary\. This is where the network infrastructure for Exchange Server will be built\. The template is launched in the US West \(Oregon\) Region by default\.

1. On the **Select Template** page, keep the default setting for the template URL, and then choose **Next**\.

1. On the **Specify Details** page, change the stack name if needed\. Review the parameters for the template\. Provide values for the parameters that require your input\. For all other parameters, review the default settings and customize them as necessary\. When you finish reviewing and customizing the parameters, choose **Next**\.

    In the following tables, parameters are listed by category and described separately for the two deployment options: 
   + [Parameters for deploying Microsoft Exchange Server into a new VPC](#new)
   + [Parameters for deploying Microsoft Exchange Server into an existing VPC](#existing-standalone)

   

   **Option 1: Parameters for deploying Microsoft Exchange Server into a new VPC**

   [View template](https://fwd.aws/BreXn)

   *VPC Network Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Amazon EC2 Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Microsoft Active Directory Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Remote Desktop Gateway Configuration*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Microsoft Exchange Server Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   **Load Balancer Configuration*:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Failover Cluster Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *AWS Quick Start Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   

   **Option 2: Parameters for deploying Microsoft Exchange Server into an existing VPC**

   [View template](https://fwd.aws/57W4z)

   *VPC Network Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Amazon EC2 Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Microsoft Active Directory Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Exchange Server Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   **Load Balancer Configuration*:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *Failover Cluster Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

   *AWS Quick Start Configuration:*  
****    
[\[See the AWS documentation website for more details\]](http://docs.aws.amazon.com/quickstart/latest/exchange/step-2.html)

1. On the **Options** page, you can [specify tags](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-resource-tags.html) \(key\-value pairs\) for resources in your stack and [set advanced options](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-add-tags.html)\. When you're done, choose **Next**\.

1. On the **Review** page, review and confirm the template settings\. Under **Capabilities**, select the check box to acknowledge that the template will create IAM resources\.

1. Choose **Create** to deploy the stack\. Monitor the status of the stack\. When the status is **CREATE\_COMPLETE**, the deployment is ready\.