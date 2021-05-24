---
layout: default
title: Configuring an External TimescaleDB
---

Beginning with {{ site.data.vars.Product_Short }} 8.1.4, you can configure 
External Reports to use an external deployment of TimescaleDB. To enable an 
external deployment, you will:

* Deploy or access the external TimescaleDB instance that you will use.
  
  This is a PostgreSQL server with the TimescaleDB extension. The DB server 
  must be deployed in a way that is accessible to your installation of {{ site.data.vars.Product_Short }}.
  It can be deployed on the cloud or in an on-prem VM. 
  The Embedded Reports feature currently supports PostgreSQL 12.x and TimescaleDB 2.0.1.
  
  For information about installing Timescale, see the article: 
  [https://docs.timescale.com/v2.0/getting-started/installation](https://docs.timescale.com/v2.0/getting-started/installation)

* Provision users, databases, and schemas on the TimescaleDB instance  
  To provision these database objects you can manually provision or 
  enable {{ site.data.vars.Product_Short }} to automatically provision.  
  For more information, see:
  * [Manual Provisioning of Users and Databases](external-timescale-manuallyAdd.html)
  * [Automatic Provisioning of Users and Databases](external-timescale-autoProvision.html)  
  
* Edit properties in the {{ site.data.vars.Product_Short }} cr.yaml file.  
  Note that the location of the cr.yaml file is different, depending on whether you 
  are configuring an OVA installation or a Kubernetes Node installation of 
  {{ site.data.vars.Product_Short }}.
  
* Optionally, enable secure connections between {{ site.data.vars.Product_Short }} and the Timescale DB instance  
  For information about enabling TLS/SSL for database connections, see the PostgreSQL 
  documentation [here](https://www.postgresql.org/docs/12/ssl-tcp.html).  
  
  We have verified that the steps tp to create a self-signed certificate, as outlined in that document, 
  produce a server that functions properly with all components of Embedded Reporting. However, we 
  do not recommend using self-signed certificates in production instances.


To configure External Reports to use an external deployment of TimescaleDB, you 
must edit the {{ site.data.vars.Product_Short }} cr.yaml file. For tips about editing yaml files, 
see [YAML File Editing Tips](../appendix/yamlTips.html).

​