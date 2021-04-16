---
layout: default
title: YAML File Editing Tips
---

To configure an external TimescaleDB, you will edit the {{ site.data.vars.Product_Short }} 
cr.yaml file. When editing yaml files, you must be careful to respect the file syntax, 
including indents in the file.  General rules for edits include:

* Always uses spaces, not tabs, for all indentation. If your editor of
   choice makes this difficult, you can use the linux `expand` utility
   when you're done, to convert tabs to equivalent spaces.
 * Be careful to keep the same indentation for all properties in a given
   section.
 * Never use the same property name twice in the same section. Doing this
   will render the YAML file invalid, though in all likelihood you will not
   see any notification of a problem. Rather, all but one of the property
   definitions will be silently ignored. 
​
In this documentation we refer to specific properties in the CR file using a "path" expression. 
For example, assume the path `/spec/global/repository` to designate a `repository` property in the 
file.  You can find property in the file as follows:
​
1. Find a line that says `spec:` with no indentation at all.
2. Between that line and the next unindented line (not counting comments, which start with `#`),
   find a line that says `global:` and is at the next level of indentation.
3. Between that line and the next line with the same indentation, find a line that starts with
   `repository:`. That line is where the addressed property is defined.
   
### Example:
In this example, find the `repository` property specified by `/spec/global/repository`:
<pre>
apiVersion: charts.helm.k8s.io/v1alpha1
kind: Xl
metadata:
  name: xl-release
<i>spec:</i>
  properties:
    global:
      repository:        # This is NOT the correct property
        ...
      
  # Global settings
  <i>global:</i>
    <i>repository:</i>          # This is the one we're after
</pre>
The first `repository` property is not at `/spec/global/repository`, but at 
`/spec/properties/global/repository`. 
​