# Step 4\. \(Optional\) Create a DNS Entry for the Load Balancer<a name="step-4"></a>

****

1. If you chose the option to deploy a load balancer, the Application Load Balancer \(ALB\) will have an endpoint address such as \[elb\.amazonaws\.com\]\.

1. To use the load balancer with your Exchange namespace, create a CNAME record in Active Directory that points to the ALB\.

1. Before proceeding, go to the [Amazon EC2 console](https://console.aws.amazon.com/ec2/v2/home) and, under **Load balancer** , select the load balancer that the Quick Start created\.

1. Copy the value listed under the DNS name, as shown in Figure 7\.
![\[Creating a DNS entry for the load balancer\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/creating-dns-entry.png)

   **Figure 7: Creating a DNS entry for the load balancer**

1. To create the DNS record, connect using Remote Desktop to one of the domain controllers using domain credentials, and open the DNS console by going to the Start menu and typing “DNS”\.

1. In the DNS console, navigate to the Active Directory zone, right\-click, and select New Alias \(CNAME\), as shown in Figure 8\.
![\[Selecting New Alias (CNAME)\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/new-alias-cname.png)

   **Figure 8: Selecting New Alias \(CNAME\)**

1. Create the DNS entry such as “mail” and in fully qualified domain name \(FQDN\) for target host, paste the value of the Application Load Balancer endpoint, as shown in Figure 9\.
![\[Creating the DNS entry\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/dns-entry-mail.png)

   **Figure 9: Creating the DNS entry**

1. Verify that the DNS entry is resolved successfully by performing an nslookup\. Go to Start and type “cmd”\. In the command line window, type the following:

   ```
   Nslookup mail.example.com
   ```

   Where mail is the name of the CNAME record you created, and “mydomain\.example” is your Active Directory domain name\.

1. In the DNS console, navigate to the Active Directory zone, right\-click, and select New Alias \(CNAME\), as shown in Figure 10\.
![\[Verifying the DNS record\]](http://docs.aws.amazon.com/quickstart/latest/exchange/images/verifying-dns-record.png)

   **Figure 10: Verifying the DNS record**