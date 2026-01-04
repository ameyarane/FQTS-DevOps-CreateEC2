pipeline {
  agent { label 'terraform' }   // Use your agent's label here
  environment {
    AWS_DEFAULT_REGION = 'eu-west-1'
    TF_VAR_instance_type = 't2.micro'
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Init & Plan Terraform') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh 'terraform init'
          //sh 'terraform plan -out=tfplan'
          sh "terraform plan -var='environment=${env.BRANCH_NAME}' -out=tfplan"
        }
      }
    }
    stage('Apply Terraform') {
      when {
        branch 'prod'
      }
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          input message: "Do you want to apply changes to production?"
          //sh 'terraform apply tfplan'
          sh "terraform apply -var='environment=${env.BRANCH_NAME}' -auto-approve"
        }
      }
    }
    stage('Apply to Stage') {
      when {
        branch 'stage'
      }
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh "terraform apply -var='environment=${env.BRANCH_NAME}' -auto-approve"
        }
      }
    }
  }
  post {
  always {
    withCredentials([
      string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
      string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
    ]) {
      script {
        def ip = sh(script: "terraform output -raw instance_public_ip", returnStdout: true).trim()
        echo "EC2 Instance Public IP: ${ip}"
      }
    }
  }
}

}
