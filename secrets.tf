## 🛠️ Provider Definitions (Ensure these are in your root providers.tf)
# NOTE: Assume your GKE/Google providers are defined elsewhere in this file.

# --- Secret Creation Resources ---
# These resources create the secret containers in GCP and upload the data.

resource "google_secret_manager_secret" "docker_username" {
  secret_id = "docker-harbor-username"
  project   = var.project_id
  # Use the automatic {} block to ensure replication is correctly configured
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "docker_username_version" {
  secret      = google_secret_manager_secret.docker_username.id
  secret_data = var.robot_username
}

resource "google_secret_manager_secret" "docker_password" {
  secret_id = "docker-harbor-password"
  project   = var.project_id
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "docker_password_version" {
  secret      = google_secret_manager_secret.docker_password.id
  secret_data = var.robot_password
}


# --- Data Sources (Must wait for creation) ---
# These resources read the secrets created above.

data "google_secret_manager_secret_version" "docker_username_read" {
  secret = google_secret_manager_secret.docker_username.secret_id
  
  # Ensure the Data Source waits for the Version resource to be created
  depends_on = [
    google_secret_manager_secret_version.docker_username_version
  ]
}

data "google_secret_manager_secret_version" "docker_password_read" {
  secret = google_secret_manager_secret.docker_password.secret_id
  
  # Ensure the Data Source waits for the Version resource to be created
  depends_on = [
    google_secret_manager_secret_version.docker_password_version
  ]
}
