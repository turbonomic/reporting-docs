---
layout: default
title: Automatic Provisioning of Users and Databases
---

For {{ site.data.vars.Product_Short }} to automatically create the required databases for 
Embedded Reports, the {{ site.data.vars.Product_Short }} cr.yaml file must specify credentials 
for a user account that has global R/W access to the DB service. To do this you can 
Store the credentials in cleartext in the cr.yaml file.  

<!---
For {{ site.data.vars.Product_Short }} to automatically create the required databases for 
Embedded Reports, the {{ site.data.vars.Product_Short }} cr.yaml file must specify credentials 
for a user account that has global R/W access to the DB service. To do this you can:

* Store the account credentials in Kubernetes Secrets, and then specify the secret wherever the
  cr.yaml file needs to refer to the user account. This is the recommended method. 
  (See Creating Secret Keys for DB Access.)
  
* Store the credentials in cleartext in the cr.yaml file.  
-->

*If Automatic Provisioning is not appropriate for your environment*, then you must access 
the DB service with a R/W account and manually add the databases and user accounts that 
Embedded Reports can use. See [Manual Provisioning of Users and Databases](external-timescale-manuallyAdd.html).

To enable an external TimescaleDB for Embedded Reports, you must edit the 
{{ site.data.vars.Product_Short }} charts_v1alpha1_xl_cr.yaml file.

#### Open the .cr file for editing.
{% include OpenCrForEdit.html %}

#### Specify the endpoint for connecting to the external database.
For the connection endpoint, provide either the fully-qualified domain 
name of the external server or its IP address.  

Add the endpoint to the `spec/global/externalTimescaleDBIP` property in the 
cr.yaml file:  
```
spec:
...
  global:
    externalTimescaleDBIP: <host-or-IP>
```    

#### Specify the global R/W account that {{ site.data.vars.Product_Short }} will use to log into the TimescaleDB service.

This enables {{ site.data.vars.Product_Short }} to automatically create the 
databases, schemas, and uers that Embedded Reports requires.

> **NOTE:** You should only do this if you want to enable global RW access to the 
> TimescaleDB service in the cr.yaml file. You will specify the account credentials 
> in clear text. 
> 
> If you choose not to specify the global account here, then you must manually provision the 
> database objects that Embedded Reports requires. 
> See [Manual Provisioning of Users and Databases](external-timescale-manuallyAdd.html).


To grant the access {{ site.data.vars.Product_Short }} needs, specify the 
username and password for an account that has global R/W privileges on the 
TimescaleDB instance.  Add these credentials in 
the `/spec/properties/global/dbs/postgresDefault` block of the 
cr.yaml file, as follows:

```
spec:
  properties:
    global:
      dbs:
        postgresDefault:
          rootUserName: <root-user>
          rootPassword: <root-password>  
```
