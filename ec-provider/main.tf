provider "gcp" {
    credentials = file(var.service_account_key_path)
    project     = var.project_id
    region      = var.region
}

variable "api_key" {
  description = "The Elastic Cloud API Key"
}

variable "region" {
  description = "The region where you want to deploy Elasticsearch"
  default     = "gcp-us-central1"
}

variable "version" {
  description = "The version of Elasticsearch to deploy"
  default     = "7.14.0"
}

variable "deployment_name" {
  description = "The name of the Elasticsearch deployment"
  default     = "my-es-deployment"
}

resource "ec_deployment" "example_minimal" {
  # Optional name.
  name = var.deployment_name

  # Mandatory fields
  region                 = var.region
  version                = var.version
  deployment_template_id = "gcp-io-optimized"

  elasticsearch {
    topology {
      instance_configuration_id = "gcp.data.highio.1"
      memory_per_node = "4g"
    }
  }

  kibana {
    count = 1
    topology {
      memory_per_node = "1g"
    }
  }
}

output "elasticsearch_https_endpoint" {
  value       = ec_deployment.example_minimal.elasticsearch[0].https_endpoint
  description = "The HTTPS endpoint for the Elasticsearch cluster"
}

output "kibana_https_endpoint" {
  value       = ec_deployment.example_minimal.kibana[0].https_endpoint
  description = "The HTTPS endpoint for Kibana"
}