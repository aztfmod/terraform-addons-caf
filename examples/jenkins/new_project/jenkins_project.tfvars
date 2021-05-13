jenkins_projects = {

  test_job  = {
    folderName          = "test_folder4"
    folderDescription   = "Test folder4"
    createFolder        = "true"
    jobName             = "test_job4"
    jobDescription      = "This is a test job!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }

  demo_job  = {
    folderName          = "test_folder4"
    createFolder        = "FALSE"
    jobName             = "demo_job4"
    jobDescription      = "This is a demo!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }
}
