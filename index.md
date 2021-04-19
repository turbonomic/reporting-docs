---
layout: default
title: Embeded Reporting Schema and External Database Configuration
---

<p>This document describes the tables in the {{ site.data.vars.Product_Short }} Embedded Reporting data schema.</p>

<p>The {{ site.data.vars.Product_Short }} platform includes an Embedded Reporting component 
that you can choose to enable when you install the platform. Embedded Reporting stores a 
history of your managed environment and then presents selective snapshots of this history 
via a set of standard dashboards and reports.</p>

<p>Dashboards and charts in {{ site.data.vars.Product_Short }} are powered by the Grafana® 
observability platform. With Grafana, it's easy to navigate the existing dashboards, and 
to make your own charts and dashboards with no coding required. You can also create custom 
custom reports via SQL queries against the Embedded Reports database.</p> 

<p>To compose custom reports, navigate to the Reports view, then explore the Timescale 
database. From there, you can assemble queries to populate your custom reports. To help 
you build these queries, this document describes the schema tables, and provides some 
sample queries against them.</p>

<p>The Embedded Reports feature uses a TimescaleDB service to manage the reporting data. 
The default installation of {{ site.data.vars.Product_Short }} includes its own installation of 
TimescaleDB.  This document also includes instructions to deploy an external TimescaleDB service. 
You can use this as an alternative to the default deployment. 



<p>For general information information about {{ site.data.vars.Product_Short }}, 
see the full {{ site.data.vars.Product_Short }} documentation 
<a href="https://docs.turbonomic.com/">HERE</a>.</p>