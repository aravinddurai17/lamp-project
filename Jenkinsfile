pipeline {
    agent { label 'slave' }

    environment {
        AWS_CREDS = credentials('aws-creds')
    }

    stages {

        stage("Checkout Repo") {
            steps {
                git 'https://github.com/aravinddurai17/lamp-project.git'
            }
        }

        stage("Terraform Apply") {
            steps {
                dir('terraform') {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                    export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                    terraform init
                    terraform plan
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage("Fetch EC2 IP") {
            steps {
                script {
                    EC2_IP = sh(script: "cd terraform && terraform output -raw ec2_public_ip", returnStdout: true).trim()
                    writeFile file: "ansible/inventory", text: "${EC2_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/mykey.pem"
                    echo "EC2 Server: ${EC2_IP}"
                }
            }
        }

        stage("Run Ansible") {
            steps {
                dir("ansible") {
                    sh "ansible-playbook -i inventory lamp.yml"
                }
            }
        }
    }

    post {
        success { echo "Deployment Completed Successfully" }
        failure { echo "Pipeline Failed — Check logs" }
    }
}
