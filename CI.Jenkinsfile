

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
            bash -c \"apt-get update && \
            apt-get install -y gcc make wget unzip && \
            gem install rspec rubocop && \
            cd /source && \
            rubocop --format json --out rubocop-out.json && \
            bundle install && \
            rspec tests && \
            gem build rosette_api.gemspec && \
            gem install rosette_api-*.gem && \
            cd examples && \
            for example in \$(ls *.rb); do ruby \${example} ${env.ROSETTE_API_KEY}; done && \
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
