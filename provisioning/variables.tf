variable "project-id" {
  default = "veemcurrencyquote"
}

variable "project-region" {
  default = "us-central1"
}

variable "project-zone" {
  default = "us-central1-a"
}

variable "telegram-token" {
  sensitive = true
}

variable "veem-token" {
  sensitive = true
}