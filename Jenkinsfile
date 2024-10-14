pipeline {
    agent any
    environment {
        NGINX_NAME = "node-app-test-new"
        COMPOSE_REPO_URL = 'https://github.com/Vignesh2064/cicd-docker-compose.git'
    }
    stages {
        stage('Set Version') {
            steps {
                script {
                    // Calculate VERSION here
                    env.VERSION = sh(script: "date +'%Y-%m-%d-%H-%M-%S'", returnStdout: true).trim() + "-frontend-build-${env.BUILD_NUMBER}"
                    echo "Set VERSION to ${env.VERSION}"
                }
            }
        }
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout Node App Code') {
            steps {
                git 'https://github.com/Vignesh2064/node-todo-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${NGINX_NAME}:${env.VERSION} ."
        
                    // Remove old images
                    sh """
                        IMAGES=\$(docker images --format '{{.Repository}}:{{.Tag}}' | grep ${NGINX_NAME} | sort | head -n -5)
                        if [ -n "\$IMAGES" ]; then
                            echo "Removing old images:"
                            echo \$IMAGES
                            docker rmi \$IMAGES || true
                        fi
                    """
                }
            }
        }

        stage("Checkout Deployment Code") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/Vignesh2064/cicd-docker-compose.git'
            }
        }
        stage("Update the Deployment Tags") {
            steps {
                script {
                    sh """
                        echo "Before Update:"
                        cat docker-compose.yaml
                        sed -i 's/${NGINX_NAME}:.*/${NGINX_NAME}:${env.VERSION}/g' docker-compose.yaml
                        echo "After Update:"
                        cat docker-compose.yaml
                    """
                }
            }
        }
        stage("Push the Changed Deployment File to Git") {
            steps {
                script {
                    sh """
                        git config --global user.name "Vignesh2064"
                        git config --global user.email "Vignesh271297@gmail.com"
                        git add docker-compose.yaml
                        git commit -m "Updated Deployment Manifest with version ${env.VERSION}"
                    """
                    withCredentials([gitUsernamePassword(credentialsId: 'github', gitToolName: 'Default')]) {
                        sh "git push https://github.com/Vignesh2064/cicd-docker-compose.git main"
                    }
                }
            }
        }
    }
}
