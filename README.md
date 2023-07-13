# Elasticsearch on Google Kubernetes Engine (GKE) + Terraform

This module deploys Elasticsearch on GKE using Helm and Terraform.

## Prerequisites

- Google Cloud account with necessary permissions to create resources
- Terraform installed (version 0.13+)
- Helm installed (version 3+)
- kubectl installed (version 1.15+)
- A service account key file with necessary IAM roles. 

## Variables

Below are the variables that need to be set before running the module.

- `service_account_key_path`: The path to the service account key file
- `project_id`: The ID of your GCP project
- `region`: The region where you want to create the cluster
- `zone`: The zone where you want to create the cluster
- `cluster_name`: The name for the GKE cluster
- `es_version`: The version of Elasticsearch you want to use
- `instance_count`: The number of instances in the GKE cluster
- `storage_size`: The size of the persistent volumes used by Elasticsearch

## Execution

1. Clone this repository and navigate to the directory containing the Terraform module.

```
git clone <repository-url>
cd <module-directory>
```

2. Initilize terraform
```
terraform init
```

3. Create a terraform.tfvars file with values for the variables. Here is an example:
```
service_account_key_path = "/path/to/keyfile.json"
project_id               = "my-gcp-project"
region                   = "us-central1"
zone                     = "us-central1-a"
cluster_name             = "my-es-cluster"
es_version               = "7.10.2"
instance_count           = 3
storage_size             = "10Gi"
```

4. Plan the Terraform apply to see the changes that will be made.
```
terraform plan
```

5. Apply the Terraform configuration to create the resources.
```
terraform apply
```

## Outputs

After terraform apply completes, the script will output the endpoint of the GKE cluster and the cluster's public CA certificate. You can use these outputs to connect to your Elasticsearch cluster.

For example, you could run:
```
gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}
kubectl port-forward svc/elasticsearch-master 9200:9200
```

Then you could connect to localhost:9200 with a tool like curl or Htttpie to interact with your Elasticsearch cluster.

```
"http :9200/_cat/indices?v"
```

## Happy deployments 
By Andy Bravo