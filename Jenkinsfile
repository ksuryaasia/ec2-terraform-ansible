pipeline{
    agent any
    stages{
        
        stage('Git CheckOut'){
         steps{    
          git 'https://github.com/ehteshamkhaja/ec2-instance-creation-using-terraform.git'
        }
        }
       stage('Ansible Playbook Execution'){
         steps{    
   #       ansiblePlaybook  credentialsId: 'devops-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/ansible/hosts', playbook: 'playbooks/apache.yaml'
        }
        } 
    }
  post {
      success {
            echo 'Sucessfully executed the Ansible Playbook'
        }
       failure {
            echo 'Job Failed, Please Check !!'
        }
     }
}
