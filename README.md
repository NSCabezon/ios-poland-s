# Poland

This is the Poland santander-one Readme file. In this document you can find a general overview of the app. For more details and common procedures, see the confluence technical documentation.

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

## Folder structure overview
```
├── Modules -> Local country modules
├── Project
│   ├── Podfile -> Pods dependencies definition
│   ├── Santander
│   │   ├── AppDelegate.swift
│   │   ├── Configuration -> App parametrization
│   │   ├── Dependencies -> Dependency Injection
│   │   └──Modifiers -> Core adaptations for country
│   └── 
├── README.md
├── i18n-poland -> Internationalization Poland git submodule
└── santander-one -> Santander one core git submodule
    ├── Accounts
    ├── ...
```


# Architecture

This project uses __MVP + Coordinators__ architecture pattern. Note that the project uses __git submodules__ and __cocoapods__ to modularize and structure the large code base.

We answer the basic questions needed to understand the app architecture hereunder.

## How the app is built at start?

The app uses a __depency injection service locator pattern__ to create all the dependencies at start. We use the UIKit App Delegate UI cycle, and the application starts in AppDelegate::application(_ application:, didFinishLaunchingWithOptions launchOptions:)

From here, the app starts with the main app container, created with BaseMenuViewController and the dependencies engine.

The dependendencies engine must adopt the **DependenciesResolver** and **DependenciesInjector** protocols.

## How are view actions handled?
TODO
## How is model data applied to the view?
TODO
## How are navigation and other non-model state handled?
TODO
## What testing strategies are used?
TODO

# App configuration
We use __xcconfig__ files to keep country local app configuration at building time and a microsite configuration mechanism to get runtime configuration.

## Build time configuration
You can check local configuration for each schema in __Santader/Configuration__ folder. For example you can see the Intern schema configuration in INTERN.xcconfig

### Adding xcconfig variables

Each variable described in this file has an equivalent entry in the app info.plist. If you need to add a new value in some point in the future, you will need to update the info.plist with an entry like:

```
<key>ENVIRONMENTS_AVAILABLE</key>
<string>$(ENVIRONMENTS_AVAILABLE)</string>
```
and in the xcconfig file you will add the value for each environment:

```
ENVIRONMENTS_AVAILABLE = YES
```
We can configure also general iOS environment variables from xcconfig files. For instance, the CFBundleName is connected to $PRODUCT_NAME variable, which is defined in the xcconfig file.

### Accessing xcconfig variables
TODO

## Microsite dynamic configuration
TODO

# Other tips & tricks
## Updating or modifiying the schemas

If you add a new schema, remember to regenerate the pods workspace:

1º) Remove podfile.lock, pods/ folder and the .xcworkspace
2º) execute pod install

