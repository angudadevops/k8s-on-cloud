
azurecli() {
systype=$(uname -s)

if [[ $systype == "Linux" ]]; then
	echo "Installing Azure CLI for Azure Authentication"
	curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
elif [[ $systype == "Darwin" ]]; then
	echo "Installing Azure CLI for Azure Authentication"
	brew update && brew install azure-cli
else
	echo "System should be either Mac or Linux"
	exit 0
fi
}

terraforminstall() {
	systype=$(uname -s)

if [[ $systype == "Linux" ]]; then
        echo "Installing Terraform"
        curl -sL https://raw.github.com/robertpeteuil/terraform-installer/master/terraform-install.sh > terraform-install.sh
        chmod +x terraform-install.sh
        ./terraform-install.sh
	rm -rf terraform-install.sh
elif [[ $systype == "Darwin" ]]; then
        echo "Installing Terraform"
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
else
        echo "System should be either Mac or Linux"
        exit 0
fi
}

installansible() {
systype=$(uname -s)
if [[ $systype == "Linux" ]]; then
        echo "Installing Ansible"
	os=$(cat /etc/os-release | grep -iw ID | awk -F'=' '{print $2}')
	version=$(cat /etc/os-release | grep -i VERSION_CODENAME | awk -F'=' '{print $2}')
	if [[ $os == "ubuntu" && $version != "focal" ]]; then
		echo "Installing Ansible"
        	sudo apt-add-repository ppa:ansible/ansible -y
        	sudo apt update
        	sudo apt install ansible -y
	elif [[ $os == "ubuntu" && $version == "focal" ]]; then
		echo "Installing Ansible"
		sudo apt update
        	sudo apt install ansible -y
	elif [ $os == "rhel*" ]; then
		version=$(cat /etc/os-release | grep VERSION_ID | awk -F'=' '{print $2}')
		if [ $version == "*7.*" ]; then
			sudo subscription-manager repos --enable rhel-7-server-ansible-2.9-rpms
			sudo yum install ansible -y
		elif [ $version == "*8.*" ]; then
			sudo subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
			sudo yum install ansible -y
		fi
	fi
elif [[ $systype == "Darwin" ]]; then
        echo "Installing Ansible"
        brew install ansible
else
        echo "System should be either Mac or Linux"
        exit 0
fi
}

if [[ $1 == "azure" ]]; then
	installansible
	azurecli    
	echo "Login to Azure Account using your browser"
	az login
	echo "Login Successfull"
        terraforminstall
	cd terraform/azure
	terraform init
	terraform plan 
	terraform apply -auto-approve
	terraform output inventory > ../../ansible/inventory
	rm -rf azure.pem
	terraform ouput tls_private_key > azure.pem
	chmod 400 azure.pem

	echo "Please wait for a while to bring azure vm's are up"

	sleep 60
	cd ../../ansible
	ansible -m ping -i inventory all
	ansible-playbook -i inventory prerequisites.yaml
	ansible-playbook -i inventory k8s.yaml
elif [[ $1 == "aws" ]]; then
	installansible
	terraforminstall
	cd terraform/aws
	terraform init
	terraform plan
	terraform apply -auto-approve
	terraform output inventory > ../../ansible/inventory

	echo "Please wait for a while to bring aws instances up"

	sleep 60
	cd ../../ansible
	ansible -m ping -i inventory all
	ansible-playbook -i inventory prerequisites.yaml
	ansible-playbook -i inventory k8s.yaml
else
	echo -e "Usage\n\nAvailable Options:\n\n   aws:	To Provision Kubernetes Cluster on AWS\n   azure:	To Provision Kubernetes Cluster on Azure\n"
fi
