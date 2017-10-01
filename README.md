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
You'll need to have Swiftlint installed system-wide as explained in their README.  
I usually add it as a CocoaPod so it's included in the repository, but in this case I'm required to use Carthage.

## SwiftGen
As a reminder, [SwiftGen](https://github.com/SwiftGen/SwiftGen) is a tool that generates type-safe identifiers and/or variables for string-typed APIs, such as `UIImage(named:)` or `NSLocalizedString(...)`.  
There's a custom `Run script` build phases that runs SwiftGen at each build. However, the generated files are kept under version control, so you can build the project _without_ installing SwiftGen.  
I decided to use it only for storyboards and localized strings, since I didn't need custom fonts, colors or images.  
You'll need to have SwiftGen installed system-wide as explained in their README. I would add it as a CocoaPod, so it's included in the repository, but in this case I'm required to use Carthage.

## Carhtage
As a reminder [Carhtage](https://github.com/Carthage/Carthage) is a dependency manager for Cocoa.  
It is set up as explained is their README, and the `Carthage/Build` folder is kept under version control, so you can build the project without having to install Carthage on your machine.  
However, you won't be able to submit to the App Store without having Carthage installed (see `Getting started / point 4` in their README for more infos).  
All Carthage-related files are kept in the `depencendies` folder, to keep the `project` folder clean. The `project` folder references the built frameworks using a symbolic link (from `Frameworks` to `Carthage/Build/iOS`).

# Code organization

As explained during the interview, I've never used RxSwift nor MVVM before, even though I know the idea behind those.  
I've tried to separate layers, responsibilities, and components as much as possible.  
There might be places where you'd have done it differently, and this code is completely open for suggestion. After all, I believe we always learn, so I'd be happy to learn with people more experienced Rx devs.

## Layers

### Fetchers
Fetchers are the lowest-level of the layers.  
Their responsibilities are to fetch and expose a list of raw objects ('FetchedObject').

### Models
Models represents an object whose properties can be observed.  
They can be initialized using FetchedObjects.

### ViewModels
ViewModels represents an object whose properties are formatted and can be displayed as-is, and can be observed.  
They can be initialized using Models.

## Notes

### DurationFormatter
I've used a singleton for the `DurationFormatter` class in order no to create a new formatter for each cell.  
I know this is probably not the solution you wanted, but I'm not really familiar with how you perform dependency injection at the cell level at BetClic.  
As said earlier, I'm more than willing to learn though.

### View Controllers navigation
In this example, I haven't implemented a generic way to navigate from a view controller to another, since there are only two controllers.  

### 'Collapsing toolbar'
The requirements states that 
> Display a playlist consist of displaying a header in a collapsing toolbar, showing playlist cover, title, author, formatted duration  

However, as a collapsing toolbar is an Android component, so I assumed this was made for Android. I've simply implemented it using the navigationController's navigationBar for the title, and the tableView's tableHeaderView for the rest of the informations.  
If I had to mimic Android's collapsing toolbar, I'd have hidden the navigationBar, added an inset to the tableView's top, and added a view that adapts it size based on the tableView's contentOffset.  
Or, depending on the context, if the layout was more complex, I'd use a custom collectionView layout.

### ViewModel coupling
This is more an open question than an note.  
In this test, a `PlaylistFetcher` has a computed property that builds a `PlaylistTracksFetcher` for this playlist. This coupling goes all the way to the model, and the view model.  
However, I'd rather not have this strong link, and simply have `TracksFetcher` use an `URL`, independently from a playlist (since we might want to fetch a list of tracks by itself).  
However, this would mean I'd have to make the URL go all the way to the ViewModel, so the controller using the ViewModel could instanciate a `TracksFetcher` using this URL. But (yeah, there's a but) the ViewModel does not need this URL, there's no need to display it anywhere.  
I'm satisfied by neither solution, so if you have a better solution, I'm all ears !

# Contact
If you have any question, feel free to contact me :
- By mail : [maxime.dechalendar@me.com](maxime.dechalendar@me.com)
- By phone : [07 60 98 02 77](tel:+33760980277)