---
layout: default
title: historical_entity_attrs Table
---

This table tracks the historical attributes associated with an entity. Each row represents the value of a particular attribute of an entity at a particular point in time. New rows are written when the value of a property changes between topologies, and at regular intervals (e.g. daily) to keep a recent value available within a reasonable time range.
{% include genFiles/tables/historical_entity_attrs.html %}

## Sample Use Cases

### Get All Powered On Entities:

This query returns all the entities in the historical_entity_attrs that do not have a powered_off state given a certain time range.

    select *
    from historical_entity_attrs h1
    where h1.type = 'ENTITY_STATE' and h1.int_value::entity_state != 'POWERED_OFF' AND h1.time between $__timeFrom() and $__timeTo()
      
      
### Gap-filling data:

Data in this table are not written at every broadcast. Because of this, if we ask for those data in a time range, we might only get few data points. Consider this query in which we get the values for one entity in a time range:

    SELECT * FROM historical_entity_attrs h1
    where h1.type = 'ENTITY_STATE'
        and entity_oid ='73864029152384'
        and time between (timestamptz '2021-03-01T01:00:00Z' - interval '24 hour') and '2021-03-03T04:59:59Z'
        order by time;

{% if site.github.pages_hostname == "github.io" %}
<img src="{{ site.github.baseurl }}{{ '/assets/historical_entity_attrs_1.png' | relative_url }}" alt="Historical Entity Result">
{% else %}
<img src="{{ '/assets/historical_entity_attrs_1.png' | relative_url }}" alt="Historical Entity Result">
{% endif %}

In order to  solve this problem we use a timescaledb function that fills the time ranges with data, as if those data were written at a constant interval. This means that if we want data every interval `t` but we only have data at `t1` and `t4`, with this function we can generate data at `t2` and `t3` with the same value of `t1`. The function that we use is called `time_bucket_gapfill` and here’s a sample query. Notice how in the result we have data points at a constant interval of 10 minutes:

    SELECT 
      time_bucket_gapfill('10 min', time) AS minutes,
      locf(max(h1.int_value::entity_state))
    FROM historical_entity_attrs h1
    where h1.type = 'ENTITY_STATE'
    --     AND h1.int_value::entity_state = 'POWERED_ON'
        and entity_oid ='73864029152384'
        and time between (timestamptz '2021-03-01T01:00:00Z' - interval '24 hour') and '2021-03-03T04:59:59Z'
    GROUP BY minutes

{% if site.github.pages_hostname == "github.io" %}
<img src="{{ site.github.baseurl }}{{ '/assets/historical_entity_attrs_2.png' | relative_url }}" alt="Bucket Gap Function Result">
{% else %}
<img src="{{ '/assets/historical_entity_attrs_2.png' | relative_url }}" alt="Bucket Gap Function Result">
{% endif %}

### Casting Entity States to Integers:

Entity States are internally represented as integers. This means that a property such as `POWERED_OFF` is stored as a number. In order to work with this the queries need to cast the integer to the corresponding entity state. This is done with the following cast, supported by Postgres: `int_value::entity_state `.
So for example, take a look at the two queries below, the first one without the cast, and the second query with it:

    SELECT time, entity_oid, entity_state FROM historical_entity_attrs h1
    where h1.type = 'ENTITY_STATE'
        and entity_oid ='73864029152384'
        and time between (timestamptz '2021-03-01T01:00:00Z' - interval '24 hour') and '2021-03-03T04:59:59Z'
        order by time;
        
{% if site.github.pages_hostname == "github.io" %}
<img src="{{ site.github.baseurl }}{{ '/assets/entity_to_integer_1.png' | relative_url }}" alt="Entity to Integer Result">
{% else %}
<img src="{{ '/assets/entity_to_integer_1.png' | relative_url }}" alt="Entity to Integer Result">
{% endif %}

    SELECT time, entity_oid, int_value::entity_state FROM historical_entity_attrs h1
    where h1.type = 'ENTITY_STATE'
        and entity_oid ='73864029152384'
        and time between (timestamptz '2021-03-01T01:00:00Z' - interval '24 hour') and '2021-03-03T04:59:59Z'
        order by time;
        
{% if site.github.pages_hostname == "github.io" %}
<img src="{{ site.github.baseurl }}{{ '/assets/entity_to_integer_2.png' | relative_url }}" alt="Entity to Integer Result">
{% else %}
<img src="{{ '/assets/entity_to_integer_2.png' | relative_url }}" alt="Entity to Integer Result">
{% endif %}

