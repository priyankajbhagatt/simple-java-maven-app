pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform13.5'
    }
     /*environment {
      subscription_id = credentials('azure-subscription-id')
      tenant_id = credentials('azure-tenant-id')
      client_id = credentials('client-id-jenkins-sp')
      client_secret = credentials('client-secret-jenkins-sp')
     */
    stages {
        stage ('Git Checkout Feature'){
            steps {
            git credentialsId: '47222948-2be9-41d3-9afa-84568360ae36', branch: 'feature', url: 'https://github.com/priyankajbhagatt/simple-java-maven-app'
            echo 'Feature Branch'
        }
        }
        stage ('Git Checkout Master'){
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
                withCredentials([azureServicePrincipal(credentialsId: 'az-jenkins-sp',

                                                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',

                                                clientIdVariable: 'ARM_CLIENT_ID',

                                                clientSecretVariable: 'ARM_CLIENT_SECRET',

                                                tenantIdVariable: 'ARM_TENANT_ID')]) {
                                                // Perform Azure login with provided ServicePrincipal credentials
                      sh 'terraform validate'
                     echo 'terraform validated'

                        //sh "az login --service-principal --username ${ARM_CLIENT_ID} --password '${ARM_CLIENT_SECRET}' --tenant '${ARM_TENANT_ID}'"
                    //echo 'Azure sp login successfull'
                   // sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                
}
              
            }
        }
        stage ('Initialize terraform') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: 'az-jenkins-sp',

                                                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',

                                                clientIdVariable: 'ARM_CLIENT_ID',

                                                clientSecretVariable: 'ARM_CLIENT_SECRET',

                                                tenantIdVariable: 'ARM_TENANT_ID')]) {
                    //sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                sh 'terraform init'
            }
        }
        }
         stage ('Plan terraform') {
            steps 
            { withCredentials([azureServicePrincipal(credentialsId: 'az-jenkins-sp',

                                                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',

                                                clientIdVariable: 'ARM_CLIENT_ID',

                                                clientSecretVariable: 'ARM_CLIENT_SECRET',

                                                tenantIdVariable: 'ARM_TENANT_ID')]) {
                //withCredentials([azureServicePrincipal('Azure')]) {
               //     sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                sh 'terraform plan'
            }
            }
         }
        stage ('Apply terraform') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: 'az-jenkins-sp',

                                                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',

                                                clientIdVariable: 'ARM_CLIENT_ID',

                                                clientSecretVariable: 'ARM_CLIENT_SECRET',

                                                tenantIdVariable: 'ARM_TENANT_ID')]) {
                    
                      sh 'terraform apply'
                     echo 'terraform apply'
                                                // Perform Azure login with provided ServicePrincipal credentials
                    sh "az login --service-principal --username ${ARM_CLIENT_ID} --password '${ARM_CLIENT_SECRET}' --tenant '${ARM_TENANT_ID}'"
                    echo 'Azure sp login successfull'
                    

                      
                   // sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET -t $TENANT_ID'
                
}
              
            }
        }
        }
    }
