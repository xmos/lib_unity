@Library('xmos_jenkins_shared_library@v0.50.0') _

getApproval()
pipeline {
  agent none
  parameters {
    string(
      name: 'TOOLS_VERSION',
      defaultValue: '15.3.1',
      description: 'XTC tools version'
    )
  }
  stages {
    stage('CI') {
      agent {
        label 'linux&&x86_64'
      }
      stages {
        stage ('Build') {
          steps {
            runningOn(env.NODE_NAME)
            dir("lib_unity") {
              checkout scm
              sh "git submodule update --init --recursive"
            }
            createVenv("lib_unity/requirements.txt")
            dir("lib_unity/example/uut_and_tests") {
              withTools(params.TOOLS_VERSION) {
                withVenv {
                  runPytest()
                }
              }
            }
          }
        }
      }
      post {
        cleanup {
          xcoreCleanSandbox()
        }
      }
    } // stage('CI')
  
    stage('🚀 Release') {
      when {expression { triggerRelease.isReleasable()}}
      steps {triggerRelease()}
    } // stage('🚀 Release')
  }
}
