---
layout: default
title: completed_action Table
---

This table lists the current set of completed actions. A completed action is an action that completed its execution, whether the action succeeded or failed.

This table does not contain "in progress" or "queued" actions.
{% include genFiles/tables/completed_action.html %}

## Sample Use Cases


To get the target entities for all the completed actions, join this table with the `entities` table. 
This example lists the completed action type and time, and the entity name type:

```
select completed_action.type AS action_type, completed_action.completion_time AS time, entity.name, entity.type AS ent_type
FROM completed_action
INNER JOIN entity ON completed_action.target_entity_id=entity.oid
```