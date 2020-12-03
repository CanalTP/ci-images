// Declarative syntax
pipeline {
    agent any
    stages {
        stage('Release') {
            when {
                anyOf {
                    branch 'master'
                    buildingTag()
                }
            }
            parallel {
                stage('rust') {
                    steps {
                        script {
                            docker.withRegistry('', 'kisiodigital-user-dockerhub') {
                                sh "make release_rust"
                                sh "make release_rust_proj"
                            }
                        }
                    }
                }
                stage('tartare') {
                    steps {
                        script {
                            docker.withRegistry('', 'kisiodigital-user-dockerhub') {
                                sh "make release_tartare"
                            }
                        }
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
