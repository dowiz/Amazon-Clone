#!groovy
//  groovy Jenkinsfile
pipeline  {
    agent any;
    stages {
        
         stage("Backup files")
         {
             steps{
                sh """
                #!/bin/bash
                sudo /home/azureuser/backup.sh
                """
             }
         }
        
    }
}
