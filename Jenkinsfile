#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage("Verify Environment") {
            steps {
                script {
                    echo "AWS_ACCESS_KEY_ID is: ${AWS_ACCESS_KEY_ID}"
                    echo "AWS_SECRET_ACCESS_KEY is: ${AWS_SECRET_ACCESS_KEY}"
                    }
                }
        }
        stage("Check AWS CLI Credentials") {
            steps {
                script {
                    sh "aws sts get-caller-identity"
                    }
                }
        }
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage('Update Kubeconfig') {
            steps {
                script {
                    sh 'aws eks update-kubeconfig --name my-eks-cluster'
                    sh 'sed -i "s/apiVersion: client.authentication.k8s.io\\/v1alpha1/apiVersion: client.authentication.k8s.io\\/v1/" /var/lib/jenkins/.kube/config'
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                dir('/var/lib/jenkins/workspace/jenkins-k8s/kubernetes') {
                    script {
                        sh "cat /var/lib/jenkins/.kube/config"
                        sh 'kubectl apply -f nginx-deployment.yaml'
                        sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }
    }
}
