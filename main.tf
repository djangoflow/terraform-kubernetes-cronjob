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
              dynamic "volume_mount" {
                for_each = flatten([for pvc in var.volumes : [
                for vol_mount in pvc.mounts : {
                  name       = pvc.name
                  mount_path = vol_mount.mount_path
                  sub_path   = lookup(vol_mount, "sub_path", "")
                  read_only  = lookup(vol_mount, "read_only", "")
                }]
                ])
                content {
                  name       = volume_mount.value["name"]
                  mount_path = volume_mount.value["mount_path"]
                  sub_path   = volume_mount.value["sub_path"]
                }
              }
            }
            dynamic "volume" {
              for_each = var.volumes
              content {
                name = volume.value["name"]
                dynamic "empty_dir" {
                  for_each = volume.value["type"] == "empty_dir" ? [1] : []
                  content {
                    medium     = lookup(volume.value, "dir_medium", "")
                    size_limit = lookup(volume.value, "size_limit", 0)
                  }
                }
                dynamic "persistent_volume_claim" {
                  for_each = volume.value["type"] == "persistent_volume_claim" ? [1] : []
                  content {
                    claim_name = volume.value["object_name"]
                    read_only  = lookup(volume.value, "readonly", false)
                  }
                }
                dynamic "config_map" {
                  for_each = volume.value["type"] == "config_map" ? [1] : []
                  content {
                    name         = volume.value["object_name"]
                    default_mode = lookup(volume.value, "default_mode", "0644")
                    optional     = lookup(volume.value, "optional", "false")
                  }
                }
                dynamic "secret" {
                  for_each = volume.value["type"] == "secret" ? [1] : []
                  content {
                    secret_name  = volume.value["object_name"]
                    default_mode = lookup(volume.value, "default_mode", "0644")
                    optional     = lookup(volume.value, "optional", "false")
                  }
                }
              }
            }
          }
          metadata {}
        }
      }
      metadata {}
    }
  }
}
