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
   
   To help you build these queries, this document describes the schema tables, and provides some sample queries against them.
   


<h2>Importing Custom Reports</h2>

You can find a set of custom reports to import on the {{ site.data.vars.Product_Short }} 
Open Source site at 
<a href="https://github.com/turbonomic/visualization/tree/main/embedded-visualization"
target="_blank">https://github.com/turbonomic/visualization/tree/main/embedded-visualization</a>. 
This page lists different categories of reports that you can use to track your environment.

To import a custom report:


1. In the Embedded Reports page, create a folder to store your imported JSON files.  
   
    In Embedded Reports page, navigate to **Dashboards / Browse**. on that page, 
    click <b>New Folder</b> to create a folder for you imported JSON files.    
    
    For example, create a folder named `{{ site.data.vars.Product_Short }}_Github_Reports`.  
    
    After you create the folder, navigate back to the **Dashboards / Browse** page.

2. Navigate to the report you want to import.  
   
   Go to <a href="https://github.com/turbonomic/visualization/tree/main/embedded-visualization" 
   target="_blank">https://github.com/turbonomic/visualization/tree/main/embedded-visualization</a> and browse 
   to find the report you want.
   
3. Copy the JSON file to the clipboard.

   In the report entry, navigate to the JSON file. In GitHub, display the file as **Raw JSON**, then 
   select the JSON and copy it to the clipboard.

4. Import the JSON file into your Reports.
   
   In the Embedded Reports page, click **Import**, and then paste the JSON you copied into the 
   **Import Via Panel JSON** field.  Then click **Load**.
   
   To complete the import:
   
   - Give the name you want for the report.
   - Choose the folder that you just created to store the report.
   - If you want to share this report with other Grafana installations, make a note of the UID, or change it to a value you can remember.
   - Click **Import**.


The Embedded Reports page displays your imported report.

