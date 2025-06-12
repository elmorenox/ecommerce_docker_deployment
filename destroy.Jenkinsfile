pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Init') {
            agent { label 'jenkins-node' }
            steps {
                dir('terraform') {
                    withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh '''
                        terraform init
                        '''
                    }
                }
            }
        }
        
        stage('Terraform Destroy') {
            agent { label 'jenkins-node' }
            steps {
                dir('terraform') {
                    withCredentials([
                        usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'),
                        usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
                    ]) {
                        sh '''
                        terraform destroy -auto-approve \
                          -var="dockerhub_username=$DOCKER_USERNAME" \
                          -var="dockerhub_password=$DOCKER_PASSWORD"
                        '''
                    }
                }
            }
        }
    }
    
    post {
        failure {
            echo 'Destroy pipeline failed! Check the logs for details.'
        }
        success {
            echo 'Infrastructure destroyed successfully!'
        }
    }
}