---
layout: default
title: entity Table
---

The Entity table contains information about which entities appear in the 
topologies and when. Table gets updated with each market cycle.

{% include genFiles/entity.html %}

## Sample Use Cases

### Count entities that meet specific criteria:
For a given time interval, count the number of `PHYSICAL_MACHINE` entities that have 4 CPUS.

    select count(*)
    from entity e
    where e.type = 'PHYSICAL_MACHINE'
        and attrs->'num_cpus'= '4'
        and ('2021-02-01T05:00:00Z','2021-02-18T04:59:59Z') OVERLAPS (e.first_seen, e.last_seen)

### Find clusters that were configured for a given time range:
Queries like this are common to generate values for grafana variables that you can run reports against.

    SELECT name, oid
    FROM entity
    WHERE
      entity.type = 'COMPUTE_CLUSTER'
      AND ('2021-02-01T05:00:00Z','2021-02-18T04:59:59Z') OVERLAPS (first_seen, last_seen)
    ORDER BY 1
    
For example, here's a list of variables that a user is choosing:
{% if site.github.pages_hostname == "github.io" %}
<img src="{{ site.github.baseurl }}{{ '/assets/ReportByVariable.png' | relative_url }}" alt="Report Variables">
{% else %}
<img src="{{ '/assets/ReportByVariable.png' | relative_url }}" alt="Report Variables">
{% endif %}
