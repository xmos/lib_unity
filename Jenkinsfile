// This file relates to internal XMOS infrastructure and should be ignored by external users

@Library('xmos_jenkins_shared_library@v0.52.0') _

getApproval()

def getRepoNameFromScm() {
    def (server, user, repo) = extractFromScmUrl()
    return repo
}

pipeline {

    agent none

    parameters {
        string(
            name: 'TOOLS_VERSION',
            defaultValue: '15.3.1',
            description: 'XTC tools version'
        )
        string(
            name: 'TOOLS_VX4_VERSION',
            defaultValue: '-j --repo arch_vx_slipgate -b develop -a XTC 1184',
            description: 'XTC Slipgate tools version'
        )
        string(
            name: 'XMOSDOC_VERSION',
            defaultValue: 'v8.1.0',
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
            parallel {
                stage('Target (XS3)') {
                    agent { label 'x86_64 && linux && documentation' }
                    stages {
                        stage('Checkout') {
                            steps {
                                println "Stage running on ${env.NODE_NAME}"
                                script {env.REPO_NAME = getRepoNameFromScm()}
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
                                    withTools(params.TOOLS_VERSION) {
                                        xcoreBuild()
                                    }
                                }
                            }
                        }

                        stage('Repo checks') {
                            steps {
                                warnError("Repo checks failed")
                                {
                                    runRepoChecks("${WORKSPACE}/${REPO_NAME}")
                                }
                            }
                        }

                        stage('Doc build') {
                            steps {
                                dir(REPO_NAME) {
                                    buildDocs()
                                }
                            }
                        }

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
                } // XS3

                stage('Target (VX4)') {
                    agent { label 'vx4' }
                    stages {
                        stage("Checkout and Build") {
                            steps {
                                script {env.REPO_NAME = getRepoNameFromScm()}
                                dir(REPO_NAME){
                                    checkoutScmShallow()
                                    sh "git submodule update --init --recursive"
                                    createVenv(reqFile: "requirements.txt")
                                    dir("examples") {
                                        withTools(params.TOOLS_VX4_VERSION) {
                                            xcoreBuild(toolsVersion: params.TOOLS_VX4_VERSION)
                                        }
                                    }
                                } // dir(REPO_NAME)
                            } // steps
                        } // stage("Checkout and Build")
                    } // stages
                    post {
                        cleanup {
                            xcoreCleanSandbox()
                        }
                    } // post
                } // VX4
            } // parallel
        } // stage('Build and test')

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
