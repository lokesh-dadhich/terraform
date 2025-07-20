pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
  }

  stages {
    stage('Terraform') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'awscred',
                                          usernameVariable: 'AWS_ACCESS_KEY_ID',
                                          passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          sh 'terraform init'
          sh 'terraform plan'
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}
