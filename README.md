# terraform-kubernetes-cronjob
A kubernetes cronjob, suitable for backing up things to GCS (and not only)

The default image is `google/cloud-sdk:alpine`

You need to create and specify service account name that is able to access your GCS bucket.

You can then specify the command like:

```
tar czf - /path-to-backup | gsutil cp - gs://bucket/path/backups/`date '+%Y-%m-%d-%H.%M'`-backup.zip
```
