pipeline {
    agent any
    tools { 
        maven 'Maven3.1' 
        jdk 'jdk1.8.1' 
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

        stage ('Build') {
            steps {
                echo 'This is a minimal pipeline.'
            }
        }
        stage ('End') {
            steps {
                echo 'This is a end of pipeline.'
            }
        }
    }
}
