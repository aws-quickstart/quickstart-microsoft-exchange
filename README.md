# quickstart-microsoft-exchange
## Microsoft Exchange Server on the AWS Cloud


This Quick Start deploys Microsoft Exchange Server 2013 automatically into a configuration of your choice on the AWS Cloud. The deployment includes Active Directory Domain Services (AD DS) for directory services, and Remote Desktop (RD) Gateway for remote administration over the Internet.

The default configuration deploys the minimal infrastructure required to run Exchange Server on AWS with high availability for 250 mailboxes. You can also align your environment to the Microsoft preferred architecture for 250 mailboxes (two Exchange servers per Availability Zone) or 2,500 mailboxes (four Exchange servers per Availability Zone).

The Quick Start offers two deployment options:

- Deploying Exchange Server into a new virtual private cloud (VPC) on AWS
- Deploying Exchange Server into an existing VPC on AWS

You can also use the AWS CloudFormation templates as a starting point for your own implementation.

![Quick Start architecture for Exchange Server on AWS](https://d0.awsstatic.com/partner-network/QuickStart/datasheets/exchange-architecture.png)

For architectural details, best practices, step-by-step instructions, and customization options, see the 
[deployment guide](https://fwd.aws/NvamP).

To post feedback, submit feature ideas, or report bugs, use the **Issues** section of this GitHub repo.
If you'd like to submit code for this Quick Start, please review the [AWS Quick Start Contributor's Kit](https://aws-quickstart.github.io/). 
