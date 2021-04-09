---
layout: default
title: scope Table
---

The Scope table tracks the association of two entities as they are related in each other’s scope. The `seed_oid` identifies the containing entity (the entity that defines the scope), and the `scoped_oid` identifies the entity that is within the given scope. This table is updated with each market cycle.

{% include genFiles/scope.html %}

## Examples

### Example 1:

| seed_oid | scoped_oid | scoped_type      | start                | finish              |
|----------|------------|------------------|----------------------|---------------------|
| 111      | 999        | PHYSICAL_MACHINE | 2021-01-01T05:00:00Z | 9999-12-31T23:59:59 |
| 999      | 111        | COMPUTE_CLUSTER  | 2021-01-01T05:00:00Z | 9999-12-31T23:59:59 |

The first row indicates that cluster_1 (oid: 111) contains Physical Machine_1 (oid: 999). The `start` time indicates the first time the
entity was discovered. This relationship is ongoing and this is represented by a `finish` timestamp of 9999-12-31T23:59:59.
Row 2 shows that Physical Machine_1 is contained by Cluster_1.

### Example 2:

| seed_oid | scoped_oid | scoped_type      | start                | finish               |
|----------|------------|------------------|----------------------|----------------------|
| 111      | 999        | PHYSICAL_MACHINE | 2021-01-01T05:00:00Z | 2021-01-31T05:00:00Z |
| 999      | 111        | COMPUTE_CLUSTER  | 2021-01-01T05:00:00Z | 2021-01-31T05:00:00Z |
| 222      | 999        | PHYSICAL_MACHINE | 2021-01-31T05:00:00Z | 9999-12-31T23:59:59  |
| 999      | 222        | COMPUTE_CLUSTER  | 2021-01-31T05:00:00Z | 9999-12-31T23:59:59  |
    
These records show that Physical_Machine_1 moved to Cluster_2 (oid: 2222) on January 31. Note that the timestamp for the end of the relationship with Cluster_1 is the same as the timestamp for the start of the relationship with Cluster_2. 

## Sample Use Cases

### Count Physical Machines in Clusters Over A Given Time Interval

    WITH all_relationships AS (
        select 
            e.name cluster_name, s.seed_oid cluster_oid, s.scoped_oid pm_oid
        FROM 
            entity e
        JOIN scope s on e.oid = s.seed_oid 
            and s.scoped_type ='PHYSICAL_MACHINE'
        WHERE e.type = 'COMPUTE_CLUSTER'
            AND ('2021-02-01T05:00:00Z','2021-02-18T04:59:59Z') OVERLAPS (s.start, s.finish) 
    ), non_duplicate_relationships AS (
    --    The same relationships between 2 entities can exist in given time interval if they move in and out of each others scopes
    --    We account for these duplicates entries at varying time intervals
        select *
        from all_relationships
        GROUP BY cluster_name, cluster_oid, pm_oid
    )
    select cluster_name, count(*)
    from non_duplicate_relationships
    group by cluster_name


