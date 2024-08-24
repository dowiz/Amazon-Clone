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
                sh "find FrontEnd/my-app/ -type f -exec sed  -i 's#http://localhost:5034#https://20.93.5.176/api#g' {} +"
            }
        }
    }
}
