pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
    stages {
        
        stage('Terraform version') {
            steps {
            sh 'terraform version'
            }
           }
           
       }
       }
