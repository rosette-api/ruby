node ("docker-light") {
    def SOURCEDIR = pwd()
    try {
        stage("Clean up") {
            step([$class: 'WsCleanup'])
        }
        stage("Checkout Code") {
            checkout scm
        }
        stage("Build Docker Image") {
            sh "docker build -f jenkins.Dockerfile -t rosette/jenkins-ruby:jenkins-${env.BUILD_NUMBER} ."
        }
        stage("Test with Docker") {
            echo "${env.ALT_URL}"
            def useUrl = ("${env.ALT_URL}" == "null") ? "${env.BINDING_TEST_URL}" : "${env.ALT_URL}"
            withEnv(["API_KEY=${env.ROSETTE_API_KEY}", "ALT_URL=${useUrl}"]) {
                sh "docker run --rm -e API_KEY=${API_KEY} -e ALT_URL=${ALT_URL} -v ${SOURCEDIR}:/source rosette/jenkins-ruby:jenkins-${env.BUILD_NUMBER}"
            }
        }
        postToTeams(true)
    } catch (e) {
        currentBuild.result = "FAILED"
        postToTeams(false)
        throw e
    } finally {
        sh "docker image rm rosette/jenkins-ruby:jenkins-${env.BUILD_NUMBER} || true"
    }
}

def postToTeams(boolean success) {
    def webhookUrl = "${env.TEAMS_PNC_JENKINS_WEBHOOK_URL}"
    def color = success ? "#00FF00" : "#FF0000"
    def status = success ? "SUCCESSFUL" : "FAILED"
    def message = "*" + status + ":* '${env.JOB_NAME}' - [${env.BUILD_NUMBER}] - ${env.BUILD_URL}"
    office365ConnectorSend(webhookUrl: webhookUrl, color: color, message: message, status: status)
}
