# Elasticsearch Deployment on GCP using Terraform and Elastic Cloud Provider

This Terraform module deploys Elasticsearch and Kibana on Google Cloud Platform (GCP) using the Elastic Cloud Provider.

## Prerequisites

- Google Cloud account with necessary permissions to create resources.
- Terraform installed (version 1.0.0 or later)
- Elastic Cloud API key

## Variables

Below are the variables that need to be set before running the module.

- `api_key`: The Elastic Cloud API Key.
- `region`: The GCP region where you want to deploy Elasticsearch (default is 'gcp-us-central1').
- `version`: The version of Elasticsearch to deploy (default is '7.14.0').
- `deployment_name`: The name of the Elasticsearch deployment (default is 'my-es-deployment').

## Execution

1. Clone this repository and navigate to the directory containing the Terraform module.

```bash
git clone <repository-url>
cd <module-directory>
```

3. Create a terraform.tfvars file with values for the variables. Here is an example:
```
api_key          = "your-elastic-cloud-api-key"
region           = "gcp-us-central1"
version          = "7.14.0"
deployment_name  = "my-es-deployment"
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

### Happy deployments! 
By Andy Bravo @BitsHoroscope 