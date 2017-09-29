# BetTest

This project is a test asked by BetClic as a part of their interview process.  
Basically, it simply displays a list of Deezer playlists for a given user, and lets you see their content. Details can be found [in the docs folder](./docs/subject.txt).  

# Getting started

Everything needed to build the project on the iOS simulator is included in this repo, there's no heavy dependency needed. Don't forget to clone the submodules as well.  
Opening the `.xcodeproj` file is the only step to get started.   
Third party tools and their configuration are described [below](#Third party tools).
```
git clone --recursive git@gitlab.com:DCMaxxx/bettest.git
cd bettest/project
open BetTest.xcodeproj
```

# Project configuration

## Swift
As demanded, the project uses Swift 3 (and specifically Swift 3.2), using the latest Xcode version at this time (`Xcode 9.0 (9A235)`).

## Code signing
`Automatically manage signing` is set, since this project is a test and does not need specific code signing settings (such as an Ad Hoc provisioning profile, APNS configuration...).  
The `Team` is set to `None`, so you'll have to select yours if you want to build on device.

# Deployment infos
Since the subject didn't specify the iOS deployment informations, nor devices, I took the liberty to configure it myself :
  - Deployment target : iOS 10+ [89% of devices](https://developer.apple.com/support/app-store/)
  - Devices : Universal
  - Device orientation : Portrait, Landscape (left & right)

# Third party tools

## Swiftlint
As a reminder, [Swiftlint](https://github.com/realm/SwiftLint) is a linter that enforces the developer to use a certain code-style.  
I decided to use Wopata's rules and configuration system. The `.swiftlint.yml` is in submodule, which has a README explaning the reasoning behind the disabled / configured rules.  
You'll need to have Swiftlint installed system-wide as explained in their README. I usually add it as a CocoaPod so it's included in the repository, but in this case I'm required to use Carthage.
