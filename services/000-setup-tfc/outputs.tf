
output "ws_name" {
  value = {
    "dev"   = { for k in keys(local.services) : k => { name = module.workspace_dev[k].ws_name, id = module.workspace_dev[k].ws_id } }
    "stage" = { for k in keys(local.services) : k => { name = module.workspace_stage[k].ws_name, id = module.workspace_stage[k].ws_id } }
    "prod"  = { for k in keys(local.services) : k => { name = module.workspace_prod[k].ws_name, id = module.workspace_prod[k].ws_id } }
  }
}
