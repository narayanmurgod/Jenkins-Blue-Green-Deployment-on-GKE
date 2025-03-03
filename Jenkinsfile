pipeline {
    agent any
    
    parameters {
        choice(name: 'DEPLOY_ENV', choices: ['blue', 'green'], description: 'Choose which environment to deploy: Blue or Green')
        choice(name: 'DOCKER_TAG', choices: ['blue', 'green'], description: 'Choose the Docker image tag for the deployment')
        booleanParam(name: 'SWITCH_TRAFFIC', defaultValue: false, description: 'Switch traffic between Blue and Green')
    }
    
    environment {
        IMAGE_NAME = "thenameisnani/python-app"
        TAG = "${params.DOCKER_TAG}"
        location = "us-central1"
        CLUSTER_NAME = "main-cluster"
        PROJECT_ID = "probable-pager-452507-d4"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('default-sa-key')
    }

    stages {
        stage('Git Checkout') {
            steps { 
                git branch: 'main', url: 'https://github.com/narayanmurgod/Jenkins-Blue-Green-Deployment-on-GKE.git' 
            }
        }
        
        
        stage('Docker Build') {
            steps { 
                sh "docker build -t ${IMAGE_NAME}:${TAG} ." 
            }
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
                    def deploymentFile = params.DEPLOY_ENV == 'blue' ? 
                    'app-deployment-blue.yml' : 
                    'app-deployment-green.yml'

                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --location ${location} --project ${PROJECT_ID}"
                    sh "kubectl apply -f ${deploymentFile}" 
                    sh "kubectl apply -f colour-service.yml"// Only apply the deployment, not the service
                }
            }
        }

        stage('Switch Traffic') {
            when { expression { return params.SWITCH_TRAFFIC } }
            steps {
                script {

                    sh """
                    kubectl patch service colour-service -p '{"spec":{"selector":{"version":"${params.DEPLOY_ENV}"}}}'
                    """

                }
            }
        }
        
    
    }
}