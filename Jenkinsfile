pipeline {
    agent {
        label 'agent'
    }
// Trigger every 5 minute for code change
    triggers {
        cron('H/5 * * * * ')
    }

    tools {
        terraform 'Terraform'
    }

// Check SCM for the code
    stages {
        stage('Get code') {
            steps {
                checkout scm
            }
        }
    }

// Get the code from the main branch and execute terraform commands
        stage('Deploy infrastrucure from Terraform code') {
            steps {
                dir('iac_aws_webapp') {
                    // Get database credentials from Jenkins and assign to TF_VARS
                    withCredentials([usernamePassword(credentialsId: 'db_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'export TF_VAR_USER=$USERNAME'
                        sh 'export TF_VAR_PASS=$PASSWORD'
                    }
                    git branch: 'main', url: 'https://github.com/kamilzaborowski/iac_aws_webapp'
                    withAWS(credentials:'AWS',region: 'us-east-1') {
                        sh 'terraform init && terraform apply -auto-approve -var db_name=webapp_db -var db_user=$TF_VAR_USER -var db_pass=$TF_VAR_PASS'
                    }
                }
            }
        }
// Deploy last terraform command to destroy EC2 instance
        stage('Destroy temporary EC2 instance') {
            steps {
                dir('iac_aws_webapp') {
                    withAWS(credentials:'AWS',region: 'us-east-1') {
                        sh 'terraform destroy -auto-approve -target aws_instance.server'
                    }
                }
            }
        }
// After pipeline execution, do the workspace cleanup
    post {
        always {
                cleanWs()
        }
    }
}