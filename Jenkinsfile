String cron_string = BRANCH_NAME.contains("develop") ? "H 2 * * *" : ""

pipeline {
	agent any
	environment {
		APP_NAME = 'poland'
		LANG = 'en_US.UTF-8'
		LANGUAGE = 'en_US.UTF-8'
		LC_ALL = 'en_US.UTF-8'
        MATCH_PASSWORD=credentials('jenkins-match-password')
		COMMIT_MESSAGE = sh(script: 'git log --oneline --format=%B -n 1 $GIT_COMMIT', returnStdout: true).trim()
		NEXUS_USERNAME=credentials('jenkins-nexus-username')
		NEXUS_PASSWORD=credentials('jenkins-nexus-password')
		APPLE_ID=credentials('jenkins-apple-id')
      	FASTLANE_ITC_TEAM_ID=credentials('jenkins-team-id-enterprise')
      	FASTLANE_USER=credentials('jenkins-apple-id')
	}

	triggers { cron(cron_string) }

	stages {

		stage('install dependencies') {
            steps {
			   sh "git checkout $BRANCH_NAME"
               echo "Installing dependencies"
               sh "cd Project && fastlane ios update_pods"
            }
         }

		stage('Distribute Intern') {
			when {
				branch 'develop'
                expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
            }
			steps {
				echo "Distributing android app"
				sh "cd Project && fastlane ios release deploy_env:intern notify_testers:true branch:develop"
			}
        }

		stage('Compile Intern to Appium') {
			when {
				branch 'develop'
				expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}

            }
			steps {
				catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
					echo "Distributing android app"
					sh "cd Project && fastlane ios build_appium"
					sh "mv Build/Products/intern-iphonesimulator/*.app INTERN.app"
					sh 'zip -vr INTERN.zip INTERN.app/ -x "*.DS_Store"'
					archiveArtifacts artifacts: 'INTERN.zip'
				}
			}
        }

		stage('Distribute Pre iOS') {
			when {
				anyOf { branch 'master'; branch 'release/*' }	
			}
			steps {
				echo "Distributing Pre app"
				sh "cd Project && fastlane ios release deploy_env:pre notify_testers:true branch:master"
			}
		}
		
		stage('Increment Version and Update Repo Version ') {
			when {
				anyOf { branch 'develop'; branch 'master'; branch 'release/*' }
                expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
			}
			steps {
				sh "cd Project && fastlane ios increment_version"
			}
         }
	}
	post {
		success {
			cleanWs()
		}
	}
}
