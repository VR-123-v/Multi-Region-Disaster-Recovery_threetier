pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION     = 'us-east-1'       // Primary region
        SECONDARY_REGION       = 'us-west-2'       // Secondary region
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
                sh 'jenkins/scripts/s3-sync.sh'
            }
        }

        stage('Trigger Failover Check') {
            steps {
                sh 'jenkins/scripts/failover.sh'
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully!'
        }
        failure {
            mail to: 'vimalgrm@gmail.com',
                 subject: "DR Pipeline Failed: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                 body: "Check Jenkins console output for failure details."
        }
    }
}
