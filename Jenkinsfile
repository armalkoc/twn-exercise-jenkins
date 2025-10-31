@Library('exc-jenkins-shared-library')_

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
        stage("deploy to EC2") {
            steps {
                script {
                    def ec2Instance = "ec2-user@52.28.226.185"
                    def shellCmd = "bash ./server-cmds.sh ${env.IMAGE_NAME}"
                    sshagent(['ec2-server-key2']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
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
}