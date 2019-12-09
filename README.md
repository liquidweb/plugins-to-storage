# Plugins to Storage
The goal of this project is to compare a `wp plugin list` output with a `manifest.json` file to see if plugins need updating
on an object store instance. If plugins do need updating, the `manifest.json` file will be modified with the new plugin version and 
the plugin directory in the WordPress instance will be zipped and placed on the object store instance.

## Prerequisites 
1. Need an Object Store bucket with a specific `manifest.json` file. 
```
{
  "wordpress-plugin": {
    "version": "1.0.0",
    "plugin": "wordpress-plugin.zip",
  },
  "hello-dolly": {
    "version": "1.7.2",
    "plugin": "hello-dolly.zip"
  },
  ...
}  
```
2. Need a server with WordPress installed

## Installation Instructions
1. Clone this repository in the home folder of your WordPress server
2. On your server, create the following file: `~/.aws/credentials`
```
[default]
aws_access_key_id=YOUR AWS ACCESS KEY
aws_secret_access_key=YOUR AWS SECRET ACCESS KEY
```
