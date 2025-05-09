pipeline {
    agent {
        label 'build-node'
    }
    
    environment {
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }
        
    stages {
        stage('Destroy GCP Infrastructure') {
            steps {
                input message: 'Are you sure you want to destroy the infrastructure?', ok: 'Yes, destroy it'
                
                sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
                    export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
                    terraform init
                    terraform destroy -auto-approve \
                        -var="dockerhub_username=${DOCKER_CREDS_USR}" \
                        -var="dockerhub_password=${DOCKER_CREDS_PSW}"
                '''
            }
        }
    }
    
    post {
        success {
            echo 'Infrastructure destroyed successfully!'
        }
        failure {
            echo 'Failed to destroy infrastructure. Check the logs for details.'
        }
    }
}