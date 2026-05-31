# Azure Multi-VM Infrastructure & Ansible Automation Lab

This project automates the provisioning of a multi-VM Linux infrastructure on Microsoft Azure using **Terraform** and configures a distributed automation environment using **Ansible**. 

The infrastructure consists of an Ansible Control Node and a Managed Node to practice infrastructure-as-code (IaC) and configuration management.

---

## 1. Local Laptop Setup & Terraform Commands (Windows/PowerShell)

These commands are executed on your local machine to authenticateto Azure, format code, and manage the cloud infrastructure lifecycle.

*   `az login`
    *   **Description:** Authenticates your local CLI session with your Azure account by opening a browser window. It allows Terraform to deploy resources under your subscription.
*   `terraform init`
    *   **Description:** Initializes the local Terraform working directory. It downloads the necessary Azure provider plugins (`azurerm`) and sets up the backend configuration.
*   `terraform fmt`
    *   **Description:** Automatically rewrites and formats all Terraform configuration files (`.tf`) in the directory to adhere to canonical clean-code standards.
*   `terraform validate`
    *   **Description:** Validates the syntax, internal consistency, and argument correctness of your Terraform code without hitting cloud APIs.
*   `terraform plan`
    *   **Description:** Generates a speculative execution plan. It previews exactly which resources Terraform will create, modify, or destroy on Azure before making real changes.
*   `terraform apply`
    *   **Description:** Executes the actions proposed in a terraform plan to provision or update the infrastructure on Azure.
*   `terraform apply -auto-approve`
    *   **Description:** Runs the deployment instantly without prompting you to type `yes` in the terminal to confirm the changes.

---

## 2. Local Private Key Permissions & SSH Connection

Windows sets loose security permissions on newly generated files by default. SSH requires private keys (`.pem`) to be restricted strictly to the file owner.

*   `icacls.exe ./ansible_id_rsa.pem /inheritance:r`
    *   **Description:** Removes inherited permissions from the private key file that Windows automatically grants to background system groups and other users.
*   `icacls.exe ./ansible_id_rsa.pem /grant:r "$($env:USERNAME):(R,W)"`
    *   **Description:** Explicitly grants exclusive Read (R) and Write (W) permissions only to the currently logged-in user, satisfying the strict SSH client security requirements.
*   `ssh -i ./ansible_id_rsa.pem santosh_devops@13.70.30.159`
    *   **Description:** Establishes a secure shell (SSH) connection to the remote Ansible Control Node VM using the verified private key and specified username.

---

## 3. Ansible Control Node Environment Setup (VM-1)

Once inside the Control Node VM, these commands update system packages and install the latest stable version of Ansible Core via its official repository.

*   `sudo apt update`
    *   **Description:** Synchronizes the local package index with remote Ubuntu repositories to fetch list definitions for the newest available software versions.
*   `sudo apt install -y software-properties-common`
    *   **Description:** Installs standard scripts and utilities required to safely add independent Personal Package Archives (PPAs) to the system.
*   `sudo add-apt-repository --yes --update ppa:ansible/ansible`
    *   **Description:** Registers the official Ansible PPA team repository to the system's package source list and pulls the metadata immediately.
*   `sudo apt install -y ansible`
    *   **Description:** Fetches and installs the Ansible automation engine along with its required system dependencies.
*   `ansible --version`
    *   **Description:** Verifies a successful installation by displaying the active Ansible version, configuration file pathways, and Python interpreter details.

---

## 4. SSH Key Management & Host File Management (VM-1 Navigation)

These commands are used to create the workspace directory, store the target host configurations, and structure the deployment paths.

*   `vim ~/.ssh/ansible_id_rsa.pem`
    *   **Description:** Opens the Vim text editor to create and paste the private key content on the Control Node, enabling it to authenticate into managed targets.
*   `chmod 400 ~/.ssh/ansible_id_rsa.pem`
    *   **Description:** Restricts file permissions on Linux so that only the owner can read the file, protecting the private key from unauthorized system operations.
*   `mkdir ~/ansible-lab && cd ~/ansible-lab`
    *   **Description:** Creates a dedicated working directory named `ansible-lab` and immediately changes the active terminal shell context into it.
*   `vim hosts`
    *   **Description:** Launches the editor to create an Ansible inventory configuration file defining target managed nodes, host IPs, usernames, and authentication key mappings.
*   `ls -lrt` or `ll`
    *   **Description:** Lists all files and directories in long format sorted by modification time, displaying crucial metadata like file sizes, owners, and permissions.

---

## 5. Ansible Operations & Automation Execution

These commands run the actual ad-hoc automation tasks and structured configuration playbooks across your managed targets.

*   `export ANSIBLE_HOST_KEY_CHECKING=False`
    *   **Description:** Sets an environment variable that bypasses the strict interactive SSH host fingerprint prompt (`yes/no`) when Ansible talks to a new server for the first time.
*   `ansible managed_nodes -i hosts -m ping`
    *   **Description:** Invokes an Ansible ad-hoc execution using the `ping` module against the server group defined in your custom inventory file to verify active end-to-end connectivity.
*   `vim webserver.yml`
    *   **Description:** Creates a structured Ansible Playbook file written in YAML format to declare configuration tasks, roles, and system installation procedures.
*   `ansible-playbook -i hosts webserver.yml`
    *   **Description:** Executes the configuration playbooks sequentially, prompting Ansible to connect to the managed targets, escalate privileges, and execute the declared state changes (e.g., installing Nginx).
