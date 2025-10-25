pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/dogor123/proyecto_2_corte.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("tebancito/proyecto_2_corte:latest")
                }
            }
        }

        stage('Test App') {
            steps {
                echo 'Testing app...'
                // Aquí podrías agregar tests simples si lo deseas
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-cred') {
                        dockerImage.push('latest')
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

