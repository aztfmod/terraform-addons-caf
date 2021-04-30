# provider "jenkins" {
#   server_url = "http://40.124.120.124:8080" # Or use JENKINS_URL env var
#   username   = "kavithago"            # Or use JENKINS_USERNAME env var
#   password   = "M9i%IyoAM-K2oSf"            # Or use JENKINS_PASSWORD env var
#   ca_cert = ""                       # Or use JENKINS_CA_CERT env var
# }

resource "jenkins_folder" "project" {
  name               = lookup(var.project, "name", "")
}

# Create a Jenkins job
resource "jenkins_job" "project" {
  name     = lookup(var.project, "name", "")
  folder   = jenkins_folder.project.id
  template = file("${path.module}/job.xml")

  parameters = {
    description = "An example job created from Terraform"
  }
}
