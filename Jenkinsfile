#!groovy
//  groovy Jenkinsfile
pipeline
{
    agent any;
    stages 
    {
        stage("Hostname")
        {
            steps{
                sh """
                #!/bin/bash
                hostname
                """
            }
        }
        stage("Change IP in axios.js")
        {
            steps{
                sh "find FrontEnd/my-app/ -type f -exec sed  -i 's#http://localhost:5034#https://20.93.19.255/api#g' {} +"
            }
        }
        stage ("Remove all containers and images"){
            steps{
                sh'''#!/bin/sh
                /var/lib/jenkins/workspace/Build Site/delete.sh
                '''
            }
        }
    }
}
