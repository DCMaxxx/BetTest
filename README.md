# BetTest

This project is a test asked by BetClic as a part of their interview process.  
Basically, it simply displays a list of Deezer playlists for a given user, and lets you see their content. Details can be found [in the docs folder](./docs/requirements.txt).  

# Getting started

Everything needed to build the project on the iOS simulator is included in this repo, there's no heavy dependency needed.  
Opening the `.xcodeproj` file is the only step to get started.   
Third party tools and their configuration are described [below](#Third party tools).
```
git clone --recursive git@gitlab.com:DCMaxxx/bettest.git
cd bettest/project
open BetTest.xcodeproj
```

# Project configuration

## Swift
As demanded, the project uses Swift 3 (and specifically Swift 3.1), using the latest Swift 3 command line tools version at this time (`Xcode 8.3.3 (8E3004b)`).  

## Code signing
`Automatically manage signing` is set, since this project is a test and does not need specific code signing settings (such as an Ad Hoc provisioning profile, APNS configuration...).  
The `Team` is set to `None`, so you'll have to select yours if you want to build on device.

## Deployment infos
Since the requirements didn't specify the iOS deployment informations, nor devices, I took the liberty to configure it myself :
  - Deployment target : iOS 10+ [(89% of devices)](https://developer.apple.com/support/app-store/)
  - Devices : Universal
  - Device orientation : Portrait, Landscape (left & right)

## Languages
The application supports both English (base language) and French.

# Third party tools

## Swiftlint
As a reminder, [Swiftlint](https://github.com/realm/SwiftLint) is a linter that enforces the developer to use a certain code-style.  
I decided to use Wopata's rules. The reasoning behind the disabled / configured rules can be found [here](https://github.com/Wopamax/SwiftLintRules).  
There's a custom `Run script` build phases that runs Swiftlint at each build.  
You'll need to have Swiftlint installed system-wide as explained in their README. I usually add it as a CocoaPod so it's included in the repository, but in this case I'm required to use Carthage.

## SwiftGen
As a reminder, [SwiftGen](https://github.com/SwiftGen/SwiftGen) is a tool that generates type-safe identifiers and/or variables for string-typed APIs, such as `UIImage(named:)` or `NSLocalizedString(...)`.  
There's a custom `Run script` build phases that runs SwiftGen at each build. However, the generated files are kept under version control, so you can build the project _without_ installing SwiftGen.  
I decided to use it only for storyboards and localized strings, since I didn't need custom fonts, colors or images.
You'll need to have SwiftGen installed system-wide as explained in their README. I would add it as a CocoaPod, so it's included in the repository, but in this case I'm required to use Carthage.

## Carhtage
As a reminder [Carhtage](https://github.com/Carthage/Carthage) is a dependency manager for Cocoa.  
It is set up as explained is their README, and the `Carthage/Build` folder is kept under version control, so you can build the project without having to install Carthage on your machine.  
All Carthage-related files are kept in the `depencendies` folder, to keep the `project` folder clean. The `project` folder references the built frameworks using a symbolic link (from `Frameworks` to `Carthage/Build/iOS`).
