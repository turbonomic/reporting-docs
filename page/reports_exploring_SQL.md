---
layout: default
title: Exploring SQL Queries
---

To work with SQL queries, your {{ site.data.vars.Product_Short }} user account must have 
**Report Editor** permission. To explore queries:

1. Navigate to the Explore page.
   
   The page displays with a sample query already in place
   
2. Choose to explore Turbo Timescale.
   
   Next to the page title, **Explore**, you can choose which database to work with. Choose the 
   database `Turbo Timescale`. 
   
   If you have installed an external TimescaleDB, be sure to choose th name that you gave to that database. 
   
4. Edit the **Explore** query.

   The page displays a default query.  You can edit this query to change the data the page displays.
   At the bottom of the default query, click <b>Edit SQL</b>. This displays a field where you can enter the SQL that you want.
   
   To test your query, click **Run Query**. If your query includes data points over time, you can choose 
   **Format As: Time Series**. For tabular data, choose **Format As: Table**.
   
   To help you build these queries, this document describes the schema tables, and provides some sample queries against them.
   

