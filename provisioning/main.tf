resource "random_id" "random_path" {
  byte_length = 16
}

resource "google_secret_manager_secret" "telegram-token" {
  secret_id = "telegram_token"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "telegram_token_value" {
  secret = google_secret_manager_secret.telegram-token.id

  secret_data = var.telegram-token
}

resource "google_secret_manager_secret" "veem-token" {
  secret_id = "veem_token"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "veem_token_value" {
  secret = google_secret_manager_secret.veem-token.id

  secret_data = var.veem-token
}

resource "google_storage_bucket" "serverless_bucket" {
  name     = "serverless_${var.project-id}_bucket"
  location = "US"
}

resource "google_storage_bucket_object" "serverless_object" {
  name   = "test"
  bucket = google_storage_bucket.serverless_bucket.name
  source = "../.serverless/veemexchangerate.zip"
}

resource "google_cloudfunctions_function" "handle_events_function" {
  name        = random_id.random_path.id
  description = "Handles Telegram events"
  runtime     = "nodejs16"

  available_memory_mb          = 128
  timeout                      = 60
  source_archive_bucket        = google_storage_bucket.serverless_bucket.name
  source_archive_object        = google_storage_bucket_object.serverless_object.name
  trigger_http                 = true
  entry_point = "handleEvents"
  https_trigger_security_level = "SECURE_ALWAYS"
  ingress_settings             = "ALLOW_ALL"

  secret_environment_variables {
    key = "telegramToken"
    secret = google_secret_manager_secret.telegram-token.secret_id
    version = google_secret_manager_secret_version.telegram_token_value.version
  }

  secret_environment_variables {
    key = "veemToken"
    secret = google_secret_manager_secret.veem-token.secret_id
    version = google_secret_manager_secret_version.veem_token_value.version
  }
}

resource "google_cloudfunctions_function_iam_member" "function_invoker" {
  project        = google_cloudfunctions_function.handle_events_function.project
  region         = google_cloudfunctions_function.handle_events_function.region
  cloud_function = google_cloudfunctions_function.handle_events_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
