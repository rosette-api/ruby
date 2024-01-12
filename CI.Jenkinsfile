

def versions = [3.0, 3.1, 3.2, 3.3]

def runSonnarForPythonVersion(sourceDir, ver){
    mySonarOpts="-Dsonar.sources=/source -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
    if("${env.CHANGE_ID}" != "null"){
        mySonarOpts = "$mySonarOpts -Dsonar.pullrequest.key=${env.CHANGE_ID} -Dsonar.pullrequest.branch=${env.BRANCH_NAME}"
    } else {
        mySonarOpts = "$mySonarOpts -Dsonar.branch.name=${env.BRANCH_NAME}"
    } 
    if ("${env.CHANGE_BRANCH}" != "null") {
        mySonarOpts="$mySonarOpts -Dsonar.pullrequest.base=${env.CHANGE_TARGET} -Dsonar.pullrequest.branch=${env.CHANGE_BRANCH}"
    }

    // Only run Sonar once.
    // Check for new versions at https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/
    if(ver == 3.3) {
        sonarExec="cd /root/ && \
                   wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.1.3023-linux.zip && \
                   unzip -q sonar-scanner-cli-4.8.1.3023-linux.zip && \
                   cd /source && \
                   /root/sonar-scanner-4.8.1.3023-linux/bin/sonar-scanner ${mySonarOpts}"
    } else {
        sonarExec="echo Skipping Sonar for this version."
    }

    sh "docker run \
            --pull always \
            --rm --volume ${sourceDir}:/source \
            ruby:${ver}-slim \
            bash -c \"echo && \
            echo [INFO] Testing with Ruby ${ver} && \
            echo && \
            echo [INFO] Updating package manager database. && \
            apt-get update -qq && \
            echo && \
            echo [INFO] Installing required OS packages. && \
            apt-get -qq install -y gcc make wget unzip > /dev/null && \
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
            echo [INFO] Removing any coverage data from prior executions. && \
            rm -rf coverage && \
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
            ${sonarExec}\""
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
                    runSonnarForPythonVersion(sourceDir, ver)
                }
            }
        }
    } catch (e) {
        currentBuild.result = "FAILED"
        throw e
    }
}
