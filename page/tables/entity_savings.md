---
layout: default
title: entity_savings Table
---

{{ site.data.vars.Product_Short }} tracks actions that result in savings or investments in your environment.  Actions that add resources usually require an investment, 
and actions that suspend or reduce resources usually give you a saving. 
This table describes the cost change of an action in either case. 


This table can be in an action whether you have already executed 
the action or not. The `savings_type` 
field describes:

- Whether the action is a saving or investment
- Whether the action has been executed or not

{% include genFiles/tables/entity_savings.html %}