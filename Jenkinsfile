pipeline {
    agent any
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Environment to deploy')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Docker image tag')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic')
    }
    
    environment {
        IMAGE_NAME = "thenameisnani/bankapp"
        TAG = "${params.DOCKER_TAG}"
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
        stage('Git Checkout') {
            steps { git branch: 'main', url: 'https://github.com/narayanmurgod/Jenkins-Blue-Green-Deployment-on-GKE.git' }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=nodejsmysql"
                }
            }
        }
        
        stage('Docker Build') {
            steps { sh "docker build -t ${IMAGE_NAME}:${TAG} ." }
        }
        
        stage('Trivy Scan') {
            steps { sh "trivy image --format table ${IMAGE_NAME}:${TAG}" }
        }
        
        stage('Docker Push Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh "docker push ${IMAGE_NAME}:${TAG}"
                    }
                }
            }
        }
        
        stage('Deploy to GKE') {
    steps {
        script {
            // Determine the deployment file based on the environment
            def deploymentFile = params.DEPLOY_ENV == 'blue' ? 
                'app-deployment-blue.yml' : 
                'app-deployment-green.yml'

            // Authenticate with GKE and apply Kubernetes manifests
            sh "gcloud container clusters get-credentials main-cluster --region us-central1 --project cts01-shreyashree"
            sh "kubectl apply -f ${deploymentFile}"
            sh "kubectl apply -f mysql-ds.yml"
            sh "kubectl apply -f bankapp-service.yml"
        }
    }

        }
        
        stage('Switch Traffic') {
            when { expression { return params.SWITCH_TRAFFIC } }
            steps {
                script {
                        sh """
                            kubectl patch service bankapp-service -p '{"spec":{"selector":{"version":"${params.DEPLOY_ENV}"}}}'
                        """          
                }
            }
        }
        
        stage('Verify') {
            steps {
                    sh "kubectl get pods -l version=${params.DEPLOY_ENV}"
                    sh "kubectl get svc bankapp-service"
            }
        }
    }
}