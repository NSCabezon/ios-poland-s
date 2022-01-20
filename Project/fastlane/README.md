fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios upload_for_tests
```
fastlane ios upload_for_tests
```
Build and send to Microsite and TestFlight
### ios create_app_id
```
fastlane ios create_app_id
```
Create app id
### ios certificates
```
fastlane ios certificates
```
Fetch certificates and provisioning profiles
### ios certificates_release
```
fastlane ios certificates_release
```
Fetch Distribution certificates and provisioning profiles
### ios update_pods
```
fastlane ios update_pods
```
Updating pods and Provisions
### ios test
```
fastlane ios test
```
Test selected example apps
### ios check_pods
```
fastlane ios check_pods
```
Updating pods
### ios swift_lint
```
fastlane ios swift_lint
```
Pass swiftlint
### ios clean_repo
```
fastlane ios clean_repo
```

### ios release
```
fastlane ios release
```

### ios generate_changelog
```
fastlane ios generate_changelog
```

### ios build_appium
```
fastlane ios build_appium
```

### ios increment_version
```
fastlane ios increment_version
```
Incrementing Version
### ios push_tag
```
fastlane ios push_tag
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
