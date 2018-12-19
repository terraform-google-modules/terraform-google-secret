pipeline {
    agent any
    options {
        // This will activate red and green text - turn this off for vision accessibility reasons
        ansiColor('xterm')
        // Prevent more than one of this pipeline from running at once
        disableConcurrentBuilds()
    }
    triggers {
        // Run the job hourly
        cron('H * * * *')
    }
    environment {
        // Service Account to use
        SA = "PLACE SERVICE ACCOUNT HERE"
        // Service Account credentials
    }
    stages {
        stage('Update secrets') {
            steps {
                sh "${env.WORKSPACE}/infra/scripts/list-secrets.sh"
            }
        }
        stage('Commit secrets') {
            steps {
                sh "${env.WORKSPACE}/infra/jenkins/commit-list.sh"
            }
        }
    }
    // Post describes the steps to take when the pipeline finishes
    post {
        //changed {}
        //aborted {}
        //failure {}
        //success {}
        //unstable {}
        //notBuilt {}
        always {
            echo "Clearing workspace"
            deleteDir() // Clean up the local workspace so we don't leave behind a mess, or sensitive files
        }
    }
}