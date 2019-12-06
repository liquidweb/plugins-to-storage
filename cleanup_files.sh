#!/bin/bash
source ./config
echo "************ Cleanup Files *****************************"
rm $report_file
rm $manifest_file
rm $list_file
rm *$zip
