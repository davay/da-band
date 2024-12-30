## Status 

| Related Milestone | Task | Status | Description | 
|------------------|------|--------|-------------|
| M1 | Setup BLE Communication | :construction:{title="In Progress"} | Implement basic BLE connection and data reception |
| M1 | Create Recording UI | :white_check_mark:{title="Planned"} | Button UI for 3-second recording |
| M2 | Implement Rolling Window | :white_large_square:{title="Planned"} | Process continuous data stream with 3s window |
| M3 | Add Notification System | :white_large_square:{title="Planned"} | User feedback notifications for gesture detection |
| M4 | Power Management UI | :white_large_square:{title="Planned"} | Interface to show band's power state |

## Development 

### Dependencies

This project uses [Tuist](https://example.com)

``` 
brew install --cask tuist
```

See Bumble's article on SPM vs Tuist vs Bazel (part 3/3 [here](https://medium.com/bumble-tech/scaling-ios-at-bumble-6f0602682903))

### Quick Start

The project was created using `tuist init`. By default it creates a project that represents an iOS application. 

The project directory will contain a Project.swift, which describes the project, a Tuist.swift, which contains project-scoped Tuist configuration, and \<app-name\>/, which contains the source code of the application. 

Note that unlike Xcode projects, which you can open and edit directly, Tuist projects are generated from a manifest file. This means that you should not edit the generated Xcode project directly.

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

## Design

### Capabilities

- Create + name new gestures
- Record movement samples to train gesture recognition
- Connect gestures -> actions
    - HomeKit API
    - Shortcuts API
    - Mouse input 
- Real-time classification of raw_data -> gestures -> actions


## Resources 
