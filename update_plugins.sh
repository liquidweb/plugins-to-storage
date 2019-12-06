#!/bin/bash

source ./config

echo "************ Update Manifest ***************************"
for row in $(jq -r '.[] | @base64' $report_file); do
   _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
   }

   name=$(_jq '.plugin')
   zip=".zip"
   new_version=$(_jq '.new_version')

   tmp=$(mktemp)
   $(jq -r --arg name "$name$zip" \
           --arg version "$new_version" \
           '(.[] | select(.plugin==$name) | .version) |= $version' \
           $manifest_file > "$tmp" && mv "$tmp" $manifest_file
   )
done

echo "************ Cleanup Files *****************************"
rm $report_file
rm $manifest_file
rm $list_file
rm *.zip
