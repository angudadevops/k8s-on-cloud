
cd terraform
terraform init
terraform plan 
terraform apply -auto-approve
terraform output inventory > ../ansible/inventory

echo "Please wait for a while to bring aws instances up"

sleep 60
cd ../ansible
ansible -m ping -i inventory all
ansible-playbook -i inventory prerequisites.yaml
ansible-playbook -i inventory k8s.yaml

