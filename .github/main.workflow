workflow "Publish :latest from master" {
  on = "push"
  resolves = ["Push latest tag"]
}

workflow "Publish :sha and :ref from non-master" {
  on = "push"
  resolves = ["Push SHA tag", "Push ref tag"]
}

action "Docker Registry" {
  uses = "actions/docker/login@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  secrets = ["DOCKER_REGISTRY_URL", "DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "Master branch" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "branch master"
}

action "Non-master branches" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  args = "not branch master"
}

action "Build Docker image" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  args = "build -t az-example ."
}

action "Tag latest" {
  uses = "actions/docker/tag@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Master branch", "Build Docker image"]
  args = "az-example quay.io/smashwilson/az-example --no-ref --no-sha"
}

action "Tag by ref and sha" {
  uses = "actions/docker/tag@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Non-master branches", "Build Docker image"]
  args = "az-example quay.io/smashwilson/az-example --no-latest"
}

action "Push ref tag" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Registry", "Tag by ref and sha"]
  args = "push quay.io/smashwilson/az-example:${IMAGE_REF}"
}

action "Push SHA tag" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Registry", "Tag by ref and sha"]
  args = "push quay.io/smashwilson/az-example:${IMAGE_SHA}"
}

action "Push latest tag" {
  uses = "actions/docker/cli@8cdf801b322af5f369e00d85e9cf3a7122f49108"
  needs = ["Docker Registry", "Tag latest"]
  args = "push quay.io/smashwilson/az-example:latest"
}
