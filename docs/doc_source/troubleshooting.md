# Troubleshooting<a name="troubleshooting"></a>

**Q\.** I encountered a **CREATE\_FAILED** error when I launched the Quick Start\.

**A\.** If AWS CloudFormation fails to create the stack, we recommend that you relaunch the template with **Rollback on failure** set to **No**\. \(This setting is under **Advanced** in the AWS CloudFormation console, **Options** page\.\) With this setting, the stack’s state will be retained and the instance will be left running, so you can troubleshoot the issue\. \(You'll want to look at the log files in `%ProgramFiles%\Amazon\EC2ConfigService` and `C:\cfn\log`\.\)

**Important**
When you set **Rollback on failure** to **No**, you'll continue to incur AWS charges for this stack\. Please make sure to delete the stack when you've finished troubleshooting\.

The following table lists specific CREATE\_FAILED error messages you might encounter\.


| CREATE\_FAILED error message | Possible cause | What to do |
| --- | --- | --- |
| API: ec2: RunInstances Not authorized for images: ami\-ID | The template is referencing an AMI that has expired | We refresh AMIs on a regular basis, but our schedule isn’t always synchronized with AWS AMI updates\. If you get this error message, notify us, and we’ll update the template with the new AMI ID\. You can also download the template and update the mappings in `AWSWinRegionMap` with the latest AMI ID for your region\. |
| We currently do not have sufficient r4\.2xlarge capacity in the AZ you requested | One of the instances requires a larger instance type | If you get an InsufficientInstanceCapacity error \(ICE\), AWS might not have enough on\-demand capacity for the selected instance type\. Switch to a different instance type \(such as m4\.xlarge, r4\.xlarge\), use different Availability Zones if possible, or retry in a few minutes\.  |
| Instance ID did not stabilize | You have exceeded your IOPS for the region | Request a limit increase by completing the [request form](https://console.aws.amazon.com/support/home#/case/create?issueType=service-limit-increase&limitType=service-code-) in the AWS Support Center\.  |
| System Administrator password must contain at least 8 characters | The master password contains $ or other special characters | Change the password for the RestoreModePassword or DomainAdminPassword parameter and then relaunch the Quick Start\. You must use a [complex password](https://technet.microsoft.com/en-us/library/hh994562.aspx) that is at least 8 characters long, consisting of uppercase and lowercase letters and numbers\. Avoid using special characters such as @ or $\. |

For additional information, see [Troubleshooting AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/troubleshooting.html) on the AWS website\.

**Q\.** I encountered a size limitation error when I deployed the AWS Cloudformation templates\.

**A\.** We recommend that you launch the Quick Start templates from the location we’ve provided or from another S3 bucket\. If you deploy the templates from a local copy on your computer or from a non\-S3 location, you might encounter template size limitations when you create the stack\. For more information about AWS CloudFormation limits, see the [AWS documentation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cloudformation-limits.html)\.