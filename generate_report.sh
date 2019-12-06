#/bin/bash

source ./config

echo "************ Download Manifest File *********************"
aws --endpoint=$endpoint s3 cp s3://$bucket_name/$manifest_file .

echo ""
echo "************* Plugin Report *****************************"
cd $public_html
wp plugin list --status=active --fields=name,version --format=json > $plugin_updater/$list_file
cd $plugin_updater

rpt_array=()

for row in $(jq -r '.[] | @base64' $list_file); do
   _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
   }

   name=$(_jq '.name')
   new_version=$(_jq '.version')
   curr_version=$(jq -r --arg name "$name$zip" '.[] | select(.plugin==$name) | .version' $manifest_file)

   if [ ! -z $curr_version ] && [ $new_version != $curr_version ]
   then
      rpt_obj=$(jq -n --arg name "$name" \
                      --arg new_version "$new_version" \
                      --arg curr_version "$curr_version" \
                      '{plugin: $name, new_version: $new_version, current_version: $curr_version}')
      rpt_array+=("$rpt_obj")
   fi
done

length=${#rpt_array[@]}
current=0
echo "[" >> $report_file
for i in "${rpt_array[@]}"
do
   current=$((current + 1))
   echo "$i" >> $report_file
   if [[ $current -ne $length ]]
   then
      echo "," >> $report_file
   fi
done
echo "]" >> $report_file

jq '.[]' $report_file

echo ""
echo "************ Zip up Plugins *****************************"
for row in $(jq -r '.[] | @base64' $report_file); do
   _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
   }

   name=$(_jq '.plugin')
   
   cd $plugins_home
   zip -r -q $name$zip $name 
   mv $name$zip $plugin_updater
done
