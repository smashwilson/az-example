workflow "Publish Docker image" {
  on = "push"
  resolves = ["Docker Registry", "GitHub Action for Docker", "Push SHA tag", "Push latest"]
}

action "Docker Registry" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_REGISTRY_URL", "DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "GitHub Action for Docker" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t quay.io/smashwilson/az-example ."
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  needs = ["GitHub Action for Docker"]
  args = "branch master"
}

action "Tag latest" {
  uses = "actions/docker/tag@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Filters for GitHub Actions"]
  args = "az-example quay.io/smashwilson/az-example --no-ref --no-sha"
}

action "Filters for GitHub Actions-1" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  needs = ["GitHub Action for Docker"]
  args = "not branch master"
}

action "Tag by ref and sha" {
  uses = "actions/docker/tag@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Filters for GitHub Actions-1"]
  args = "az-example quay.io/smashwilson/az-example --no-latest"
}

action "Push ref tag" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Tag by ref and sha"]
  args = "push quay.io/smashwilson/az-example:${IMAGE_REF}"
}

action "Push SHA tag" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Push ref tag"]
  args = "push quay.io/smashwilson/az-example:${IMAGE_SHA}"
}

action "Push latest" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Tag latest"]
  args = "push quay.io/smashwilson/az-example:latest"
}
