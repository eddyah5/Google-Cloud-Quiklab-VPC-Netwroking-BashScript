# ChatGTP prompts ---------------------starts---------------------
Write a complete bash script for this google cloud Quiklab: "Getting Started with VPC Networking" by #TASK as listed below:
#TASK 1: View the available subnets
#TASK 2: View the available routes
#TASK 3: View the available firewall rules
#TASK 4: Delete the available firewall rules
#TASK 5: Delete the default network
#TASK 6: Try to create a VM instance and echo the result which must be negative because you cannot create a VM without a firewall rule
#TASK 7: Create an auto-mode VPC network with firewall rules
#TASK 8: Create a VM instance and echo the Internal and External IP addresses of the VM instances created
#TASK 9: To test connectivity, automatically SSH into the VM instance created and Ping both the Internal and External IP addresses of the VM instances using: ping -c 3 <IP-address> and echo the result
#TASK 10: Delete all the firewall rules on GCP Console, then try to run the ping again and echo the result
#TASK 11: Echo 'LAB COMPLETED, WELL DONE!' and exit the console
# ChatGTP prompts ---------------------ends---------------------

# ChatGTP prompts ---------------------Bash script result starts---------------------
#!/bin/bash

#Task 1: View the available subnets
gcloud compute networks subnets list --network default

#Task 2: View the available routes
gcloud compute routes list

#Task 3: View the available firewall rules
gcloud compute firewall-rules list

#Task 4: Delete the available firewall rules
gcloud compute firewall-rules delete --quiet default-allow-http 
gcloud compute firewall-rules delete --quiet default-allow-https

#Task 5: Delete the default network
gcloud compute networks delete default --quiet

#Task 6: Try to create a VM instance and echo the result which must be negative because you cannot create a VM without a firewall rule
echo "Creating a VM instance without a firewall rule..."
gcloud compute instances create test-instance --zone=us-central1-a > /dev/null
if [ $? -eq 0 ]; then
  echo "VM instance created successfully!"
else
  echo "VM instance creation failed without a firewall rule!"
fi

#Task 7: Create an auto-mode VPC network with firewall rules
echo "Creating an auto-mode VPC network with firewall rules..."
gcloud compute networks create auto-mode-vpc-network --subnet-mode auto > /dev/null
if [ $? -eq 0 ]; then
  echo "Auto-mode VPC network created successfully!"
else
  echo "Auto-mode VPC network creation failed!"
fi

#Task 8: Create a VM instance and echo the Internal and External IP addresses of the VM instances created
echo "Creating a VM instance..."
gcloud compute instances create test-vm --zone=us-central1-a > /dev/null
if [ $? -eq 0 ]; then
  echo "VM instance created successfully!"
  echo "Fetching Internal and External IP Addresses..."
  INTERNAL_IP=$(gcloud compute instances describe test-vm --zone=us-central1-a --format="value(networkInterfaces[0].networkIP)")
  EXTERNAL_IP=$(gcloud compute instances describe test-vm --zone=us-central1-a --format="value(networkInterfaces[0].accessConfigs[0].natIP)")
  echo "Internal IP Address: $INTERNAL_IP"
  echo "External IP Address: $EXTERNAL_IP"
else
  echo "VM instance creation failed!"
fi

#Task 9: To test connectivity, automatically SSH into the VM instance created and Ping both the Internal and External IP addresses of the VM instances using: ping -c 3 <IP-address> and echo the result
echo "Testing connectivity to both Internal and External IP Addresses..."
gcloud compute ssh test-vm --zone=us-central1-a --command="ping -c 3 $INTERNAL_IP"
gcloud compute ssh test-vm --zone=us-central1-a --command="ping -c 3 $EXTERNAL_IP"

#Task 10: Delete all the firewall rules on GCP Console, then try to run the ping again and echo the result
echo "Deleting all firewall rules..."
gcloud compute firewall-rules delete --quiet default-allow-ssh
gcloud compute firewall-rules delete --quiet default-allow-icmp

echo "Testing connectivity without firewall rules..."
gcloud compute ssh test-vm --zone=us-central1-a --command="ping -c 3 $INTERNAL_IP"
gcloud compute ssh test-vm --zone=us-central1-a --command="ping -c 3 $EXTERNAL_IP"

#Task 11: Echo 'LAB COMPLETED, WELL DONE!' and exit the console
echo "LAB COMPLETED, WELL DONE!"
exit
# ChatGTP prompts ---------------------Bash script result ends---------------------
