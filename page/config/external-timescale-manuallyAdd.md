---
layout: default
title: Manually Creating Users and Databases
---
For {{ site.data.vars.Product_Short }} to automatically create the required databases for 
Embedded Reports, the {{ site.data.vars.Product_Short }} cr.yaml file must specify credentials 
for a user account that has global R/W access to the DB service. To do this you can:

* Store the account credentials in Kubernetes Secrets, and then specify the secret wherever the
  cr.yaml file needs to refer to the user account. This is the recommended method. 
  (See Creating Secret Keys for DB Access.)
  
* Store the credentials in cleartext in the cr.yaml file.

If this is appropriate for your environment, then you can skip this section and go 
directly to [Editing the Platform CR File](external-timescale-editCr.html). That is 
where you will specify the global R/W account that Embedded Reports 
can use to access your TimescaleDB.

If neither of these methods are appropriate for your environment, then you must access 
the DB service with a R/W account and manually add the databases and user accounts that 
Embedded Reports can use. Then, after you have added the databases to your TimescaleDB, 
you will edit the {{ site.data.vars.Product_Short }} cr.yaml file to make use of these 
databases.

## Adding Databases and Users to TimescaleDB

The following steps will properly provision the database objects that Embedded Reporting requires.
Note that these examples use default names for illustration. You can substitute your own names 
for databases and users. If you do provide your own naming, you must be sure to match that 
naming as you edit the {{ site.data.vars.Product_Short }} cr.yaml file.

To provision the databases and users, open a command session on the TimescaleDB, and execute 
the following commands:
​
* Create two databases - one for `extractor` data, one for `grafana` data:  
  The extractor database manages the {{ site.data.vars.Product_Short }} data stream, and 
  the grafana database manages data for reporting within Grafana. 
  ```
  CREATE DATABASE extractor;
  CREATE DATABASE grafana;
  ```
* Create database users:  
  For the extractor database, you will create a R/W user, a read-only group, and read-only user. 
  You will also create a R/W user for the grafana database.
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
  Connect to the extractor database and execute these commands:
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
  Connect to the grafana database and execute these commands:
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

After you have provisioned the required database objects, you must edit the 
{{ site.data.vars.Product_Short }} cr.yaml file to make use of these 
databases. 

> **NOTE:** If you provided default names when you provisioned the 
> database objects, users, and user roles, then Embedded Reports will automatically 
> recognize those objects. You do not need to edit the cr.yaml file.
​

Here are the full set of properties that configure required names and passwords. Each is shown with 
the default that will be assumed if that particular property is left out, so if you're happy with 
those choices you can leave them out. (You will still be responsible for provisioning those objects). 
​

These properties are spread among the `/spec/properties/global/dbs`, `/spec/properties/extractor/dbs`
and `/spec/grafana/grafana.ini/database` blocks:
​
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
  grafana.ini:
    database:
      name: grafana
      user: grafana_backend
      password: <default-password>   
```
​
A few points on why this structure appears as it does:
​
* The `/spec/properties/global` block contains properties that will be visible to all Turbonomic
  components. Here we have names and password associated with a read-only login to a database owned
  by the `extractor` component. This login will be used by both the `extractor` and the `api`
  component, so rather than configure it for those two components specifically (and risk that they
  are not in agreement), we have placed them among global properties.
* Properties for the `extractor` database appear in a properties block that is referred to within
  the `extractor` component by the name `"dbs.extractor"`. Similarly, the internal name used for the
  `query` login to the same database is `"dbs.extractor.qeury"`. The common prefix means that the
  `databaseName` and `schemaName` properties will be visible and identical for these two logins.
* There's another database used by the `grafana` component, but provisioning responsibiltiy for that
  database falls to the `extractor` component as well, so its properties could be specified in the
  `/spec/properties/extractor/dbs/grafana` block. However, we only specify `schemaName` above. 
  The reason is that we must also provide these values to the `grafana` component via property names
  that are determined Grafana, not by us. We provide automatic copying of the database and login 
  names and the login password from the `/spec/grafna/grafana.ini` block to the 
  `/spec/properties/extractor/dbs/grafana` block, so they need (should) not be specified there.
* The grafana configuration has property to specify a schema name, so if you want to choose that
  you'll want to configure it in the `/spec/properties/extractor/dbs/grafana` block as shown above.
  The `grafana` component will not include a schema name in any of the SQL that it sends to the
  database, so as long as the grafana login's "search path" is set properly, everything will work.
  
### Other Recommended Settings
​
In addition to the above settings, the following are recommended but not required:
​
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
These properties have the following meanings:
​
* `shouldProvisionDatabase`: Determintes whether Turbonomic will attempt to provision any database
  in scope of the the definition. This is `true` by default for the Embedded Reporting databases
  in order to support the default behavior of provisioning all databases and users during initial
  startup.
* `shouldProvisionUser`: Determines whether Turbonomic will attempt to provision any logins in
  scope of the definition. This is `true` by default for Embedded Reporting logins in order to
  support the default behavior of provisioning all databases and users during initial startup.
* `destructiveProvisioningEnabled`: Determines whether, during its provisioning operations,
  Turbonomic will be allowed to perform destructive operations like dropping databases, schemas
  or users that are found to be mis-configured.  In the default installation scenario, the
  `public` schema that is created by PostgreSQL in any new database is dropped, to reduce the
  complexity of the overall model. Because this is considered a destructive operation, this option
  is `true` by default.
​
### Provisioning Requirements
​
The following operations will properly provision all database objects required by Embedded Reporting,
should you choose to take responsibility for that. We use the default names here for illustration;
please substitute your preferred names, matching what you have configured in your CR file.
​
* Create databases - one for `extractor` data, one for `grafana` data:
  ```
  CREATE DATABASE extractor;
  CREATE DATABASE grafana;
  ```
* Create database users:
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
  CREATE USER grafana_backend PASSWORD `<password>`;
  ```
* Create and prepare the schema for extractor data - must be you connected to extractor database
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
* Create and prepare the schema for grafana data - you must be connected to grafana database
  ```
  CREATE SCHEMA grafana;
  -- read/write user has full access
  GRANT ALL PRIVILEGES ON SCHEMA grafana TO grafana_backend;
  -- make sure the grafana user uses the grafana schema by default
  ALTER ROLE grafana_backend SET search_path TO 'grafana';
  ```
​