resource "vercel_project" "nextjs" {
  name      = "${var.resource_prefix}-web"
  framework = "nextjs"
  
  git_repository = {
    type = "github"
    repo = var.github_repo
  }

  root_directory = "web"
  
  environment = [
    {
      key    = "NEXT_PUBLIC_API_URL"
      value  = var.api_url
      target = ["production"]
    },
    {
      key    = "NEXT_PUBLIC_ENVIRONMENT"
      value  = var.environment
      target = ["production"]
    },
    {
      key    = "NEXT_PUBLIC_API_URL"
      value  = var.api_url
      target = ["preview", "development"]
    },
    {
      key    = "NEXT_PUBLIC_ENVIRONMENT"
      value  = "develop" 
      target = ["preview", "development"]
    }
  ]
}
