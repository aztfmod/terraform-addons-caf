jenkins_projects = {

  test_job  = {
    folderName          = "test_folder7"
    folderDescription   = "Test folder7"
    createFolder        = "false"
    jobName             = "test_job"
    jobDescription      = "This is a test job!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }

  demo_job  = {
    folderName          = "test_folder7"
    createFolder        = "false"
    jobName             = "demo_job"
    jobDescription      = "This is a demo!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }
}
