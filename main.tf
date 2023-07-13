provider "google" {
    credentials = file(var.service_account_key_path)
    project     = var.project_id
    region      = var.region
  }
  
  variable "service_account_key_path" {
    description = "The path to the service account key file"
  }
  
  variable "project_id" {
    description = "The ID of your GCP project"
  }
  
  variable "region" {
    description = "The region where you want to create the cluster"
  }
  
  variable "zone" {
    description = "The zone where you want to create the cluster"
  }
  
  variable "cluster_name" {
    description = "The name for the GKE cluster"
  }
  
  variable "es_version" {
    description = "The version of Elasticsearch you want to use"
  }
  
  variable "instance_count" {
    description = "The number of instances in the GKE cluster"
    default     = 3
  }
  
  variable "storage_size" {
    description = "The size of the persistent volumes used by Elasticsearch"
    default     = "10Gi"
  }
  
  data "google_client_config" "default" {}
  
  resource "google_container_cluster" "primary" {
    name               = var.cluster_name
    location           = var.zone
    initial_node_count = var.instance_count
    project            = var.project_id
  
    master_auth {
      username = ""
      password = ""
  
      client_certificate_config {
        issue_client_certificate = false
      }
    }
  
    node_config {
      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
  
      labels = {
        environment = "production"
      }
  
      tags = ["elasticsearch"]
    }
  }
  
  provider "helm" {
    kubernetes {
      config_path = "~/.kube/config"
    }
  }
  
  data "helm_repository" "elastic" {
    name = "elastic"
    url  = "https://helm.elastic.co"
  }
  
  resource "helm_release" "elasticsearch" {
    name       = "elasticsearch"
    repository = data.helm_repository.elastic.metadata.0.name
    chart      = "elasticsearch"
    version    = var.es_version
  
    set {
      name  = "imageTag"
      value = var.es_version
    }
  
    set {
      name  = "volumeClaimTemplate.storageClassName"
      value = "standard"
    }
  
    set {
      name  = "volumeClaimTemplate.resources.requests.storage"
      value = var.storage_size
    }
  }
  
  output "cluster_endpoint" {
    value       = google_container_cluster.primary.endpoint
    description = "The IP address of the cluster master"
  }
  
  output "cluster_ca_certificate" {
    value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    description = "The public certificate that is the root of trust for the cluster"
  }
  