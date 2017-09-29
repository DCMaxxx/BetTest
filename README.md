# BetTest

This project is a test asked by BetClic as a part of their interview process.  
Basically, it simply displays a list of Deezer playlists for a given user, and lets you see their content. Details can be found [in the docs folder](./docs/subject.txt).  


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
