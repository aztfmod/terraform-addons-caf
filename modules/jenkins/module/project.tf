# Create a Jenkins Folder if foldername!="" and createFolder="true"
resource "jenkins_folder" "folder" {
  name               = lookup(var.job, "folderName", "")
  description        = lookup(var.job, "folderDescription", "")
  count              = (var.job.folderName!="" && var.job.createFolder=="true")? "1":"0"
}

# Create a Jenkins job
resource "jenkins_job" "job" {
  name        = lookup(var.job, "jobName", "")
  folder      = var.job.folderName!=""?var.job.folderName:null
  template    = file("${path.module}/job.xml")
  parameters  = {
    description = lookup(var.job, "jobDescription", "")
    repoUrl     = lookup(var.job, "repoUrl", "")
    branchname  = lookup(var.job, "branchname", "")
    jenkinsCredentialsId  = lookup(var.job, "jenkinsCredentialsId", "")
  }
}
