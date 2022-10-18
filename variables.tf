variable "name" {
  description = "The name of the cronjob"
  type = string
}

variable "namespace" {
  description = "The namespace to deploy the job in"
  type = string
}

variable "schedule" {
  description = "Cron schedule to run this command"
  type = string
}

variable "service_account_name" {
  description = "The service account to run this job as"
  type = string
  default = null
}

variable "image" {
  description = "The docker image to use for this cronjob"
  type = string
  default = "google/cloud-sdk:alpine"
}

variable "command" {
  description = "The command to run"
  type = list(string)
  default = ["/bin/sh", "-c", "hello world"]
}

variable "volumes" {
  type        = any
  description = "Volume configuration"
  default     = []
}
