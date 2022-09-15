pipeline {
    agent any

    //options {
    //    skipDefaultCheckout true
    //}
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        //Useless
        //GITHUB_ACCESS_KEY_ID  = credentials('jenkins-github-secret-key-id')
        //GITHUB_SECRET_ACCESS_KEY = credentials('jenkins-github-secret-access-key')
        AWS_DEFAULT_REGION="eu-west-3a"
        AWS_ECR_URI="987924616652.dkr.ecr.eu-west-2.amazonaws.com/nginx-web-server"
    }
    tools { go '1.19' }
    stages {

            stage('Init'){
                steps{
                    sh '''ls'''
                }

            }
            // Docker image building and registration to ECR
            stage('Building Docker Image') {
                steps {
                    // build Docker image and push to AWS ECR
                    sh '''make build-image -C mlops/scripts''' //RAJOUTER IMAGE en tant env
                }
            }
            stage('Pushing image'){
                agent {
                    dockerfile {
                        filename 'Dockerfile_CICD'
                        dir 'mlops/docker'
                    }

                }
                steps {
                    sh '''make push-image-ecr -C mlops/scripts'''
                }

            }
            stage ('Deploy') {
                steps {
                    // Update service (create)
                    sh '''make update-service -C mlops/scripts''' // MSRP EU vs US
                }
            }

    }
}
