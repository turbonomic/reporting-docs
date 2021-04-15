---
layout: default
title: Creating an External TimescaleDB
---

You can create an external TimescaleDB service that you host in your environment, 
or you can use an existing TimescaleDB service that has been deployed on the cloud 
or in your enterprise by the DB Management team. 

The TimescaleDB service that {{ site.data.vars.Product_Short }} uses must satisfy 
these conditions:

* Deployment  
  The TimescaleDB is a PostgreSQL server with the TimescaleDB extension. It must be 
  deployed in a way that is accessible to your installation of Turbonomic. It can be 
  deployed on the cloud or in an on-prem VM. 
  
  For information about installing Timescale, see the article: 
  [https://docs.timescale.com/v2.0/getting-started/installation](https://docs.timescale.com/v2.0/getting-started/installation).
  
* Supported Version  
  The Embedded Reports feature currently supports PostgreSQL 12.x and TimescaleDB 2.0.1.
  
* An account with global R/W privileges on the TimescaleDB instance  
  The Embedded Reports feature requires a specific set of databases to be created on the TimescaleDB. 
  It is typical practice for an administrator to manually create the necessary databases. Alternatively, 
  you can create a global R/W user account for the {{ site.data.vars.Product_Short }} platform so it 
  can create the databases automatically.
  
* Entry Point  
  The TimescaleDB must provide an entry point via DNS Name or IP Address that you can 
  access from {{ site.data.vars.Product_Short }}. You will configure this access in the 
  {{ site.data.vars.Product_Short }} cr.yaml file.
  

To create the TimescaleDB:

1. Install the DB package.  
  For information about installing Timescale, see the articls: 
  [https://docs.timescale.com/v2.0/getting-started/installation](https://docs.timescale.com/v2.0/getting-started/installation).
2. Create a global R/W user account that can be used to create databases on the DB service.  
  Launch the DB service and open a command session. Then create the global R/W account.  
  You can alternatively set credentials to this account in the {{ site.data.vars.Product_Short }} 
  cr.yaml file. You can enter them as cleartext, or you can manage the credentials via Kubernetes 
  Secrets. If you set the account credentials in cr.yaml, {{ site.data.vars.Product_Short }} 
  can create the databases that the Embedded Reports feature needs. 
3. (OPTIONAL) Manually create the users and databases that Embedded Reports will use.  
   If you cannot grant {{ site.data.vars.Product_Short }} global R/W access to the DB, you must 
   manually create the databases and users for Embedded Reports. See 
   [Manually Creating Users and Databases](external-timescale-manuallyAdd.html). 
   

