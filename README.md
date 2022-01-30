# demo_cluster
## Setup a demo cluster
    1. Clone the Repo
    2. Install Terraform
        Linux:  
            sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
            sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
            sudo apt-get update && sudo apt-get install terraform
            terraform -help
    3. Change director to terraform
            cd demo_cluster/terraform
    4. Update the variables tfvars/variables.tfvars
    5. Execute the terraform to setup EC2 instance, create DNS, setup kubectl and minikube.
            terraform init
            terraform plan -var-file=./tfvars/variables.tfvars
            terraform apply -var-file=./tfvars/variables.tfvars -auto-approve
    6. Ssh to server 
            ssh -i <Path to key> ubuntu@<IP>
    7. Check the argocd pod
            kubectl get pods -n argocd
    8. Update the argocd pods to use node port from outside access
        Edit the argocd service file
            kubectl edit svc argocd-server -n argocd
        Update the type from ClusterIP to NodePort
        Save and exit the file
        Fetch the port mapped to 80 to access the Argocd UI
            kubectl get svc -n argocd
    9. Fetch the Argocd first time access token from the ec2 server 
            kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    10. Open Browser and open the following URL
            <Public IP EC2>:<Port>
    11. Login to Argocd        
            Username: admin
            Password: <Access Token>
            
## Setup Github CI CD
    1. Open the github repository
    2. Add the following secrets in the github
            Click on settings -> Secrets -> Actions - New repository secret
                AWS_ACCESS_KEY_ID
                AWS_SECRET_ACCESS_KEY
                AWS_REGION
                REPO_TOKEN
    3. Crete the ECR Repository in the region specified above
    4. Update the ECR Repository path in the charts/helm-example/values.yaml
    5. Add the git repo in the Argocd
        Click on Manage Repository and add the repository
            Click on Repository -> Connect repo using HTTPS
            Repository URL:
            Username: 
            Password:
    6. Add the application on Argocd  
        While creating application you have to add the following:
            1. Application Name.
            2. Project Name (default)
            3. Sync Policy → Manual / Automatic
            4. Source → GitHub repo of your manifest files.
            5. Path → (folder name in my case argocd-deployment).
            6. Cluster URL → Kubernetes Cluster URL.
            7. Name-Space → default (or create your own namespace manually).
            8. Click On Create.
    7. Push any changes in the file and it will automatically updates on cluster using CI/Cd
      

