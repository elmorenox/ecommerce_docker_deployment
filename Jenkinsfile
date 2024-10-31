pipeline {
    agent {
        label 'build-node'
    }
    
    environment {
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }
    
    stages {
        stage('Build & Push Images') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | sudo docker login -u $DOCKER_CREDS_USR --password-stdin'
                
                // Build and push backend
                sh """
                    sudo docker build \
                        -t morenodoesinfra/ecommerce-be:latest \
                        -f Dockerfile.backend .
                    
                    sudo docker push morenodoesinfra/ecommerce-be:latest
                """
                
                // Build and push frontend
                sh """
                   sudo docker build \
                        -t morenodoesinfra/ecommerce-fe:latest \
                        -f Dockerfile.frontend .
                        
                    sudo docker push morenodoesinfra/ecommerce-fe:latest
                """
            }
        }

        stage('Infrastructure') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve \
                            -var="dockerhub_username=${DOCKER_CREDS_USR}" \
                            -var="dockerhub_password=${DOCKER_CREDS_PSW}"
                    '''
                    
                }
            }
        }
    }
    
    post {
        always {
            sh 'sudo docker logout'
        }
    }
}