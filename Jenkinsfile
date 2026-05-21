// This file relates to internal XMOS infrastructure and should be ignored by external users

@Library('xmos_jenkins_shared_library@v0.52.0') _

getApproval()
pipeline {

    agent none

    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.1',
            description: 'XTC tools version'
        )
        string(
            name: 'XMOSDOC_VERSION',
            defaultValue: 'v8.2.0',
            description: 'xmosdoc version'
        )
    }

    options {
        skipDefaultCheckout()
        timestamps()
        buildDiscarder(xmosDiscardBuildSettings(onlyArtifacts = false))
    }

    stages {
        stage('🏗️ Build and test') {
            agent {
                label 'x86_64 && linux && documentation'
            }

            stages {
                stage('Checkout') {
                    steps {

                        println "Stage running on ${env.NODE_NAME}"

                        script {
                            def (server, user, repo) = extractFromScmUrl()
                            env.REPO_NAME = repo
                        }

                        dir(REPO_NAME){
                            checkoutScmShallow()
                            sh "git submodule update --init --recursive"
                            createVenv(reqFile: "requirements.txt")
                        }
                    }
                }

                stage('Examples build') {
                    steps {
                        dir("${REPO_NAME}/examples") {
                            xcoreBuild()
                        }
                    }
                }

                // TODO: add checks
                // stage('Repo checks') {
                //     steps {
                //         warnError("Repo checks failed")
                //         {
                //             runRepoChecks("${WORKSPACE}/${REPO_NAME}")
                //         }
                //     }
                // }

                // TODO: add docs
                // stage('Doc build') {
                //     steps {
                //         dir(REPO_NAME) {
                //             buildDocs()
                //         }
                //     }
                // }

                stage('Tests') {
                    steps {
                        dir("${REPO_NAME}/examples/uut_and_tests") {
                            withTools(params.TOOLS_VERSION) {
                                withVenv {
                                    runPytest()
                                }
                            }
                        }
                    }
                }

                stage("Archive sandbox") {
                    steps {
                        archiveSandbox(REPO_NAME)
                    }
                }
            } // stages
            post {
                cleanup {
                    xcoreCleanSandbox()
                }
            }
        } // stage 'Build and test'

        stage('🚀 Release') {
            when {
                expression { triggerRelease.isReleasable() }
            }
            steps {
                triggerRelease()
            }
        }
    } // stages
} // pipeline
