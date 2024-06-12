terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.33.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
  }
}
locals {
  region           = "GCP_REGION"
  project_id       = "PROJECT_ID"
  cluster_name     = "CLUSTER_NAME"
  cluster_location = "CLUSTER_LOCATION"
  namespace        = "K8S_NAMESPACE"
  ksa              = "KUBERNETES_SA_NAME"
  roles            = ["roles/spanner.viewer", "roles/storage.objectViewer"]
}
provider "google" {
  project = local.project_id
}
data "google_project" "project" {
}
data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = local.cluster_name
  location = local.cluster_location
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
  )
}
resource "google_service_account" "gsa" {
  project      = local.project_id
  account_id   = "workload-gsa"
  display_name = "Service Account - used for gke workload"
}
resource "kubernetes_service_account" "ksa" {
  metadata {
    name      = local.ksa
    namespace = local.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.gsa.email
    }
  }
}

resource "google_project_iam_binding" "gsa_roles" {
  for_each   = toset(local.roles)
  project    = local.project_id
  role       = each.key
  members    = ["serviceAccount:${google_service_account.gsa.email}"]
  depends_on = [kubernetes_service_account.ksa, google_service_account.gsa]
}

resource "google_project_iam_binding" "gsa_ksa_binding" {
  project    = local.project_id
  role       = "roles/iam.workloadIdentityUser"
  members    = ["serviceAccount:${local.project_id}.svc.id.goog[${local.namespace}/${local.ksa}]"]
  depends_on = [google_project_iam_binding.gsa_roles]
}

