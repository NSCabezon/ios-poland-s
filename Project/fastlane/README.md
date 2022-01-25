fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios upload_for_tests

```sh
[bundle exec] fastlane ios upload_for_tests
```

Build and send to Microsite and TestFlight

### ios create_app_id

```sh
[bundle exec] fastlane ios create_app_id
```

Create app id

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Fetch certificates and provisioning profiles

### ios certificates_release

```sh
[bundle exec] fastlane ios certificates_release
```

Fetch Distribution certificates and provisioning profiles

### ios update_pods

```sh
[bundle exec] fastlane ios update_pods
```

Updating pods and Provisions

### ios test

```sh
[bundle exec] fastlane ios test
```

Test selected example apps

### ios check_pods

```sh
[bundle exec] fastlane ios check_pods
```

Updating pods

### ios swift_lint

```sh
[bundle exec] fastlane ios swift_lint
```

Pass swiftlint

### ios clean_repo

```sh
[bundle exec] fastlane ios clean_repo
```



### ios release

```sh
[bundle exec] fastlane ios release
```



### ios generate_changelog

```sh
[bundle exec] fastlane ios generate_changelog
```



### ios build_appium

```sh
[bundle exec] fastlane ios build_appium
```



### ios increment_version

```sh
[bundle exec] fastlane ios increment_version
```

Incrementing Version

### ios push_tag

```sh
[bundle exec] fastlane ios push_tag
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
