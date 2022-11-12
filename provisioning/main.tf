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

resource "google_cloudfunctions_function" "handleEvents" {
  secret_environment_variables {
    key = "telegram-token"
    secret = google_secret_manager_secret.telegram-token.secret_id
    version = google_secret_manager_secret_version.veem_token_value.version
  }
}
