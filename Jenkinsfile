def COLOR_MAP =[
    "SUCCESS": "good",
    "FAILURE": "danger"
]

pipeline{
    agent any
    environment{
        awsECRCreds = 'ecr:us-east-1:AWSCLIJenkinsCredential',
        AwsEcrRegistry = '171040096730.dkr.ecr.us-east-1.amazonaws.com/devops',
        cluster = '',
        service = '',
        imageRegistryendpoint = '171040096730.dkr.ecr.us-east-1.amazonaws.com',
        region = 'us-east-1',

    }
    tools{
        maven "maven"
        jdk "Oraclejdk-8"
    }
    stages{
        stage("Fetch code from Git") {
            steps{
                git branch: "main", url: "https://github.com/profebass99/maven-jenkins-project.git" 
            }
        }
        stage("Build Maven Goals") {
            steps{
                sh "mvn install -DskipTests"
            }
            post{
                success {
                    echo "Archiving artifacts"
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }
        stage("Unit Test") {
            steps{
                sh "mvn test"
            }

        }
        stage("checkstyle code") {
            steps{
                sh "mvn checkstyle:checkstyle"
            }
        }
        stage("SonarQube Code Analysis") {
            environment{
                ScannerHome = tool 'sonar4.7'
            }
            steps{
                 withSonarQubeEnv('sonarqube') { 
                    sh """${ScannerHome}/bin/sonar-scanner -Dsonar.projectKey=sundaydevops \
                          -Dsonar.projectName=sundaydevops \
                          -Dsonar.projectVersion=${BUILD_ID} \
                          -Dsonar.sources=src/ \
                          -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                          -Dsonar.junit.reportsPath=target/surefire-reports/ \
                          -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                          -Dsonar.java.checkstyle.reportsPath=target/checkstyle-result.xml             
                       """
             }
            }  
        }
        stage("Build Image"){
            steps{
                echo "Building image from source"
                dockerImage = docker.build(awsECRCreds, + ":$BUILD_NUMBER" + .)
            }
        }
        stage("QualityGate Checks"){
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Upload Artifact to Nexus"){
            steps{
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    nexusUrl: "52.90.138.184:8081",
                    protocol: 'http',
                    version: "${env.BUILD_ID}-${BUILD_TIMESTAMP}",
                    groupId: 'com.devopsacad',
                    repository: 'sundayartifactrepo',
                    credentialsId: 'Jenkins4Nexus',
                    artifacts: [
                        [
                            artifactId: "devopsacad",
                            file: 'target/devopsacad-v2.war',
                            type: "war",
                            classifier: ""
                        ]
                    ]
                )
            }
        }
        stage("Push docker image to ECR"){
            steps{
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push("latest")
            }
        }
    }
    post{
        always{
            echo "JenkinsPipelineSlackNotification"
            slackSend channel: 'devops',
                color: COLOR_MAP [currentBuild.currentResult],
                message: "*${currentBuild.currentResult}: *Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n more info at: ${env.JOB_DISPLAY_URL}"
        }
    }
}
