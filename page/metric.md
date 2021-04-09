---
layout: default
title: metric Table
---

This table contains metric values for entities that appeared in the topology. Most metrics are values associated with commodities bought or sold by the entity. Bought and sold commodities appear in separate records - one for the buyer and one for the seller. In addition to topology metrics, this table contains headroom properties, which are generated daily by headroom plans.
{% include genFiles/metric.html %}

## Sample Use Cases

### VMem utilization for a Virtual Machine over time:

This query returns all the VM memory metrics collected for a specified virtual machine for a given time interval. The time interval is truncated to the hour.

    SELECT m.time, avg(m.utilization) AS avg_util
      FROM  metric m,
        scope_to($__timeFrom()::timestamptz - INTERVAL '24 hour',  date_trunc('hour', $__timeTo()::timestamptz),
          'VIRTUAL_MACHINE', ARRAY[0]::bigint[], '0' = '0') s
      WHERE m.entity_oid = s.oid
        and m.time BETWEEN s.from_time AND s.to_time
        AND m.type = 'VMEM'
        AND m.provider_oid IS NULL
        AND m.time BETWEEN $__timeFrom()::timestamptz - interval '24 hour' AND date_trunc('hour', $__timeTo()::timestamptz)
      GROUP BY 1
      
      
### Storage Amount of Physical Machines Running On a Cluster:

This query returns the max values of storage amounts for all the physical machines running in a cluster. Note that the only parameter given to the query other than the time range, is the `cluster_id`. We then have an internal function in Postgres that is able to translate the `cluster_id` to all the oids of the physical machines.

    SELECT
         date_trunc('day', m.time) as time,
         m.entity_oid,
         MAX(current) FILTER (WHERE m.type = 'STORAGE_AMOUNT') as stor_used,
         MAX(capacity) FILTER (WHERE m.type = 'STORAGE_AMOUNT') as stor_cap,
         MAX(current) FILTER (WHERE m.type = 'STORAGE_PROVISIONED') as stor_prov
       FROM
         metric m,
         scope_to($__timeFrom(), $__timeTo(), 'STORAGE', ARRAY[$CluserId+0]::bigint[], $CluserId = '0') s
       WHERE
         m.entity_oid = s.oid
         AND m.time BETWEEN s.from_time AND s.to_time
         AND m.type in ('STORAGE_AMOUNT', 'STORAGE_PROVISIONED')
         AND m.time between $__timeFrom() and $__timeTo()
      GROUP BY 1, 2

### Physical Machine Average Memory Utilization  - Week Over Week By Day:

Returns the average daily memory utilization for virtual machines both for the current week and the past week.

    WITH metrics AS (
      SELECT m.time, m.utilization
        FROM metric m,
        scope_to($__timeFrom()::timestamptz - INTERVAL '7 day', $__timeTo(), 'PHYSICAL_MACHINE', ARRAY[0]::bigint[], '0' = '0') s
        WHERE
          m.entity_oid = s.oid
          AND m.time BETWEEN s.from_time AND s.to_time
          AND m.type = 'MEM'
          AND m.time BETWEEN ($__timeFrom()::TIMESTAMPTZ - interval '7 day') AND date_trunc('day', $__timeTo()::TIMESTAMPTZ)
        GROUP BY m.time, m.entity_oid, m.utilization
    ),
    DATA AS (
      SELECT m.time, avg(m.utilization) AS avg_util
      FROM metrics m
      GROUP BY m.time
    )
    SELECT
      INTERVAL '1 DAY' + CASE
        WHEN time BETWEEN date_trunc('day', $__timeFrom()::TIMESTAMPTZ - interval '7 day')
          AND date_trunc('day', $__timeTo()::TIMESTAMPTZ - interval '7 day')
        THEN date_trunc('day', time + interval '7 day')
        ELSE date_trunc('day', time)
      END as "time",
      CASE
        WHEN time BETWEEN date_trunc('day', $__timeFrom()::TIMESTAMPTZ - interval '7 day')
          AND date_trunc('day', $__timeTo()::TIMESTAMPTZ - interval '7 day')
        THEN 'Previous Week'
        ELSE 'Week Ending ' || DATE($__timeTo()::TIMESTAMPTZ)::TEXT
      END as metric,
      avg(avg_util)
    FROM data
    GROUP BY 1, 2
    ORDER BY 1, 2
    
### Representation of Powered Off Virtual Machines:

Ideally, metrics of a turned off Virtual Machine will still be written on the table, assuming that the probe will send them in the entity dto. Most used values for commodities will have NULL values, we do this, instead of having 0’s, in order not to affect potential averages over time, while the capacity should have the same value, independent of the state of the machine. Still, some used values for commodities won’t be NULL, such as storage, since those are consumed by the machine even in a powered off state.