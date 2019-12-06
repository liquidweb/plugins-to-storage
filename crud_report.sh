#!/bin/bash
source ./config

fun_create () {
   read -r -p "Enter plugin name " name
   read -r -p "Enter new version " new_version
   read -r -p "Enter current version " current_version
   tmp=$(mktemp)
   $(jq --arg name $name \
        --arg newver $new_version \
        --arg currver $current_version \
        '. += [{"plugin": $name, "new_version": $newver, "current_version": $currver}]' \
        $report_file > "$tmp" && mv "$tmp" $report_file) 
   jq . $report_file
}

fun_read () {
   read -r -p "See entire[e] file or just one plugin[p]? [e/p] " input
   case $input in
     [eE])
        jq . $report_file
        ;;
     [pP])
        read -r -p "Enter plugin name " name
        jq -r --arg name "$name" '.[] | select(.plugin==$name)' $report_file
        ;;
   esac
}

fun_update () {
   echo "UPDATE"
}

fun_delete () {
   echo "DELETE"
}

run=true
while $run
do
 read -r -p "Would you like to create, read, update, delete your report? [c/r/u/d] " input

 case $input in
     [cC])
       fun_create
       run=false
       ;;

     [rR])
      fun_read
      run=false
      ;;

     [uU])
      fun_update
      run=false
      ;;

     [dD])
      fun_delete
      run=false
      ;;

     *)
      echo "Invalid input..."
      ;;
 esac
done
