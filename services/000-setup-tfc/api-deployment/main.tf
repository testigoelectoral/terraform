
resource "tfe_workspace" "api-deployment" {
  name              = "${var.environment}-100-api-deployment"
  description       = "${upper(var.environment)} API DEPLOYMENT"
  organization      = local.org
  working_directory = "services/100-api-deployment"
  tag_names         = ["api:deployment", var.environment]

  speculative_enabled = var.environment != "prod" ? false : true
  queue_all_runs      = true
  allow_destroy_plan  = false
  auto_apply          = true

  vcs_repo {
    branch         = var.environment != "prod" ? var.environment : "main"
    identifier     = local.repo
    oauth_token_id = local.oauth
  }
}

resource "tfe_variable" "api-deployment" {
  key          = "environment"
  value        = var.environment
  category     = "terraform"
  workspace_id = tfe_workspace.api-deployment.id
}

resource "tfe_run_trigger" "ws" {
  for_each      = var.ws_ids
  workspace_id  = tfe_workspace.api-deployment.id
  sourceable_id = each.value
}
