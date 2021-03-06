# Poland iOS

One Europe leads the way to team-work and digital synergies, with the aim of having the best mobile banking app in Europe.

A common app that will become the best Santander showcase and universalize the use of the app as the reference channel on our relationship with clients

This project provides the iOS Core functionalities for any country app for the OneApp application.

OneApp is the ambition of delivering the best digital relationship model on each European market, a common app that will become the best Santander showcase and universalize the use of the app as the reference channel on our relationship with clients OneApp is built implementing a base common app on all European geographies as a starting point and evolving it in a common development hub, that optimizes resources, improves quality and accelerates delivery

This README will guide you on your quest to perform some tasks like creating a new module or the styleguide that should be used.

For more details and common procedures, see the [confluence technical documentation](https://sanone.atlassian.net/wiki/spaces/MOVPL/pages/3797778736/OA-iOS+-+Technical+documentation).

## First steps

After cloning this repo, follow the steps bellow

1º) Install the Submodules

Here we supose that your local folder containing the project is named "poland"
```
$ cd poland
$ git submodule init
$ git submodule update --recursive
```
This will init the santander-one and i18n-poland submodules and update them to the last reference in poland main project.

2º) Install git lfs
You can download it here: https://github.com/git-lfs/git-lfs/releases/download/v3.1.2/git-lfs-darwin-amd64-v3.1.2.zip 
Go to downloaded folder(git-lfs-darwin-amd64-v3) in terminal and run: 

```
$ sudo ./install.sh
```

3º) Install pods

```
$ cd poland/Project
$ pod install
```

In case of error occurs:
__[!] Unable to install vendored xcframework `WebRTC` for Pod `Vcc`, because it contains both static and dynamic frameworks.__

Clean pod cache, install git lfs again and run pod install:
```
$ cd poland/Project
$ pod cache clean --all
$ git lfs install
$ pod install
```
## Development certificates
We use fastlane and match to manage development certificates. To install a development certificate:

1. Install fastlane
2. Execute in poland/Project

```
$ fastlane ios certificates version:0.0
```
The 0.0 version is just inherited from other one app release bundle ids. In Poland app the bundle does not change.

The passphrase is "Santander2021"

## Folder structure overview
```
├── Modules -> Local country modules
├── Project
│   ├── Podfile -> Pods dependencies definition
│   ├── Santander
│   │   ├── AppDelegate.swift
│   │   ├── Configuration -> App parametrization
│   │   ├── Dependencies -> Dependency Injection
│   │   ├── MicrositeLocalConf -> local version for debugging
│   │   └── Modifiers -> Core adaptations for country
│   └──
├── README.md
├── i18n-poland -> Internationalization Poland git submodule
└── santander-one -> Santander one core git submodule
    ├── Accounts
    ├── ...
```
### Project, folders and modules

A crucial idea about the project organization is that folders, repositories and modules are different ways of seeing the project. Just consider the following ideas:

- santander-one folder
    - is a different repository (git submodule)
    - is a physical folder in Mac OS  
    - contains several pod modules that are shown in the project under Development Pods group.
- You can define pod modules in the santander-one level, or in the country one, in Modules/

# Architecture

This project uses __MVP + Coordinators__ architecture pattern. Note that the project uses __git submodules__ and __cocoapods__ to modularize and structure the large code base.

We answer the basic questions needed to understand the app architecture hereunder.

## How the app is built at start?

The app uses a __depency injection service locator pattern__ to create all the dependencies at start. We use the UIKit App Delegate UI cycle, and the application starts in AppDelegate::application(_ application:, didFinishLaunchingWithOptions launchOptions:)

From here, the app starts with the main app container, created with BaseMenuViewController and the dependencies engine.

The dependendencies engine must adopt the **DependenciesResolver** and **DependenciesInjector** protocols.


# App configuration
We use __xcconfig__ files to keep country local app configuration at building time and a microsite configuration mechanism to get runtime configuration.

See [confluence technical documentation about app configuration](https://sanone.atlassian.net/wiki/spaces/MOVPL/pages/3797779600/OA-App+configuration). 

## Local configuration folder

You can find a local copy of microsite configuration files in __Santander/MicrositeLocalConf/__ folder. This configuration files can be modified locally to test app behaviors without changing the actual microsite content.

There are two local configurations that can be selected in test/debug builds from a selector in login screen. The path to these configurations can be found in __PublicFilesHostProvider__ struct.

## Remote microsite URLs

The URL for microsite configuration can change depending on the selected schema. You can set or modify the configuration URLs in __PublicFilesHostProvider__ struct.

## Deprecated version configuration

The app store App id used to redirect the user when current version is deprecated can be configured in the PLCommons submodule in PLConstants

```
public static let appStoreId:Int = 461736062
``` 
A particular version is deprecated if the "versions" node in microsite confguration contains the version with the "active" node with a false value.

```
"versions": {
        "4.0.60": {
            "active": "false",
...
```

# Other tips & tricks

## Demo user

The project has a special user which gives us the ability to use the app without an internet connection. It's very useful when we have to test UI elements without the need for services that can slow down the testing process. In addition we can execute unit tests through this user. Not all of the app's features can be tested through this user

You can add or modify the mocked network responses in __SANPLLibrary__ pod.

## Updating or modifiying the schemas

If you add a new schema, remember to regenerate the pods workspace:

1. Remove podfile.lock, pods/ folder and the .xcworkspace
2. Execute pod install
