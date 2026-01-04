pipeline {
  agent any
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
    stage('Init Terraform') {
      steps {
        dir("${env.BRANCH_NAME}") {
          sh 'terraform init'
        }
      }
    }
    stage('Plan Terraform') {
      steps {
        dir("${env.BRANCH_NAME}") {
          sh 'terraform plan -out=tfplan'
        }
      }
    }
    stage('Apply Terraform') {
      when {
        branch 'prod'
      }
      steps {
        dir("${env.BRANCH_NAME}") {
          input message: "Do you want to apply changes to production?"
          sh 'terraform apply tfplan'
        }
      }
    }
    stage('Apply to Stage') {
      when {
        branch 'stage'
      }
      steps {
        dir("${env.BRANCH_NAME}") {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
  post {
    always {
      dir("${env.BRANCH_NAME}") {
        sh 'terraform output'
      }
    }
  }
}
