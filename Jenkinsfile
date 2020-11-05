pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
     /*environment {
      subscription_id = credentials('azure-subscription-id')
      tenant_id = credentials('azure-tenant-id')
      client_id = credentials('client-id-jenkins-sp')
      client_secret = credentials('client-secret-jenkins-sp')
     */
    stages {
        stage ('Git Checkout'){
            steps {
            git credentialsId: '47222948-2be9-41d3-9afa-84568360ae36', branch: 'master', url: 'https://github.com/priyankajbhagatt/simple-java-maven-app'
            echo 'Master Branch'
        }
        }
       
        /*stage ('Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true install' 
            }
            post {
                success {
                    junit 'target/surefire-reports/*
                }
            }
        }*/
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
                withCredentials([azureServicePrincipal('Azure')]) {
                   // sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                  sh 'terraform validate'
}
              
            }
        }
        stage ('Initialize terraform') {
            steps {
                withCredentials([azureServicePrincipal('Azure')]) {
                    sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                sh 'terraform init'
            }
        }
        }
         stage ('Plan terraform') {
            steps 
            {
                withCredentials([azureServicePrincipal('Azure')]) {
                    sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                sh 'terraform plan'
            }
            }
        }
    }
}
