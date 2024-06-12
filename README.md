[中文版](README_zh.md)
## How to Deploy
### GCP Credentials setup
```shell
gcloud auth application-default login
或者
GOOGLE_CREDENTIALS=service-account-key-xxxx.json
```
### Deploy the resource, replace the local variables with your's (project_id and region)
```shell

locals {
  region           = "GCP_REGION"
  project_id       = "PROJECT_ID"
  cluster_name     = "CLUSTER_NAME"
  cluster_location = "CLUSTER_LOCATION"
  namespace        = "K8S_NAMESPACE"
  ksa              = "KUBERNETES_SA_NAME"
  roles            = ["roles/spanner.viewer", "roles/storage.objectViewer"]
}

terraform init
terraform apply  --auto-approve
```
### Delete all resource
```shell
terraform destroy --auto-approve
```