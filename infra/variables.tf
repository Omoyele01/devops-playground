variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name prefix"
  type        = string
  default     = "devops-playground"
}

variable "cluster_version" {
  description = "EKS version"
  type        = string
  default     = "1.30"
}

variable "node_instance_types" {
  description = "Node instance types"
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_desired_size" {
  description = "Desired nodes"
  type        = number
  default     = 2
}
