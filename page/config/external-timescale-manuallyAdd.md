---
layout: default
title: Manual Provisioning of Users and Databases
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


If Automatic Provisioning is appropriate for your environment, then you can skip this section and go 
directly to [Automatic Provisioning of Users and Databases](external-timescale-autoProvision.html). That is 
where you will specify the global R/W account that Embedded Reports 
can use to access your TimescaleDB.

*If Automatic Provisioning is not appropriate for your environment*, then you must access 
the DB service with a R/W account and manually add the databases and user accounts that 
Embedded Reports can use. Then, after you have added the databases to your TimescaleDB, 
you will edit the {{ site.data.vars.Product_Short }} cr.yaml file to make use of these 
databases.

## Manually Provisioning Databases and Users on the TimescaleDB

The following steps will properly provision the database objects that Embedded Reporting requires.
Note that these examples use default names for illustration. You can substitute your own names 
for databases and users. You must remember the names you use, because you must match that 
naming as you edit the {{ site.data.vars.Product_Short }} cr.yaml file.

To provision the databases and users, open a command session on the TimescaleDB, and execute 
the following commands:
​
* Create two databases - one for `extractor` data, one for `grafana` data:  
  The extractor database manages the {{ site.data.vars.Product_Short }} data stream, and 
  the grafana database manages data for reporting within Grafana. 
  
  Execute the following 
  commands, where you can provide your own database names instead of `extractor` and `grafana`:
  ```
  CREATE DATABASE extractor;
  CREATE DATABASE grafana;
  ```
* Create database users:  
  For the extractor database, you will create a R/W user, a read-only group, and read-only user. 
  You will also create a R/W user for the grafana database. 
  
  Execute the following commands, where you can provide your own names for instances of
  `USER` or `ROLE`: 
  ```
  -- main read/write user for extractor data
  CREATE USER extractor PASSWORD '<password>';
  -- group for users with read-only access to extractor data
  CREATE ROLE readers_extractor_extractor;
  -- read-only user for extractor data as a member of that group
  CREATE USER query PASSWORD '<password>';
  GRANT CONNECT ON DATABASE extractor TO readers_extractor_extractor;
  GRANT readers_extractor_extractor TO query;
  -- read-write user for grafana data
  CREATE USER grafana_backend PASSWORD '<password>';
  ```
* Create and prepare the schema for extractor data  
  Connect to the extractor database and execute these commands, where you can provide your own name for 
  the `SCHEMA`, and you grant privileges to the users and roles you created above:
  ```
  CREATE SCHEMA extractor;
  -- read/write user has full access
  GRANT ALL PRIVILEGES ON SCHEMA extractor TO extractor;
  -- all users in readers group have read-only access
  GRANT USAGE on SCHEMA extractor TO readers_extractor_extractor;
  GRANT SELECT ON ALL TABLES IN SCHEMA extractor TO readers_extractor_extractor;
  -- make sure readers get access to any tables added in the future
  ALTER DEFAULT PRIVILEGES IN SCHEMA extractor GRANT SELECT ON TABLES TO readers_extractor_extractor;
  -- make the extractor and query users use the extractor schema by default
  ALTER ROLE extractor SET search_path TO `extractor`;
  ALTER ROLE query SET search_path TO `extractor`;
  -- install the timescaledb plugin into the extractor database using the extractor schema
  CREATE EXTENSION timescaledb SCHEMA extractor;
  ```
* Create and prepare the schema for grafana data  
  Connect to the grafana database and execute these commands, where you can provide your own name for 
  the `SCHEMA`, and you grant privileges to the users and roles you created above:
  ```
  CREATE SCHEMA grafana;
  -- read/write user has full access
  GRANT ALL PRIVILEGES ON SCHEMA grafana TO grafana_backend;
  -- make sure the grafana user uses the grafana schema by default
  ALTER ROLE grafana_backend SET search_path TO 'grafana';
  ```

The above commands provision the required databases and users. Your provisioning must be 
complete and correct for Embedded Reports to properly collect data and display it 
in Grafana reports and dashboards. 


## Editing the CR File for Manually Created Databases

