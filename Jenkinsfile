pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = "tebancito/proyecto_2_corte"
        DOCKER_HUB_CREDENTIALS = "dockerhub-cred" // ID configurado en Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dogor123/proyecto_2_corte.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Test App') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'php -v'
                        sh 'composer validate --no-check-publish'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}

