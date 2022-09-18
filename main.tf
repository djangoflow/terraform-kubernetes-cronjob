resource "kubernetes_cron_job_v1" "gcs_backup" {
  metadata {
    namespace = var.namespace
    name      = var.name
  }
  spec {
    schedule = var.schedule
    job_template {
      spec {
        template {
          spec {
            service_account_name = var.service_account_name
            restart_policy       = "OnFailure"
            container {
              image   = "google/cloud-sdk:alpine"
              name    = "cronjob"
              command = var.command
            }
          }
          metadata {}
        }
      }
      metadata {}
    }
  }
}
