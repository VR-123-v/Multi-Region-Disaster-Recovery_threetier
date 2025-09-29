pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION     = 'us-east-1'
        SECONDARY_REGION       = 'us-west-2'
        TERRAFORM_DIR          = 'terraform'
        TF_VAR_S3_PRIMARY_PREFIX   = 'primary-vr'
        TF_VAR_S3_SECONDARY_PREFIX = 'secondary-vr'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/VR-123-v/Multi-Region-Disaster-Recovery_threetier.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Sync Web Content to S3') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh './scripts/s3-sync.sh'
                }
            }
        }

        stage('Trigger Failover Check') {
            steps {
                dir("${env.TERRAFORM_DIR}") {
                    sh './scripts/failover.sh'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            echo "Pipeline failed. Check console output."
            // mail step can be enabled if SMTP is configured
        }
    }
}
