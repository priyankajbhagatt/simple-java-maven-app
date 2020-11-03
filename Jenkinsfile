pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
    parameters {
  credentials credentialType: 'com.microsoft.azure.util.AzureCredentials', defaultValue: 'Azure', description: '', name: 'Azure', required: true
}
    
    stages {
        
        stage('Parameter Check') {
            steps {
               echo "Hello ${params.credentials}"
            }
        }
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }
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
        stage ('Initialize Mven') {
            steps {
                sh 'mvn verify'
            }
        }
        stage ('Check terraform Version') {
            steps {
                sh 'terraform version'
            }
        }
        stage ('Initialize terraform') {
            steps {
                sh 'terraform init'
            }
        }
         stage ('Plan terraform') {
            steps {
                sh 'terraform plan'
            }
        }
    }
}
