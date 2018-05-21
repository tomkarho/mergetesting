#!/bin/env groovy

def isFeatureBranch(branchName) {return branchName =~ /^feature\/.*$/}

timeout(10) {
    node('master') {
        withCredentials([
            string(credentialsId: 'spUser', variable: 'SPUSER'),
            string(credentialsId: 'spPswd', variable: 'SPPSWD'),
            string(credentialsId: 'spTenant', variable: 'SPTENANT')
            ]){
            stage('Checkout') {
                checkout scm
            }

            def branch = env.BRANCH_NAME;
            def environment = isFeatureBranch(branch) ? 'master' : branch;
            def spPswd = "${env.spPswd}";
            def spTenant = "${env.spTenant}";
            def webApp = "toka-mergetest-{environment}";
            def resourceGroup = 'RG-TOKA';
            def envType = 'Dev';

            if(!isFeatureBranch(branch)) {
                stage('Environment') {
                    sh """
                    pwsh deployment/createEnvironment.ps1 \
                    -spUser $SPUSER \
                    -spPswd $SPPSWD \
                    -spTenant $SPTENANT \
                    -resourceGroup $resourceGroup \
                    -webApp $webApp \
                    -envType $envType
                    """
                }
            }
            if(!isFeatureBranch(branch)) {
                stage('Configure') {
                    sh """
                    pwsh deployment/configure.ps1 \
                    -environment $environment \
                    -webApp $webApp \
                    -resourceGroup $resourceGroup
                    """
                }
            }
            stage('Build') {
            // Requires @angular/cli preinstalled as global.
            // https://github.com/sass/node-sass/issues/1579 for this reason npm rebuild node-sass
            sh """
            npm install --unsafe-perm
            npm rebuild --unsafe-perm node-sass
            npm build --prod
            """
        }
        stage('Test') {
            sh """
            echo "No tests here"
            """
        }
        if(!isFeatureBranch(branch)) {
            stage('Deploy') {
                sh """
                pwsh deployment/deploy.ps1  \
                -resourceGroup $resourceGroup  \
                -webApp $webApp
                """
            }
        }
    }
}
}
