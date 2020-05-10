# Step 1\. Prepare Your AWS Account<a name="step-1"></a>

****

1. If you don't already have an AWS account, create one at [http://aws\.amazon\.com](https://aws.amazon.com/) by following the on\-screen instructions\.

1. Use the region selector in the navigation bar to choose the AWS Region where you want to deploy the infrastructure for Exchange Server on AWS\. If you’re planning to use a third Availability Zone for a file share witness instance or a third Exchange Server node, choose an AWS Region that includes three or more Availability Zones; see [AWS Global Infrastructure](https://aws.amazon.com/about-aws/global-infrastructure/) for a list\.

1. Create a [key pair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) in your preferred region\.

1. If necessary, [request a service limit increase](https://console.aws.amazon.com/support/home#/case/create?issueType=service-limit-increase) for the Amazon EC2 **r4\.2xlarge** instance type\. You might need to do this if you already have an existing deployment that uses this instance type, and you think you might exceed the [default limit](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-resource-limits.html) with this deployment\.