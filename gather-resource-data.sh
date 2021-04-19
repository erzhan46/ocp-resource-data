#!/usr/bin/env bash

# Script to gather resource data for specified projects
# v0.1 Yerzhan Beisembayev ybeisemb@redhat.com

projects=( \
"dev-adj" \
"dev-cdr" \
"dev-csb" \
"dev-dp" \
"dev-esb" \
"dev-hlt" \
"dev-odm" \
"dev-ops" \
"dev-pcb" \
"dev-pco" \
"dev-sap" \
"dev-tms" \
"dev-wms" \
"pt-adj" \
"pt-cdr" \
"pt-csb" \
"pt-dp" \
"pt-esb" \
"pt-hlt" \
"pt-odm" \
"pt-ops" \
"pt-pcb" \
"pt-pco" \
"pt-sap" \
"pt-tms" \
"pt-wms" \
"sit-adj" \
"sit-cdr" \
"sit-csb" \
"sit-dp" \
"sit-esb" \
"sit-hlt" \
"sit-odm" \
"sit-ops" \
"sit-pcb" \
"sit-pco" \
"sit-sap" \
"sit-tms" \
"sit-wms" \
"uat-adj" \
"uat-cdr" \
"uat-csb" \
"uat-dp" \
"uat-esb" \
"uat-hlt" \
"uat-odm" \
"uat-ops" \
"uat-pcb" \
"uat-pco" \
"uat-sap" \
"uat-tms" \
"uat-wms" \
)

echo "Project	CPU requests	CPU limits	Memory request	Memory limits"

for project in ${projects[@]}; do
  echo -n "${project}	"
  oc adm top pods -n ${project} 2>/dev/null \
      | sed 's/\([0-9]*\)m /\1/' \
      | sed 's/\([0-9]*\)Mi/\1/' \
      | sed 's/\(1\)Gi/1024/' \
      | sed 's/\(2\)Gi/2048/' \
      | sed 's/\(3\)Gi/3072/' \
      | sed 's/\(4\)Gi/4096/' \
      | awk 'BEGIN {OFS="       "; ORS="	";cpu=0.0;mem=0.0;} {cpu=cpu+$2;mem=mem+$3;} END {print cpu/1000, mem;}'
  oc describe node | grep ${project} \
      | sed 's/\([0-9]*\)m (/0.\1 (/' \
      | sed 's/\([0-9]*\)Mi (/\1 (/' \
      | sed 's/\(1\)Gi (/1024 (/' \
      | sed 's/\(2\)Gi (/2048 (/' \
      | sed 's/\(3\)Gi (/3072 (/' \
      | sed 's/\(4\)Gi (/4096 (/' \
      | awk 'BEGIN {OFS="	"; ORS="	";cpur=0.0;cpul=0.0;memr=0.0;meml=0.0;} {cpur=cpur+$3;cpul=cpul+$5;memr=memr+$7;meml=meml+$9;} END {print cpur,cpul,memr,meml;}'
  echo ""
done


