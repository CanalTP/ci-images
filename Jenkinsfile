// Declarative syntax
pipeline {
    agent any
    stages {
        stage ('Info') {
            parallel {
                stage ('System') {
                    steps {
                        sh "hostname"
                        sh "uptime"
                        sh "free -mh"
                        sh "df -h"
                        sh "pwd"
                        sh "git --version"
                        sh "make --version"
                    }
                }
                stage ('Docker') {
                    steps {
                        sh "docker --version"
                        sh "docker-compose --version"
                        sh "docker system df"
                        sh "docker images"
                        sh "docker ps -a"
                    }
                }
            }
        }
        stage ('Release') {
            when {
                anyOf {
                    branch 'master'
                    buildingTag()
                }
            }
            steps {
                script {
                    docker.withRegistry('', 'kisiodigital-user-dockerhub') {
                        sh "make release_base"
                        sh "make release_proj"
                    }
                }
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
