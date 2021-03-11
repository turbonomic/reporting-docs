---
layout: default
title: entity
---

# Table Description

The Entity table contains information about which entities appear in the 
topologies and when. Table gets updated with each market cycle.

# Columns

{% include entityTable.html %}


# Sample Use Case
For a given time interval, count number of PHYSICAL_MACHINE entities that have 4 CPUS.

    select count(*)
    from entity e
    where e.type = 'PHYSICAL_MACHINE'
        and attrs->'num_cpus'= '4'
        and ('2021-02-01T05:00:00Z','2021-02-18T04:59:59Z') OVERLAPS (e.first_seen, e.last_seen)

