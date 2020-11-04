pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
   
    
    stages {
        Stage('Git Checkout Master'){
            git credentialsId: '47222948-2be9-41d3-9afa-84568360ae36', branch: 'master', url: 'https://github.com/priyankajbhagatt/simple-java-maven-app'
            echo 'Master Branch'
        }
       
        /*stage ('Build') {
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
       // }*/
        stage ('Check terraform Version') {
            steps {
                sh 'terraform version'
            }
        }
        stage ('Validate terraform') {
            steps {
                withCredentials([azureServicePrincipal('Azure')]) {
                  sh 'terraform validate'
}
              
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
