pipeline {
    agent any
    tools {
        maven 'Maven3'
        jdk 'jdk1.8'
        terraform 'terraform'
    }
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')

        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')

        booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')

        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')

        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    }
    
    stages {
        
        stage('Parameter Check') {
            steps {
                echo "Hello ${params.PERSON}"

                echo "Biography: ${params.BIOGRAPHY}"

                echo "Toggle: ${params.TOGGLE}"

                echo "Choice: ${params.CHOICE}"

                echo "Password: ${params.PASSWORD}"
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
