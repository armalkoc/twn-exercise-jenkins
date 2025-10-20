@Library('exc-jenkins-shared-library')

pipeline {
    agent any

    tools {
        nodejs "my-nodejs"
    }

    stages {
        stage("Increment App Version") {
            steps {
                script {
                    incrementVersion()
                    }
                }
            }

        }
        stage("Runn App Code Test") {
            steps {
                script {
                    codeTest()
                    }
                }
            }
        stage("Build and Push DokcerImage") {
            steps {
                script {
                    buildPush()
                }
            }
        }
        stage("Commit Version Update") {
            steps {
                script {
                    commitUpdate()
                }
            }
        }
    
}