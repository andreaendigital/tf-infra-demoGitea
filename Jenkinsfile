pipeline {
  agent any


    parameters {
        booleanParam(name: 'PLAN_TERRAFORM', defaultValue: true, description: 'Run terraform plan to preview infrastructure changes')
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: true, description: 'Apply infrastructure changes using terraform apply')
        booleanParam(name: 'DEPLOY_ANSIBLE', defaultValue: true, description: 'Run Ansible to deploy the Flask application')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Destroy infrastructure using terraform destroy')
    }

  environment {
    ANSIBLE_DIR       = 'configManagement-carPrice'
    INVENTORY_SCRIPT  = "${ANSIBLE_DIR}/generate_inventory.sh"
    INVENTORY_FILE    = "${ANSIBLE_DIR}/inventory.ini"
    PLAYBOOK_FILE     = "${ANSIBLE_DIR}/playbook.yml"
    DISCORD_WEBHOOK_URL ="https://discord.com/api/webhooks/1437993582756888648/wG9NzvbVm2zkXK6BYNItaS38CcpGo5tZrV8idq5Gk3aKQReQOyMa44mavFY23oqQJFyj"
    
  }




    stages {

        stage('Clone Repositories') {
            steps {
                echo 'Cleaning workspace and cloning repositories...'
                deleteDir()

               //1. Clone Repo (Terraform)
                git branch: 'main', url: 'https://github.com/andreaendigital/tf-infra-demoGitea'

                // 2. Clone Repo (Ansible)
                dir("${ANSIBLE_DIR}") {
                    checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/andreaendigital/ansible-demoGitea']]])
                }
          

            }
        }


        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-gitea']]) {
                    dir('infra') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            when {
                expression { return params.PLAN_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-gitea']]) {
                    dir('infra') { // .tf files must be here
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-gitea']]) {
                    dir('infra') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY_TERRAFORM }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-gitea']]) {
                    dir('infra') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }



        stage('Generate Ansible Inventory') {
            when {
                expression { return params.DEPLOY_ANSIBLE }
            }
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-jenkins-gitea']]) {
                sh "chmod +x ${INVENTORY_SCRIPT}"
                sh "${INVENTORY_SCRIPT}"
                }
            }
        }

        stage('Run Ansible Playbook') {
            when {
                expression { return params.DEPLOY_ANSIBLE }
            }
            steps {
                sshagent(credentials: ['ansible-ssh-key']) {
                sh "ansible-playbook -i ${INVENTORY_FILE} ${PLAYBOOK_FILE} --extra-vars 'ansible_ssh_common_args=\"-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\"'"
                }
            }
        }


    }


    post {
        success {
            echo 'Deployment completed successfully!'

            // Discord Notification
            script {
                sh '''
                    # Discord Message with Markdown 
                    MESSAGE=" Success: The pipeline **${JOB_NAME}** finish correctly #${BUILD_NUMBER}."
                    
                    # Use cURL to send Webhook
                    curl -X POST ${DISCORD_WEBHOOK_URL} \
                         -H 'Content-Type: application/json' \
                         -d "{\\"username\\": \\"Jenkins Bot\\", \\"content\\": \\"${MESSAGE}\\", \\"embeds\\": [ { \\"description\\": \\"[Ver en Jenkins](${BUILD_URL})\\", \\"color\\": 65280 } ]}"
                '''
            }

            echo 'Deployment completed successfully!'

        }


        failure {
            echo 'Deployment failed. Check logs and Terraform state.'
            
            // Discord Notification
            script {
                sh '''
                    # Discord Message with Markdown 
                    MESSAGE="Deployment failed. Pipeline: **${JOB_NAME}** -  #${BUILD_NUMBER}."
                    
                    curl -X POST ${DISCORD_WEBHOOK_URL} \
                         -H 'Content-Type: application/json' \
                         -d "{\\"username\\": \\"Jenkins Bot\\", \\"content\\": \\"${MESSAGE}\\", \\"embeds\\": [ { \\"description\\": \\"[Revisar el Fallo](${BUILD_URL})\\", \\"color\\": 16711680 } ]}"
                '''
            }


            echo 'Deployment failed. Check logs and Terraform state.'


        }
    }
}
