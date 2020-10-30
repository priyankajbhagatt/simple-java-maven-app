pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
    }
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }
        stage('Compile') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test deploy'
            }
        }
        stage('Install') {
            steps {
                sh 'mvn install'
            }
        }
    }
}
