# quickstart-microsoft-exchange
## Microsoft Exchange Server on AWS

Amazon Web Services (AWS) provides a comprehensive set of services and tools for deploying Microsoft Windows-based workloads on its highly reliable and secure cloud infrastructure. This Quick Start implements a high availability solution built with Microsoft Windows Server and Microsoft Exchange Server running on Amazon Elastic Compute Cloud (Amazon EC2), using the Database Availability Groups (DAGs) feature of Exchange Server.

The deployment includes Windows Server Failover Clustering (WSFC) and Exchange Server 2016 or Exchange Server 2019 instances on the AWS Cloud. The Quick Start includes a rich set of configuration options for Exchange Server, Microsoft Active Directory, and the WSFC cluster, including Exchange Server version, tenancy options, and whether Edge instances or load balancers are created.

The AWS CloudFormation templates included with the Quick Start automate the following:

- Deploying Exchange Server into a new VPC
- Deploying Exchange Server into an existing VPC that includes Remote Desktop Gateway, NAT gateways, and Active Directory Domain Services

You can also use the AWS CloudFormation templates as a starting point for your own implementation.

![Quick Start architecture for Exchange Server on AWS](https://d0.awsstatic.com/partner-network/QuickStart/datasheets/exchange-architecture.png)

For architectural details, best practices, step-by-step instructions, and customization options, see the [deployment guide](https://fwd.aws/NvamP).

To post feedback, submit feature ideas, or report bugs, use the **Issues** section of this GitHub repo.
If you'd like to submit code for this Quick Start, please review the [AWS Quick Start Contributor's Kit](https://aws-quickstart.github.io/).
