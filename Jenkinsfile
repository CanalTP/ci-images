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
                            docker.withRegistry('', 'dockerhub-user') {
                                sh "make release_proj_artifacts"
                                sh "make release_proj"
                                sh "make release_rust"
                                sh "make release_rust_proj"
                            }
                        }
                    }
                }
                stage('tartare') {
                    steps {
                        script {
                            docker.withRegistry('', 'dockerhub-user') {
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
