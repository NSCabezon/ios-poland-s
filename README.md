# Poland iOS

This is the Poland santander-one Readme file. In this document you can find a general overview of the app. For more details and common procedures, see the [confluence technical documentation](https://sanone.atlassian.net/wiki/spaces/MOVPL/pages/3797778736/OA-iOS+-+Technical+documentation).

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

2º) Install pods

```
$ cd poland/Project
$ pod install
```

## Development certificates
We use fastlane and match to manage development certificates. To install a development certificate:

1. Install fastlane
2. Execute in poland/Project

```
TODO
```

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
