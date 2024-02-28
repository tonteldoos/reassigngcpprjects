# How to re-assigning billing accounts to projects in GCP in batch.
# Description:
 Re-assigning in mass billing accounts to projects in GCP, first, unlink the current billing account
 to all Projects in your account and then re-assign to a new billing account. 
 IMPORTANT: Any VM or resource running in that project will terminate!
<br>
Modify the inside of the loop as you please - you can run other changes in mass like this as well.
 <br>Input parameters:
 <br>$1 = How deep do you want to go - how many projects from the top of the organization
 <br>$2 = Current Billing account, find it like this - https://cloud.google.com/billing/docs/how-to/find-billing-account-id
 <br>$3 = New Billing account, find it like this - Billing -> "GO TO LINKED BILLING ACCOUNT" -> Account Management - Billing account id
 <br>$4 = Y if you want to check if any VM's are running before you change the billing account
 <br>
 <br>e.g. ./billing_ac_change.bash 0 <current_billing_account> <new_billing_account> Y" - 0 = one project only to test
