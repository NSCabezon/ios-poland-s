Boolean is_develop_branch = BRANCH_NAME.contains("develop")
Boolean is_master_branch = BRANCH_NAME.contains("master")
Boolean is_develop_or_master = is_develop_branch || is_master_branch
String cron_string = is_develop_or_master ? "H 23 * * *" : ""

pipeline {
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
	parameters {
		booleanParam(name: "DEPLOY_TO_INTERN", defaultValue: "${is_develop_branch}", description: "Do you want to deploy INTERN?")
		booleanParam(name: "DEPLOY_TO_DEV", defaultValue: false, description: "Do you want to deploy DEV?")
		booleanParam(name: "DEPLOY_TO_PRE", defaultValue: "${is_master_branch}", description: "Do you want to deploy PRE?")
		booleanParam(name: "RUN_TESTS", defaultValue: false, description: "Do you want to run the build with tests?")
		booleanParam(name: "INCREMENT_VERSION", defaultValue: true, description: "Do you want to increment the build version?")
		choice(name: 'NODE_LABEL', choices: ['poland', 'ios', 'hub'], description: '')
    }
    agent { label params.NODE_LABEL ?: 'poland' }  

	triggers { cron(cron_string) }

	stages {

		stage('install dependencies') {
            steps {
			   sh "git checkout $BRANCH_NAME"
               echo "Installing dependencies"
			   sh "bundle install"
               sh "cd Project && bundle exec fastlane ios update_pods"
            }
         }

		stage('Distribute Intern') {
			when {
				branch 'develop'
                expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
            }
			steps {
				echo "Distributing android app"
				sh "cd Project && bundle exec fastlane ios release deploy_env:intern notify_testers:true branch:develop"
			}
        }

		stage('Compile Intern to Appium') {
			when {
				branch 'develop'
				expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}

            }
			steps {
				catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
					echo "Distributing iOS app"
					sh "cd Project && bundle exec fastlane ios build_appium"
					sh "mv Build/Products/Intern-Debug-iphonesimulator/*.app INTERN.app"
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
				sh "cd Project && bundle exec fastlane ios release deploy_env:pre notify_testers:true branch:master"
			}
		}
		
		stage('Increment Version and Update Repo Version ') {
			when {
				anyOf { branch 'develop'; branch 'master'; branch 'release/*' }
                expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
			}
			steps {
				sh "cd Project && bundle exec fastlane ios increment_version"
			}
         }
	}
	post {
		success {
			cleanWs()
		}
	}
}
