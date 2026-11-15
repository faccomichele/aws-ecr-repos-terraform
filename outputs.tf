output "docker_dirs" {
  description = "Directories containing Dockerfiles used as ECR repository keys"
  value       = sort(tolist(local.docker_dirs))

  precondition {
    condition     = length(local.docker_dirs) > 0
    error_message = "No ECR repositories were discovered. Add a Dockerfile to at least one immediate child directory of the Terraform working directory."
  }
}