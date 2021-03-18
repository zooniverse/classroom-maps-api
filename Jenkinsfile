#!groovy

pipeline {
  agent none

  options {
    disableConcurrentBuilds()
  }

  stages {
    stage('Build Classroom Maps API Docker image') {
      agent any
      steps {
        script {
          def dockerRepoName = 'zooniverse/classroom-maps-api'
          def dockerImageName = "${dockerRepoName}:${GIT_COMMIT}"
          def newImage = docker.build(dockerImageName)
          newImage.push()

          if (BRANCH_NAME == 'main') {
            stage('Update latest tag') {
              newImage.push('latest')
            }
          }
        }
      }
    }

    stage('Dry run deployments') {
      agent any
      steps {
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-production.tmpl | kubectl --context azure apply --dry-run=client --record -f -"
      }
    }

    stage('Deploy production to Kubernetes') {
      when { branch 'main' }
      agent any
      steps {
        sh "sed 's/__IMAGE_TAG__/${GIT_COMMIT}/g' kubernetes/deployment-production.tmpl | kubectl --context azure apply --record -f -"
      }
    }
  }

  post {
    success {
      script {
        if (BRANCH_NAME == 'main') {
          slackSend (
            color: '#00FF00',
            message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})",
            channel: "#ops"
          )
        }
      }
    }

    failure {
      script {
        if (BRANCH_NAME == 'main') {
          slackSend (
            color: '#FF0000',
            message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})",
            channel: "#ops"
          )
        }
      }
    }
  }
}
