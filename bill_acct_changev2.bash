#!/bin/bash
# This program display or change active resources per project linked to a specific billing account
# IMPORTANT - the unlink command in the program will make all VM's crash in that project
# Modify the inside of the loop as you please
# Input parameters:
# $1 = How deep do you want to go - how many projects from the top
# $2 = Current Billing account, find it like this
# $3 = New Billing account, find it like this
# $4 = Y if you want to check if any VM's are running before you change the billing account
# Billing -> "GO TO LINKED BILLING ACCOUNT" -> Account Management - Billing account id
#
# e.g. ./billing_ac_change.bash 0 <current_billing_account> <new_billing_account> Y" - 0 = one project only

CUR_DATE=`date +"%b %d:%Y-%H:%M:%S"`
ID="${CUR_DATE}:${0}:"
ME=`basename "$0"`
FILE_BU_PRJ=${ME}.prjbackup
VM_CNT=0

if [[ $# -ne 4 ]]
then
        echo "${ID}Incorrect parameters specified!"
        echo "${ID}Please try again!"
        echo "${ID}e.g. ./billing_ac_change.bash 10 <current_billing_account> <new_billing_account> Y"
        exit 1
fi

MAX=${1}
cnt=0
# Backup all the project ids in a file in case needed
gcloud beta billing projects list --billing-account ${2} --format="value(projectId)" | tee ${FILE_BU_PRJ}
echo -e "All project ids for this billing acct ${2} is saved in file ${FILE_BU_PRJ}"
for f in $(gcloud beta billing projects list --billing-account ${2} --format="value(projectId)");
do
echo -e "\nProjectID: $f";
# If Y ${4} then check if any VM's are currently running and warn
if [ ${4} == 'Y' ]
then

VM_CNT=`gcloud compute instances list --project ${f} | grep RUNNING | wc -l`
if (( $VM_CNT > 0 ))
then
  while true; do
    read -p "There are ${VM_CNT} VM's running, if you answer Y then they will all crash when the billing account get unlinked and re-assigned " yn
    case $yn in
        [Yy]* ) echo "Unlinking project ${f} from billing account ${2}"; break;;
        [Nn]* ) exit 2;;
        * ) echo "Please answer yes or no.";;
    esac
  done
fi
fi

echo "Unlink project $f from current billing account ${2}:"
gcloud beta billing projects unlink $f
if [ $? -ne 0 ]
then
  echo "gcloud beta billing projects unlink $f failed"
  exit 1
fi

echo "link project $f to new billing account ${3}:"
gcloud beta billing projects link ${f} --billing-account=${3}
if [ $? -ne 0 ]
then
  echo "gcloud beta billing projects link $f failed"
  exit 1
fi

# add in more list commands like firewall rules - gcloud compute firewall-rules list --project
cnt=$cnt+1
if (( $cnt > $MAX ))
then
 exit 0
fi
done
