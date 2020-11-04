pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
   
    
    stages {
       
        stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml' 
                }
            }
        }
        //stage ('Initialize Mven') {
         //   steps {
         //       sh 'mvn verify'
          //  }
       // }
        stage ('Check terraform Version') {
            steps {
                sh 'terraform version'
            }
        }
        stage ('Validate terraform') {
            steps {
                sh 'terraform validate'
            }
        }
        stage ('Initialize terraform') {
            steps {
                sh 'terraform init'
            }
        }
         stage ('Plan terraform') {
            steps 
            {
                sh 'terraform plan'
            }
         
        }
    }
}
