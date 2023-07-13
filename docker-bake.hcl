variable "DOCKER_REGISTRY" {
  default = "ghcr.io"
}
variable "DOCKER_ORG" {
  default = "darpa-askem"
}
variable "VERSION" {
  default = "local"
}

# ----------------------------------------------------------------------------------------------------------------------

function "tag" {
  params = [image_name, prefix, suffix]
  result = [ "${DOCKER_REGISTRY}/${DOCKER_ORG}/${image_name}:${check_prefix(prefix)}${VERSION}${check_suffix(suffix)}" ]
}

function "check_prefix" {
  params = [tag]
  result = notequal("",tag) ? "${tag}-": ""
}

function "check_suffix" {
  params = [tag]
  result = notequal("",tag) ? "-${tag}": ""
}

# ----------------------------------------------------------------------------------------------------------------------

group "prod" {
  targets = ["mit-tr"]
}

group "default" {
  targets = ["mit-tr-base"]
}

# ----------------------------------------------------------------------------------------------------------------------

target "_platforms" {
  platforms = ["linux/amd64", "linux/arm64"]
}

target "mit-tr-base" {
  context = "."
  tags = tag("mit-tr", "", "")
  dockerfile = "Dockerfile"
}

target "mit-tr" {
  inherits = ["_platforms", "mit-tr-base"]
}
