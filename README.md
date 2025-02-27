Jenkins Blue-Green Deployment on GKE
Personal Notes:
Create a GCE default service account key and configure it as a secret file in Jenkins.
Create another VM for SonarQube and run it as a Docker container.
Add the SonarQube token as a Jenkins secret text and configure the Jenkins endpoint as a webhook in SonarQube.
Set up Docker credentials in Jenkins with the name "docker-cred", using a username and password.
Install kubectl, the GCP authentication plugin, and Docker on the Jenkins server.

Installation References:
1. Install Google Cloud SDK https://cloud.google.com/sdk/docs/install#deb
2. Configure kubectl access for GKE clusters https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#apt_1