After you have provisioned the required database objects, you should edit the 
{{ site.data.vars.Product_Short }} cr.yaml file to make use of these 
databases. For editing tips, see [YAML File Editing Tips](../appendix/yamlTips.html).

To edit the cr.yaml file:

#### Open the .cr file for editing.
{% include OpenCrForEdit.html %}


#### Specify the endpoint for connecting to the external database.
You can use the database service DNS, or you can use an IP address. 

Add the endpoint as the `externalTimescaleDBIP` property in the `spec: global:` 
section of the .cr file:  
```
spec:
  global:
    externalTimescaleDBIP: <host-or-IP>
```    



#### Specify {{ site.data.vars.Product_Short }} access the databases you provisioned
As you specify users and databases, be sure to match the names you used above 
to provision users, databases, and schema. These instructions use the default 
naming that you can see above.

You will specify:
* Global read-only access to the `extractor` database  
  `/spec/properties/global/dbs`  
  This grants the `extractor` and the `api` components read-only access to 
  the `extractor` database that you provisioned above. Those components will use the 
  `query` user account.
* Read/write access to the `extractor` and `grafana` databases  
  `/spec/properties/extractor/dbs`
  This grants the `extractor` component read/write access to the 
   `extractor` and `grafana` databases that you provisioned above.
* Read/write access for Grafana to access the `grafana` database  
  `/spec/grafana/grafana.ini/database`  
​

Edit the cr.yaml file to add the following entries:

```
spec:
  properties:
    global:
      dbs:
        extractor:
          databaseName: extractor
          schemaName: extractor
          query:
            userName: query
            password: <defaault-password>
    extractor:
      dbs:
        extractor:        
          userName: extractor
          password: <default-password>
        grafana:
          scehamName: grafana
  grafana:
    grafana.ini:
      database:
        name: grafana
        user: grafana_backend
        password: <default-password>
```
​
  
#### (Recommended) Block automatic provisioning by {{ site.data.vars.Product_Short }} on the TimescaleDB
​
If you have manually provisioned the Embedded Reports objects on the TimescaleDB instance, 
then you should disable the options for {{ site.data.vars.Product_Short }} to 
automatically execute provisioning on the TimescaleDB instance. 

> **NOTE:** that {{ site.data.vars.Product_Short }} cannot provision on the TimescaleDB instance 
> if you do not specify a global user account. If you performed these configuration steps, 
> then you should not have done so. But we still recommend that you disable the options to 
> execute provisioning.

Set the following properties to `false`:


* `shouldProvisionDatabase`:  
  `spec/properties/global/dbs/postgresDefault/shouldProvisionDatabase`
  Determintes whether {{ site.data.vars.Product_Short }} will attempt to provision any database
  in scope of the the definition. 
* `shouldProvisionUser`:
  `spec/properties/global/dbs/postgresDefault/shouldProvisionUser`
  Determines whether {{ site.data.vars.Product_Short }} will attempt to provision any logins in
  scope of the definition. 
* `destructiveProvisioningEnabled`:
  `spec/properties/global/dbs/postgresDefault/destructiveProvisioningEnabled`
  Determines whether, during its provisioning operations,
  {{ site.data.vars.Product_Short }} can perform destructive operations like 
  dropping databases, schemas or users that are found to be mis-configured.  In the default installation scenario, the
  `public` schema that is created by PostgreSQL in any new database is dropped, to reduce the
  complexity of the overall model. Because this is considered a destructive operation, this option
  is `true` by default.  
​

Edit the cr.yaml file to add the following properties:

```
spec:
  properties:
    global:
      dbs:
        postgresDefault:
            shouldProvisionDatabase: false
            shouldProvisionUser: false
            destructiveProvisioningEnabled: false
```
​
Placing these settings in the `/spec/properties/global/dbs/postgresDefault` block ensures that
they will apply to all PostgreSQL databases and users used by any Turbonomic component. If your
pre-provisioning is more selective than that, you can move the settings to more narrowly targeted
property blocks like `/spec/properties/extractor/dbs/grafana` or 
`/spec/properties/global/dbs/extractor`.
​