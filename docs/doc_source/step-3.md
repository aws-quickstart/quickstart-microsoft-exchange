# Step 3\. \(Optional\) Create Database Copies<a name="step-3"></a>

The Quick Start creates a database availability group \(DAG\) and adds the Exchange nodes to the DAG\. As part of the Exchange installation, each Exchange node contains a mailbox database\. The first node contains a database called DB1, and the second node contains a database called DB2\.

As part of configuring high availability for the mailbox roles, you can add mailbox database copies on the other Exchange nodes\. Or you can create entirely new databases and only then create additional copies\.

To create a second copy for the initial databases, use the following commands:

```
Add-MailboxDatabaseCopy -Identity DB1 –MailboxServer ExchangeNode2 -ActivationPreference 2

Add-MailboxDatabaseCopy -Identity DB2 –MailboxServer ExchangeNode1 -ActivationPreference 2
```