pipeline {
    agent any

    environment {
        GOOGLE_APPLICATION_CREDENTIALS = "/tmp/gcp-key.json"
    }

    triggers {
        githubPush()
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                url: 'https://github.com/rebelvijay/GCP.git'
            }
        }

        stage('Copy GCP Key') {
            steps {
                withCredentials([file(credentialsId: 'gcp', variable: 'GCP_KEY')]) {
                    sh '''
                        cp $GCP_KEY /tmp/gcp-key.json
                        chmod 600 /tmp/gcp-key.json
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }

    post {
        success {
            echo 'Pipeline executed successfully'
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}
