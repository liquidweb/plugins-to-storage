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
3. Modify your [config](./config) file 
```
endpoint="https://object-store.com"
bucket_name="bucket-name"

list_file="list.json"
manifest_file="manifest.json"
report_file="report.json"

public_html="/home/user/public_html"
plugin_updater="$(pwd)"
plugins_home="$public_html/wp-content/plugins"

zip=".zip"
```
4. You'll most likely need to modify `endpoint`, `bucket_name`, and `public_html` variables.

## Usage
1. In your `~/plugins-to-storage` directory, run the following:
2. `./generate_report.sh` will create a report with plugins that need updating, along with a `report.json`, `list.json`, `manifest.json`, and all necessary `.zip` files.
3. You can run `./crud_report.sh` to read and modify your `report.json` file
4. Run `./update_plugins.sh` in order to upload your zip files and modified `manifest.json` file to object store
5. The previous call will remove all generated files, but you can run `./cleanup_files.sh` to do the same
