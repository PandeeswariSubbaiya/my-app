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
	       def qg = waitForQualityGate()
	        if (qg.status != 'OK') {
	           // error "Pipeline aborted due to quality gate failure: ${qg.status}"
	             catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE'){
	                 sh "exit 1"
	             }
	        }
	    }
	}
	  stage('Build Docker Image'){
        //sh 'docker build -t pandeeswari1814/webapplication:1.0.0'
        sh 'docker build . -t pandeeswari1814/webapplication:$BUILD_NUMBER'
   }
    stage('Docker Image Push'){
        withCredentials([string(credentialsId: 'dockerPass', variable: 'dockerPassword')]) {
        sh "docker login -u pandeeswari1814 -p ${dockerPassword}"
    }
        sh 'docker push pandeeswari1814/webapplication:$BUILD_NUMBER'
   }
   stage('K8S Deploy'){
       withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
       sh 'chmod +x changeTag.sh'
       sh './changeTag.sh $BUILD_NUMBER'
    // some block
        //sh " kubectl delete deployment tomcat "
        sh ('kubectl apply -f rollingupdate.yml')
        }
    }
}
