jenkins_projects = {

  test_job  = {
    folderName          = "test_folder6"
    folderDescription   = "Test folder6"
    createFolder        = "true"
    jobName             = "test_job6"
    jobDescription      = "This is a test job!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }

  demo_job  = {
    folderName          = "test_folder6"
    createFolder        = "false"
    jobName             = "demo_job6"
    jobDescription      = "This is a demo!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }
}
