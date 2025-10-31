@Library('exc-jenkins-shared-library')_

pipeline {
    
    agent any

    tools {
        nodejs "my-nodejs"
    }

    stages {
        stage("Increment App Version") {
            when {
                expression {
                    return env.GIT_BRANCH == "master"
                }
            }
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
            when {
                expression {
                    return env.GIT_BRANCH == "master"
                }
            }
            steps {
                script {
                    buildPush()
                }
            }
        }
        stage("deploy to EC2") {
            when {
                expression {
                    return env.GIT_BRANCH == "master"
                }
            }
            steps {
                script {
                    
                    def ec2Instance = "ec2-user@52.28.226.185"
                    def shellCmd = "bash ./server-cmds.sh amalkoc/twn-demo-app:twn-exc-aws-app-${IMAGE_NAME}"
                    sshagent(['ec2-server-key2']) {
                        sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }
        }
        stage("Commit Version Update") {
            when {
                expression {
                    return env.GIT_BRANCH == "master"
                }
            }
            steps {
                script {
                    commitUpdate()
                }
            }
        }
    }
}