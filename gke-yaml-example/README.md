## How to Deploy ramdisk to gke node

### Replace paras in ramdisk-ds.yaml
```shell
# edit the line 8 and line 12 label kv to apply this daemonset
spec:
  selector:
    matchLabels:
      LABEL_KEY: "VALUE"
  template:
    metadata:
      labels:
        LABEL_KEY: "VALUE"

# edit the line 19 serviceAccountName to access gcs
serviceAccountName: gcs-sa

# edit line 32 ramdisk size
for example size=2g 

# edit line 38 gcs file path
gs://bucket/object

```
### Deploy daemonset to your GKE Cluster
```shell
kubectl apply -f ramdisk-ds.yaml
```
### Delete daemonset from your GKE Cluster
```shell
kubectl apply -f ramdisk-ds.yaml
```