def backendDockerTag=""
def frontendDockerTag=""
def frontendImage="kamilzaborowski/frontend"
def backendImage="kamilzaborowski/backend"
def dockerRegistry=""
def registryCredentials="Dockerhub"

withCredentials([usernamePassword(credentialsId: 'db_creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
  sh 'cf login some.awesome.url -u $USERNAME -p $PASSWORD'

}

pipeline {
    agent {
        label 'agent'
    }

    triggers {
           cron('H/5 * * * * ')

    tools {
        terraform 'Terraform'
    }

     parameters {
        string(name: 'backendDockerTag', defaultValue: '', description: 'Backend docker image tag')
        string(name: 'frontendDockerTag', defaultValue: '', description: 'Frontend docker image tag')
    }

    stages {
        stage('Get code') {
            steps {
                checkout scm
            }
        }

        stage('Adjust version') {
            steps {
                script {
                    backendDockerTag = params.backendDockerTag.isEmpty() ? "latest" : params.backendDockerTag
                    frontendDockerTag = params.frontendDockerTag.isEmpty() ? "latest" : params.frontendDockerTag
                    currentBuild.description = "Backend: ${backendDockerTag}, Frontend: ${frontendDockerTag}"
                }
            }
        }

        stage('Deploy application') {
            steps {
                script {
                    withEnv(["FRONTEND_IMAGE=$frontendImage:$frontendDockerTag","BACKEND_IMAGE=$backendImage:$backendDockerTag"]) {
                        docker.withRegistry("$dockerRegistry","$registryCredentials") {
                            sh "docker-compose up -d"
                        }
                    }
                }
            }
        }

        stage('Selenium tests') {
            steps {
                sh "pip3 install -r test/selenium/requirements.txt"
                sh "python3 -m pytest test/selenium/frontendTest.py"
            }
        }

        stage('Run terraform') {
            steps {
                dir('Terraform') {
                    git branch: 'main', url: 'https://github.com/kamilzaborowski/Terraform'
                    withAWS(credentials:'AWS',region: 'us-east-1') {
                        sh 'terraform init && terraform apply -auto-approve -var-file="terraform.tfvars"'
                    }
                }
            }
        }

        stage('Destroy temporary EC2') {
            steps {
                dir('Terraform') {
                    git branch: 'main', url: 'https://github.com/kamilzaborowski/Terraform'
                    withAWS(credentials:'AWS',region: 'us-east-1') {
                        sh 'terraform init && terraform apply -auto-approve -var-file="terraform.tfvars"'
                    }
                }
            }
        }

    post {
        always {
            withEnv(["FRONTEND_IMAGE=$frontendImage:$frontendDockerTag","BACKEND_IMAGE=$backendImage:$backendDockerTag"]) {
                sh "docker-compose down"
                cleanWs()
            }
        }
    }
}   