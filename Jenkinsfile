node{
    stage('SCM Checkout'){
     git 'https://github.com/PandeeswariSubbaiya/my-app.git'
   }
    stage('maven-buildstage'){
        def mvnHome =  tool name: 'maven3', type: 'maven'   
            sh "${mvnHome}/bin/mvn clean package"
	        sh 'mv target/myweb*.war target/newapp.war'
   }
   stage('SonarQube Analysis'){
        def mvnHome =  tool name: 'maven3', type: 'maven'
	        withSonarQubeEnv('sonarqube') { 
	          sh "${mvnHome}/bin/mvn sonar:sonar"
	        }
	    }
	stage("Quality Gate"){
	    timeout(time: 1, unit: 'HOURS') {
	        //def qg = waitForQualityGate('sonarqube')
	        //if (qg.status != 'OK') {
	            //error "Pipeline aborted due to quality gate failure: ${qg.status}"
	    }
	}
	stage('Build Docker Image'){
        sh 'docker build -t pandeeswari1814/webapp .'
   }
    stage('Docker Image Push'){
        withCredentials([string(credentialsId: 'dockerPass', variable: 'dockerPassword')]) {
        sh "docker login -u pandeeswari1814 -p ${dockerPassword}"
    }
        sh 'docker push pandeeswari1814/webapp'
   }
    stage('K8S Deploy'){
        withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
    // some block
        sh ('kubectl apply -f  eks-deploy-k8s.yaml')
        }
    }
}
