# This script runs Terraform, extracts the EC2 public IP, updates the Ansible inventory, and runs the playbook

# Run Terraform
echo "Running terraform apply..."
terraform apply -auto-approve

# Extract the public IP from Terraform output
$instance_ip = terraform output -raw instance_ip

# Update the inventory file
(Get-Content inventory.ini) -replace '<instance_public_ip>', $instance_ip | Set-Content inventory.ini

echo "Updated inventory.ini with EC2 public IP: $instance_ip"

echo "Running Ansible playbook..."
ansible-playbook -i inventory.ini playbook.yml
