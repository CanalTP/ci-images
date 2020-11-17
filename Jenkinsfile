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
