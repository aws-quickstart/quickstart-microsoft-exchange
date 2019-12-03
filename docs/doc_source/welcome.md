# Microsoft Exchange Server on the AWS Cloud: Quick Start Reference Deployment<a name="welcome"></a>

**Deployment Guide**

*AWS Quick Start team*

*January 2015  \([last update](revisions.md): October 2018\)*

This Quick Start reference deployment guide includes infrastructure information, architectural considerations, and configuration steps for planning and deploying a Microsoft Exchange Server environment on the Amazon Web Services \(AWS\) Cloud\. It uses [AWS CloudFormation](https://aws.amazon.com/cloudformation/) templates to automate the deployment\.

**Note**  
 This Quick Start supports Exchange Server 2016 and Exchange Server 2019\. 

This Quick Start is for IT infrastructure architects, administrators, and DevOps professionals who are planning to implement or extend their Exchange Server workloads on the AWS Cloud\.

Included are best practices for configuring a highly available, fault\-tolerant, and secure Exchange environment\. This guide doesn’t cover general installation and software configuration tasks for Exchange Server\. For general guidance and best practices, consult the [Microsoft Exchange Server documentation](https://docs.microsoft.com/en-us/Exchange/exchange-server?view=exchserver-2019)\.

The following links are for your convenience\. Before you launch the Quick Start, please review the architecture, configuration, network security, and other considerations discussed in this guide\.
+  If you have an AWS account and you're already familiar with Microsoft Exchange and AWS, you can launch the Quick Start to deploy Exchange Server 2016 or Exchange Server 2019 into a new or existing virtual private cloud \(VPC\) in your AWS account\. The deployment takes approximately 90 minutes\. 

   

   [ ![\[Image NOT FOUND\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/launch-button-new.png) ](https://fwd.aws/MqvGy)       [ ![\[Image NOT FOUND\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/launch-button-existing.png) ](https://fwd.aws/xq5Mx) 

   
+  If you'd like to take a look under the covers, you can view the AWS CloudFormation templates that automate this deployment\. 

   

   [ ![\[Image NOT FOUND\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/view-template-new.png) ](https://fwd.aws/BreXn)       [ ![\[Image NOT FOUND\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/view-template-existing.png) ](https://fwd.aws/57W4z) 

**Note**  
You are responsible for the costs related to your use of any AWS services used while running this Quick Start reference deployment\. See the pricing pages of the AWS services you will be using for full details\.

## About Quick Starts<a name="about"></a>

This Quick Start was developed by Amazon Web Services \(AWS\) solutions architects\.

[Quick Starts](https://aws.amazon.com/quickstart/) are automated reference deployments that use AWS CloudFormation templates to deploy key technologies on AWS, following AWS best practices\.