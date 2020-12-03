// Declarative syntax
pipeline {
    agent any
    stages {
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
                        sh "make release_rust"
                        sh "make release_rust_proj"
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
