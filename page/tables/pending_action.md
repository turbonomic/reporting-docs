---
layout: default
title: pending_action Table
---

This table lists the latest actions that have been recommended by the market. The table repopulates at a configurable interval (not necessarily every 10-minute market cycle). When it repopulates, all actions are replaced with the latest action recommendations.

This table does not include actions that are in progress.
{% include genFiles/tables/pending_action.html %}

## Sample Use Cases

To get the target entities for all the pending actions, join this table with the `entities` table. 
This example lists the pending action type, entity name, and the entity type:

```
select pending_action.type AS action_type, entity.name, entity.type AS ent_type
FROM pending_action
INNER JOIN entity ON pending_action.target_entity_id=entity.oid
```
