# Create a Jenkins Folder
resource "jenkins_folder" "job" {
  name               = lookup(var.job, "folderName", "")
  count              = var.job.folderName=="" ? "0":"1"
}

# Create a Jenkins job
resource "jenkins_job" "job" {
  name     = lookup(var.job, "jobName", "")
  folder   =  var.job.folderName=="" ? null:jenkins_folder.job[0].id
  template = file("${path.module}/job.xml")
  parameters = {
    description = lookup(var.job, "description", "")
  }
}
