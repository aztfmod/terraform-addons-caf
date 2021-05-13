jenkins_projects = {

  test_job  = {
    folderName          = "test_folder5"
    folderDescription   = "Test folder5"
    createFolder        = "true"
    jobName             = "test_job5"
    jobDescription      = "This is a test job!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }

  demo_job  = {
    folderName          = "test_folder5"
    createFolder        = "FALSE"
    jobName             = "demo_job5"
    jobDescription      = "This is a demo!"
    repoUrl             = "https://github.com/taiidani/terraform-provider-jenkins.git"
    branchname          = "master"
    jenkinsCredentialsId = "Jenkins-Runner-Node"
  }
}
