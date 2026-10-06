def versions = [3.3, 3.4, 4.0]

def runSonarIfVersion(sourceDir, ver){
    // Only run Sonar once.
    // Check for new versions at https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/
    def sonarScannerVersion = "8.1.0.6389-linux-x64"
    def sonarExec = ""

    if(ver == 4.0) {
        def mySonarOpts= "-Dsonar.sources=/source -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.token=${env.SONAR_AUTH_TOKEN} -Dsonar.ruby.coverage.reportPaths=coverage/coverage.json"
        if("${env.CHANGE_ID}" != "null"){
            mySonarOpts = "$mySonarOpts -Dsonar.pullrequest.key=${env.CHANGE_ID} -Dsonar.pullrequest.branch=${env.BRANCH_NAME}"
        } else {
            mySonarOpts = "$mySonarOpts -Dsonar.branch.name=${env.BRANCH_NAME}"
        }
        if ("${env.CHANGE_BRANCH}" != "null") {
            mySonarOpts="$mySonarOpts -Dsonar.pullrequest.base=${env.CHANGE_TARGET} -Dsonar.pullrequest.branch=${env.CHANGE_BRANCH}"
        }
        sonarExec="cd /root/ && \
                   wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${sonarScannerVersion}.zip && \
                   unzip -q sonar-scanner-cli-${sonarScannerVersion}.zip && \
                   cd /source && \
                   /root/sonar-scanner-${sonarScannerVersion}/bin/sonar-scanner ${mySonarOpts}"
    } else {
        sonarExec="echo Skipping Sonar for this version."
    }

    sh "docker run \
            --pull always \
            --env DEBIAN_FRONTEND=noninteractive \
            --rm --volume ${sourceDir}:/source \
            ruby:${ver}-slim \
            bash -c \"echo && \
            echo [INFO] Testing with Ruby ${ver} && \
            echo && \
            echo [INFO] Updating package manager database. && \
            apt-get update -qq && \
            echo && \
            echo [INFO] Installing required OS packages. && \
            apt-get -qq install -y gcc make wget unzip libyaml-dev > /dev/null && \
            echo && \
            echo [INFO] Removing any artifacts from prior executions. && \
            rm -rf coverage .bundle Gemfile.lock *.gem && \
            echo && \
            echo [INFO] Installing gems needed for CI. && \
            gem install --silent --quiet bundler rspec rubocop && \
            cd /source && \
            echo && \
            echo [INFO] Running rubocop. && \
            rubocop && \
            echo && \
            echo [INFO] Running bundle install. && \
            bundle install --quiet && \
            echo && \
            echo [INFO] Running unit tests. && \
            rspec tests && \
            echo && \
            echo [INFO] Building gem. && \
            gem build rosette_api.gemspec && \
            echo && \
            echo [INFO] Installing gem. && \
            gem install rosette_api-*.gem && \
            echo && \
            echo [INFO] Executing Sonar if required. && \
            ${sonarExec} && \
            echo && \
            echo [INFO] Re-permission files for cleanup. && \
            chown -R 9960:9960 /source\""
}

node ("docker-light") {
    def sourceDir = pwd()
    try {
        stage("Clean up") {
            step([$class: 'WsCleanup'])
        }
        stage("Checkout Code") {
            checkout scm
        }
        stage("Build & Test") {
            withSonarQubeEnv {
                versions.each { ver ->
                    runSonarIfVersion(sourceDir, ver)
                }
            }
        }
        postToTeams(true)
    } catch (e) {
        currentBuild.result = "FAILED"
        postToTeams(false)
        throw e
    }
}

def postToTeams(boolean success) {
    def webhookUrl = "${env.TEAMS_PNC_JENKINS_WEBHOOK_URL}"
    def color = success ? "#00FF00" : "#FF0000"
    def status = success ? "SUCCESSFUL" : "FAILED"
    def message = "*" + status + ":* '${env.JOB_NAME}' - [${env.BUILD_NUMBER}] - ${env.BUILD_URL}"
    office365ConnectorSend(webhookUrl: webhookUrl, color: color, message: message, status: status)
}
