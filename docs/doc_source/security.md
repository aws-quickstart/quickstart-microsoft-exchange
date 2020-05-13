# Security<a name="security"></a>

AWS provides a set of building blocks \(for example, Amazon EC2 and Amazon VPC\) that you can use to provision infrastructure for your applications\. In this model, some security capabilities, such as physical security, are the responsibility of AWS and are highlighted in the AWS security whitepaper\. Other areas, such as controlling access to applications, fall on the application developer and the tools provided in the Microsoft platform\.

This Quick Start configures the following security groups for Exchange Server:


****

| Security group | Associated with | Inbound source | Ports |
| --- | --- | --- | --- |
| DomainMemberSGID | Exchange nodes, FileServer, RD Gateway, Domain controllers | VPC CIDR | Standard AP ports |
| EXCHClientSecurityGroup | Exchange nodes, FileServer  | VPC CIDR |  25, 80, 443, 143, 993, 110, 995, 587  |
| ExchangeSecurityGroup | Exchange nodes | ExchangeSecurityGroup | All ports |
| EXCHEdgeSecurityGroup | EXCHEdgeSecurityGroup |  Private subnets CIDR 0\.0\.0\.0/0  |  50636 25  |
| LoadBalancerSecurityGroup | Load balancer | 0\.0\.0\.0/0 | 0\.0\.0\.0/0 |