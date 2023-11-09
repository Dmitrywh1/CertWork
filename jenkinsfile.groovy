pipeline {
  agent any

  stages {
    stage('Terraform apply') {
      steps {
        sh '''
          cd /home/dmitry/CertWork/ && terraform init && terraform apply -auto-approve
        '''
      }
    }
    stage('Run bash script') {
      steps {
        sh '''
          cd /home/dmitry/CertWork/ && sudo bash ansible.sh && bash pythonpackage.sh
        '''
      }
    }
    stage('Run ansible-playbook') {
      steps {
        sh '''
          cd /home/dmitry/CertWork/ && ansible-playbook ansible-playbook.yml
        '''
      }
    }
  }
}