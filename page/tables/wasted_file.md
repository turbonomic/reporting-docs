---
layout: default
title: wasted_file Table
---

This table stores the paths to the current wasted files in the environment, as well as properties of the files such as last modification or file size. 

{% include genFiles/tables/wasted_file.html %}

## Sample Use Cases

### Get information about storage files for a data store:

The query returns the storage name, the file path, the site of the file and the last modified time for each file of a data store. The query accepts the $storage_oid as a parameter.

    SELECT storage_name as "Datastore",
           path as "File Path",
           file_size_kb as "File Size",
           modification_time as "Last Modified Time"
      FROM wasted_file
     WHERE file_size_kb >= 0
       AND ARRAY[storage_oid]::text[] && Array['$storage_oid']::text[]
     ORDER BY 3 DESC