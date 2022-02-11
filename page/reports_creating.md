---
layout: default
title: Creating Reports
---

To compose custom reports, your {{ site.data.vars.Product_Short }} user account must have 
**Report Editor** permission. When you navigate from {{ site.data.vars.Product_Short }} to the 
Grafana Reports page, in addition to browsing dashboards, you can create new dashboards. To 
create a custom report:

1. Create a new dashboard.
   
   Navigate to the Grafana Dashboards page, then click the **+** icon in the left-hand 
   menu bar to create a new dashboard.
   
2. Click to create a new panel.
   
   The page for the new panel includes a tabbed section with a **Query** tab.
   
3. In the **Query** tab, set the **Data Source** field to _Turbo Timescale_.
   
   This sets up the panel to display data from the {{ site.data.vars.Product_Short }} Timescale database.
   
4. Edit the panel's query.

   The panel will display a default query.  You can edit this query to change the data the panel displays.
   At the bottom of the default query, click <b>Edit SQL</b>. This displays a field where you can enter the SQL that you want.
   
   For information about experimenting with different queries, see 
   [Exploring SQL Queries](reports_exploring_SQL.html)
   
   To help you build these queries, this document describes the schema tables, and provides some sample queries against them.
   

