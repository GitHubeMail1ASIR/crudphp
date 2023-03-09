pipeline {
    environment {
        IMAGENAME = 'githubemail1asir/crudphp'
        LOGIN = 'USER_DOCKER_HUB'
    }
    agent none
    stages {
        stage('Construcción imagen docker y despliegue en VPS') {
            agent any
            stages {
                stage('Clone') {
                    steps {
                        git branch:'main',url:'https://github.com/GitHubeMail1ASIR/crudphp.git'
                    }
                }
                stage('Prebuild sin caché') {
                    steps {
                        sh 'docker build --no-cache -t $IMAGENAME:latest .'
                    }
                }
                stage('Build') {
                    steps {
                        script {
                            newApp = docker.build "$IMAGENAME:latest"
                        }
                    }
                }
                stage('Subir Imagen') {
                    steps {
                        script {
                            docker.withRegistry( '', LOGIN ) {
                                newApp.push()
                            }
                        }
                    }
                }
                stage('Borrar Imagen') {
                    steps {
                        sh "docker rmi -f $IMAGENAME:latest"
                    }
                }
                stage('SSH a VPS') {
                    steps {
                        sshagent(['SSH_USUARIO']) {
                            sh 'ssh -o StrictHostKeyChecking=no juanje@tesis.juanje.net docker rmi -f $IMAGENAME:latest'
                            sh 'ssh -o StrictHostKeyChecking=no juanje@tesis.juanje.net wget https://raw.githubusercontent.com/GitHubeMail1ASIR/crudphp/main/docker-compose.yaml -O docker-compose.yaml'
                            sh 'ssh -o StrictHostKeyChecking=no juanje@tesis.juanje.net docker-compose up -d --force-recreate'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'jjas-asir2@Debian',
            subject: "Status of pipeline: ${currentBuild.fullDisplayName}",
            body: "${env.BUILD_URL} has result ${currentBuild.result}"
        }
    }
}
