#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
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
        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name my-eks-cluster"
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl apply -f nginx-service.yaml"
                    }
                }
            }
        }
    }
}
