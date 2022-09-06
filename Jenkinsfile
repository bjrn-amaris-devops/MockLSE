pipeline {
    agent any

    //options {
    //    skipDefaultCheckout true
    //}
    stages {

        // CI
//         stage('Initialize Workspace and Checkout Source') {
//             steps {
//                 echo "Running pipeline on $BRANCH_NAME"
//                 sh 'printenv | sort'
//                 cleanWs()
//                 checkout scm
//             }
//         }

        // CI
        stage('Test Code Quality') {
            when { expression { return env.BRANCH_NAME != 'dev' } }
            steps {
                echo "Testing code quality on branch $BRANCH_NAME"
            }
        }

        // CI: Sonarqube Part 1: Scan project to create report.
        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SONARQUBE_SCANNER'
                PROJECT_NAME = 'LSE_PRICE_PROMO_PRICING_BUSINESS_RULES_WEBAPP'
            }
            steps {
                sh '''echo sonarqube'''
            }
        }

        // CI: Sonarqube Part 2: Validate if project passes quality gate.
        stage('Sonarqube Quality Gate') {
            steps {
                script {
                    timeout(time: 3, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        // Docker image building and registration to ECR
        stage('Building Image and Registration') {
            steps {
                // build Docker image and push to AWS ECR
                sh '''make build-push''' //RAJOUTER IMAGE en tant env
            }
        }
        stage ('Deploy') {
            steps {
                // Update service (create)
                sh '''make update-service''' // MSRP EU vs US
            }
        }

    }
}
