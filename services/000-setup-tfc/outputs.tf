
output "ws_name" {
  value = {
    "dev"   = { for k in keys(local.services) : k => module.workspace_dev[k].ws_name }
    "stage" = { for k in keys(local.services) : k => module.workspace_stage[k].ws_name }
    "prod"  = { for k in keys(local.services) : k => module.workspace_prod[k].ws_name }
  }
}
