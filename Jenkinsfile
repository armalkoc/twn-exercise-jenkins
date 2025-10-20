pipeline {
    agent any

    tools {
        nodejs "my-nodejs"
    }

    stages {
        stage("Increment App Version") {
            steps {
                script {
                    // we have to enter inside app directory because thats where our package.json is located
                    dir("app") {
                        // update app version in the package.js file with one of the release types: major, minor or patch
                        // following command updates the minor version in package.json and ensures no Git commands are executed in the background, preventing automatic commits or tags in your Jenkins Pipeline
                        sh 'npm version minor --no-git-tag-version'
                        
                        // after version has been changed we have to read version from package.json file and store it in the version variable
                        def packageJson = readJSON file: 'package.json'
                        def version = packageJson.version
                        
                        // here we will define our image name based on version variable and build number variable
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"

                        // alternative solution without Pipeline Utility Steps plugin:
                        // def version = sh (returnStdout: true, script: "grep 'version' package.json | cut -d '\"' -f4 | tr '\\n' '\\0'")
                        env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                    }
                }
            }

        }
        stage("Runn App Code Test") {
            steps {
                script {
                    // we have to get inside app directory to be able to run test
                    dir("app") {
                        sh 'npm install'
                        sh 'npm test'
                    }
                }
            }
        }
        stage("Build and Push DokcerImage") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-am', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "docker build -t amalkoc/twn-demo-app:twn-exc-app-${IMAGE_NAME}"
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push amalkoc/twn-demo-app:twn-exc-app-${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("Commit Version Update") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-am', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'git config --global user.email armin.bootcamp@gmail.com'
                        sh 'git config --global user.name "armalkoc"'
                        sh 'git remote set-url origin https://$USER:$PASS@github.com/armalkoc/twn-exercise-jenkins.git'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push'
                    }
                }
            }
        }
    }
}