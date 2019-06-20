workflow "Build and push Docker container" {
  on = "push"
  resolves = ["Build"]
}

action "Build" {
  uses = "smashwilson/az-infra/actions/azbuild@action"
  secrets = ["DOCKER_REGISTRY_URL", "DOCKER_USERNAME", "DOCKER_PASSWORD"]
}
