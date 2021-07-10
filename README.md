# reassigngcpprjects
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
