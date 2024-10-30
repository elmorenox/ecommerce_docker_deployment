pipeline {
    agent {
        label 'build-node'
    }
    
    environment {
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/elmorenox/dockerized-ecommerce-on-ec2'
            }
        }

        stage('Infrastructure') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                    
                    script {
                        env.EC2_IP = sh(
                            script: 'terraform output -raw ec2_private_ip',
                            returnStdout: true
                        ).trim()
                        
                        env.RDS_ENDPOINT = sh(
                            script: 'terraform output -raw rds_endpoint',
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        
        stage('Build & Push Images') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                
                // Build and push backend
                sh """
                    docker build \
                        --build-arg DB_HOST=$RDS_ENDPOINT \
                        -t morenodoesinfra/ecommerce-be:latest \
                        -f Dockerfile.backend .
                    
                    docker push morenodoesinfra/ecommerce-be:latest
                """
                
                // Build and push frontend
                sh """
                    docker build \
                        -t morenodoesinfra/ecommerce-fe:latest \
                        -f Dockerfile.frontend .
                        
                    docker push morenodoesinfra/ecommerce-fe:latest
                """
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                sshagent(['ssh-credentials']) {
                    sh """
                        scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@${EC2_IP}:~/
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_IP} '
                            docker login -u $DOCKER_CREDS_USR -p $DOCKER_CREDS_PSW
                            docker-compose pull
                            docker-compose up -d
                        '
                    """
                }
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
        }
    }
}