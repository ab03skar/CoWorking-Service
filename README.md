# Deployment Process and Documentation

## Introduction

This README serves as a guide to help an experienced software developer understand the technologies, tools, and workflow in the build and deploy process. The provided setup uses Docker for containerization, Kubernetes with AWS EKS for orchestration, AWS services for building and storing container images, and GitHub for code management.

## Getting Started

### Dependencies

#### Local Environment

- **Python Environment**: Used to run Python 3.6+ applications and install Python dependencies via `pip`.
- **Docker CLI**: Helps in building and running Docker images locally.
- **kubectl**: A command-line tool to run commands against a Kubernetes cluster.
- **helm**: Utilized for applying Helm Charts to a Kubernetes cluster.

#### Remote Resources

- **AWS CodeBuild**: Enables us to build Docker images remotely.
- **AWS ECR**: Hosts Docker images.
- **Kubernetes Environment with AWS EKS**: Provides an environment to run applications in Kubernetes.
- **AWS CloudWatch**: Allows for monitoring activity and logs in EKS.
- **GitHub**: Serves as a platform to pull and clone code.

## Setup

### 1. Configure a Database

#### Set up a Postgres database using a Helm Chart

- Add Bitnami Repo:

  ```bash
  helm repo add <REPO_NAME> https://charts.bitnami.com/bitnami
  ```

- Install PostgreSQL Helm Chart:

  ```bash
  helm install <SERVICE_NAME> <REPO_NAME>/postgresql
  ```

  After installation, this will set up a Postgres deployment at `<SERVICE_NAME>-postgresql.default.svc.cluster.local` in your Kubernetes cluster.

  Default credentials:
  - Username: `postgres`
  - Password: Obtain it using the commands below:

    ```bash
    export POSTGRES_PASSWORD=$(kubectl get secret --namespace default <SERVICE_NAME>-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
    echo $POSTGRES_PASSWORD
    ```

#### Test Database Connection

- Via Port Forwarding:

  ```bash
  kubectl port-forward --namespace default svc/<SERVICE_NAME>-postgresql 5432:5432 &
  PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432
  ```

- Via a Pod:

  ```bash
  kubectl exec -it <POD_NAME> bash
  PGPASSWORD="<PASSWORD HERE>" psql postgres://postgres@<SERVICE_NAME>:5432/postgres -c <COMMAND_HERE>
  ```

#### Seed Database

  ```bash
  kubectl port-forward --namespace default svc/<SERVICE_NAME>-postgresql 5432:5432 &
  PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < <FILE_NAME.sql>
  ```

### 2. Running the Analytics Application Locally

- Navigate to the `analytics/` directory.
- Install the Python dependencies:

  ```bash
  pip install -r requirements.txt
  ```

- Run the application (ensure environment variables are set correctly):

  ```bash
  DB_USERNAME=username_here DB_PASSWORD=password_here python app.py
  ```

#### Verifying the Application

- Generate a daily usage report:

  ```bash
  curl <BASE_URL>/api/reports/daily_usage
  ```

- Generate a user visits report:

  ```bash
  curl <BASE_URL>/api/reports/user_visits
  ```

## Project Instructions

1. Set up a Postgres database using a Helm Chart.
2. Create a Dockerfile for the Python application. Ensure you use a Python-based base image.
3. Design a simple build pipeline with AWS CodeBuild to build and push a Docker image into AWS ECR.
4. Formulate a service and deployment using Kubernetes configuration files to deploy the application.
5. Examine AWS CloudWatch for application logs.

## Deliverables

By the end of this process:

1. You will have a running Postgres database deployed via Helm on your Kubernetes cluster.
2. A containerized version of the analytics application will be available.
3. The analytics application will be deployed and running in your Kubernetes cluster, orchestrated by AWS EKS.
4. AWS CodeBuild will have a pipeline ready for future builds and deployments.
5. You will be able to monitor application logs via AWS CloudWatch.

---

