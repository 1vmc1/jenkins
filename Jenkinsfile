pipeline {
  agent { label 'vmc2' }

  environment {
    IMAGE = "myorg/myapp"
    TAG   = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
        sh 'ls -la'
      }
    }

    stage('Build Docker image') {
      steps {
        sh "docker build -t ${IMAGE}:${TAG} ."
        sh "docker images | grep ${IMAGE} || true"
      }
    }

    stage('Save & Archive') {
      steps {
        sh "docker save ${IMAGE}:${TAG} -o ${WORKSPACE}/${IMAGE.replace('/', '_')}_${TAG}.tar"
        archiveArtifacts artifacts: "${IMAGE.replace('/', '_')}_${TAG}.tar", fingerprint: true
      }
    }
  }

  post {
    success { echo "Build and image ready: ${IMAGE}:${TAG}" }
    always { cleanWs() }
  }
}
