//@Library('pipeline-library') _

 

import java.text.SimpleDateFormat

 

properties([

  parameters([

    booleanParam(name: 'autoApprove', defaultValue: false, description: 'Auto-approve all TF plans (including non-empty)')

  ])

])

 

def TF_STACK = [

terraform

]

 

pipeline {

  agent any

  options { timestamps() }

  environment {

    TF_DOCKER_IMAGE      = "test-tooling:${env.test_TOOLING_VERSION}"

    DOCKER_REGISTRY      = "https://${env.DEFAULT_ACR}"

    REGISTRY_CREDENTIALS = "acr-${env.test_DEPLOYMENT_ENV}"

    AZ_SP_ID             = "az-jenkins-sp"

    AZ_DEVOPS_TOKEN      = "az-devops-token"
	
	test_DEPLOYMENT_ENV = "test"
	

  }

  stages{

    stage('checkout') {

      steps {

        checkout scm

      }

    }

 

    stage('init plan apply') {

      steps {

        script{

          //withEnv([

            //"GIT_ASKPASS=${WORKSPACE}/terraform/environments/askpass.sh",

          //]) {

               // TF requires credentials for Azure RM provider.

                withCredentials([azureServicePrincipal(credentialsId: "${AZ_SP_ID}",

                                                subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',

                                                clientIdVariable: 'ARM_CLIENT_ID',

                                                clientSecretVariable: 'ARM_CLIENT_SECRET',

                                                tenantIdVariable: 'ARM_TENANT_ID')]) {

                 // withCredentials([usernamePassword(credentialsId: 'az-devops-token',
//
  //                                                passwordVariable: 'GIT_PASSWORD',
//
  //                                                usernameVariable: 'GIT_USERNAME')]) {

                    docker.withRegistry("${DOCKER_REGISTRY}", "${REGISTRY_CREDENTIALS}") {

 

                      // Pull the Docker image from the registry

                      docker.image(TF_DOCKER_IMAGE).pull()

                      docker.image(TF_DOCKER_IMAGE).inside() {

 

                        // Perform Azure login with provided ServicePrincipal credentials

                        sh "az login --service-principal --username ${ARM_CLIENT_ID} --password '${ARM_CLIENT_SECRET}' --tenant '${ARM_TENANT_ID}'"

 

                        for (stack in TF_STACK) {

                          def TF_EXEC_PATH = "terraform/environments/"+stack

                          def TF_BACKEND_CONF = "-backend-config='storage_account_name=dntfstatetest${env.test_DEPLOYMENT_ENV}' -backend-config='key=test/${env.test_DEPLOYMENT_ENV}/${stack.split('/')[0]}-${env.test_DEPLOYMENT_REGION}/${stack.split('/')[1]}/terraform.tfstate'"

                          def TF_COMMAND = "terraform init ${TF_BACKEND_CONF}; terraform plan -var-file terraform.${env.test_DEPLOYMENT_ENV}.${env.test_DEPLOYMENT_REGION}.tfvars -detailed-exitcode;"

                          def TF_COMMAND2 = "terraform apply -auto-approve -var-file terraform.${env.test_DEPLOYMENT_ENV}.${env.test_DEPLOYMENT_REGION}.tfvars"

                          def exists = fileExists "${TF_EXEC_PATH}/terraform.${env.test_DEPLOYMENT_ENV}.${env.test_DEPLOYMENT_REGION}.tfvars"

                          if (exists) {

                            def ret = sh(script: "cd ${TF_EXEC_PATH} && ${TF_COMMAND}", returnStatus: true)

                            println "[${stack}] TF plan exit code: ${ret}. \n INFO: 0 = Succeeded with empty diff (no changes);  1 = Error; 2 = Succeeded with non-empty diff (changes present)"

                            if ( "${ret}" == "0" ) {

                              sh "cd ${TF_EXEC_PATH} && ${TF_COMMAND2}"

                            }

                            else if ( "${ret}" == "1" ) {

                              error("Build failed because TF plan for ${stack} failed..")

                            }

                            else if ( "${ret}" == "2" ) {

                              if ( !params.autoApprove ) {

                                timeout(time: 1, unit: 'HOURS') {

                                  input 'Approve the plan to proceed and apply'

                                }

                              }

                              sh "cd ${TF_EXEC_PATH} && ${TF_COMMAND2}"

                            }

                          }

                          else

                            echo " terraform.${env.test_DEPLOYMENT_ENV}.${env.test_DEPLOYMENT_REGION}.tfvars doesn't exists in stack: ${stack} "

                        }

                      }

                    }

                  }

                }

          }

        }

      }

    }
}	
