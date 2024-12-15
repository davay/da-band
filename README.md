## Description

Idea:
- MEG sensors on wrist -raw_data-> iOS app
- iOS app: 
    - Create + name new gestures
    - Record movement samples to train gesture recognition
    - Connect gestures -> actions
        - HomeKit API
        - Shortcuts API
        - Mouse input 
    - Real-time classification of raw_data -> gestures -> actions

## Project Structure

```
da-band/
├── band/    # PlatformIO-managed arduino project for wristband firmware
└── ios/     # Tuist-managed Xcode project for iOS app
```

## TODO 

1. uMyo sensor supports 3 modes right now: RF24, RF52, and BLE Advertising mode. If we want to connect to iOS, BLE Advertising mode limits bandwidth too much. Need to reverse engineer and flash a firmware with BLE GATT capabilities.

## Band

### Dependencies

1. PlatformIO

```
TODO
```

### Quick Start 

```
TODO
```

## iOS

### Dependencies

1. Tuist

``` 
brew install --cask tuist
```

See Bumble's article on SPM vs Tuist vs Bazel (part 3/3 [here](https://medium.com/bumble-tech/scaling-ios-at-bumble-6f0602682903))

2. TODO

### Quick Start

The project was created using `tuist init`. By default it creates a project that represents an iOS application. 

The project directory will contain a Project.swift, which describes the project, a Tuist.swift, which contains project-scoped Tuist configuration, and \<app-name\>/, which contains the source code of the application. 

Note that unlike Xcode projects, which you can open and edit directly, Tuist projects are generated from a manifest file. This means that you should not edit the generated Xcode project directly.

---

To work on it in Xcode:
```
tuist generate
```

To build binaries:
```
tuist build
```

To run tests:
```
tuist test
```
