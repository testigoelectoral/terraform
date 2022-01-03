
resource "tfe_workspace" "ws" {
  name              = "${var.environment}-${var.key}-${var.service}"
  description       = "${upper(var.environment)} ${replace(var.service, "-", " ")}"
  organization      = local.org
  working_directory = "services/${var.key}-${var.service}"
  tag_names         = [replace(var.service, "-", ":"), var.environment]

  speculative_enabled = var.environment != "prod" ? false : true
  queue_all_runs      = true
  allow_destroy_plan  = false

  vcs_repo {
    branch         = var.environment != "prod" ? var.environment : "main"
    identifier     = local.repo
    oauth_token_id = local.oauth
  }

}

resource "tfe_variable" "env" {
  key          = "environment"
  value        = var.environment
  category     = "terraform"
  workspace_id = tfe_workspace.ws.id
}
