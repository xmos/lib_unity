@Library('xmos_jenkins_shared_library@v0.28.0') _

def runningOn(machine) {
  println "Stage running on:"
  println machine
}
getApproval()

pipeline {
  agent none
  parameters {
    string(
      name: 'TOOLS_VERSION',
      defaultValue: '15.3.0',
      description: 'The tools version to build with (check /projects/tools/ReleasesTools/)'
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
            withVenv {
              sh "pip install -r lib_unity/requirements.txt"
            }
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
    }
  }
}
