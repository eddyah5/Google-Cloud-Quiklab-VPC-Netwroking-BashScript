#!/bin/bash

#eddyfactry@yahoo.com
#My name: Editoro Godwin Okon

#LAB NAME: Getting Started with VPC Networking

#TASK 1
#View the subnets
gcloud compute networks subnets list

#View the routes
gcloud compute routes list --filter="network=default"

#View the firewall rules
gcloud compute firewall-rules list --format="json"

#Delete the Firewall rules
gcloud compute firewall-rules delete default-allow-icmp

gcloud compute firewall-rules delete default-allow-internal

gcloud compute firewall-rules delete default-allow-rdp

gcloud compute firewall-rules delete default-allow-ssh

#Delete the default network
gcloud compute networks delete default

#Try to create a VM
gcloud compute instances create test-VM --zone=europe-west1-c
echo "You cannot create a VM instance without a VPC network!"

printf "\n\e[1;96m%s\n\n\e[m" 'Task 1 is done !'
  sleep 2.5

#TASK 2
#Create an auto mode VPC network with Firewall rules
#Create VPC network
gcloud compute networks create mynetwork

#Create firewall-rules mynetwork-allow-custom-icmp-ssh-rdp
gcloud compute firewall-rules create mynetwork-allow-custom-icmp-ssh-rdp --direction=INGRESS --priority=1000 --network=mynetwork --action=ALLOW --rules=icmp,tcp:22,tcp:3389 --source-ranges=0.0.0.0/0

#Create a VM instance in mynet-ae-vm (Because us-central1-c zone is not available as at the time this script is written)
gcloud compute instances create mynet-ae-vm --zone=asia-east1-a --machine-type=n1-standard-1 --subnet=mynetwork

#Create a VM instance in mynet-eu-vm (Because us-central1-c zone is not available as at the time this script is written)
gcloud compute instances create mynet-eu-vm --zone=europe-west1-b --machine-type=n1-standard-1 --subnet=mynetwork

printf "\n\e[1;96m%s\n\n\e[m" 'Task 2 is done !'
  sleep 2.5

#TASK 3
#Explore the connectivity for VM instances
#To get the internal IP Address of mynet-eu-vm
gcloud compute instances describe mynet-eu-vm --zone=europe-west1-b \
  --format='get(networkInterfaces[0].networkIP)'

#Assign the Internal IP to a variable
var=$(gcloud compute instances describe mynet-eu-vm --zone=europe-west1-b \
  --format='get(networkInterfaces[0].networkIP)')
echo "$var"
echo "1) PLEASE COPY THE Internal IP ADDRESS ABOVE AND SAVE IT SOMEWHERE"

#To get the External IP Address of mynet-eu-vm
gcloud compute instances describe mynet-eu-vm --zone=europe-west1-b \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)'

#Assign the external IP to a variable
var2=$(gcloud compute instances describe mynet-eu-vm --zone=europe-west1-b \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo "$var2"
echo "2) PLEASE COPY THE External IP ADDRESS ABOVE AND SAVE IT SOMEWHERE"

#To test connectivity
echo "1) Ping the Ip address you copied earlier using: ping -c 3 <IP-address>"
echo "2) Ping the Ip address you copied earlier using: ping -c 3 <IP-address>"
echo "3) YOU CAN PING IN THE COMING SSH WINDOW..."

#SSH into mynet-us-vm
gcloud compute ssh mynet-ae-vm --zone=asia-east1-a

#Remove the allow-icmp firewall rules
echo "Manually delete all the firewall-rules on GCP Console, then run the ping again"
echo "This should not work because you deleted the firewall rules!"

echo 'LAB COMPLETED, WELL DONE!'