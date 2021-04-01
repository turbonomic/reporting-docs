---
layout: default
title: Editing the Platform CR File
---


To enable an external TimescaleDB for Embedded Reports, you must edit the 
{{ site.data.vars.Product_Short }} charts_v1alpha1_xl_cr.yaml file.

## Open the .cr file for editing. 

The location of the file depends on the type of {{ site.data.vars.Product_Short }} installation you are configuring:

* For an OVA installation of {{ site.data.vars.Product_Short }}:  
  Open a SSH terminal session on your {{ site.data.vars.Product_Short }} instance.  
  Log in with the System Administrator that you set up when you installed Turbonomic: 
  * Username: `turbo`
  * Password: `<your_private_password>`
  
  Then edit the file:  
  `/opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml`
  
* {{ site.data.vars.Product_Short }} on a Kubernetes node or node cluster:  
  Open the following file for editing:  
  `deploy/crds/charts_v1alpha1_xl_cr.yaml`

## Specify the endpoint for connecting to the external database.
You can use the database service DNS, or you can use an IP address. 

Add the endpoint as the `externalTimescaleDBIP` property in the `spec: global:` 
section of the .cr file:  
```
spec:
...
  global:
    externalTimescaleDBIP: <host-or-IP>
```    




ARF DOG




> Note: There are a few rules you must bear in mind whenever editing a YAML
> file such as this one:
> * Always uses spaces, not tabs, for all indentation. If your editor of
>   choice makes this difficult, you can use the linux `expand` utility
>   when you're done, to convert tabs to equivalent spaces.
> * Be careful to keep the same indentation for all properties in a given
>   section.
> * Never use the same property name twice in the same section. Doing this
>   will render the YAML file invalid, though in all likelihood you will not
>   see any notification of a problem. Rather, all but one of the property
>   definitions will be silently ignored. 
​
In this document we will refer to specific properties in the CR file using a "path" like 
`/spec/global/repository`. This means the property you find as follows:
​
1. Find a line that says `spec:` with no indentation at all.
2. Between that line and the next unindented line (not counting comments, which start with `#`),
   find a line that says `global:` and is at the next level of indentation.
3. Between that line and the next line with the same indentation, find a line that starts with
   `repository:`. That line is where the addressed property is defined.
   
Here's an example, where we're looking for the property at `/spec/global/repository`:
```
apiVersion: charts.helm.k8s.io/v1alpha1
kind: Xl
metadata:
  name: xl-release
spec:
  properties:
    global:
      repository:               # This is NOT the correct property
        ...
      
  # Global settings
  global:
    repository:                 # This is the one we're after
```
The first `repository` poperty is not at `/spec/global/repository`, but at 
`/spec/properties/global/repository`. Step 2 doesn't apply because the `global:` line is not
at the _next_ level of indentation, but the one after that. It is easy to get such cases confused 
while editing YAML.

