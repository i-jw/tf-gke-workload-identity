[English Version](README.md)
## 如何部署
### 设置GCP认证
```shell
gcloud auth application-default login
或者
GOOGLE_CREDENTIALS=service-account-key-xxxx.json
```
### 部署，注意替换本地变量中的内容
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
terraform apply --auto-approve
```
### 销毁资源
```shell
terraform destroy --auto-approve
```