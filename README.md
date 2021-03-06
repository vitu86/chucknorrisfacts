# Chuck Norris Facts
## What?
A way to find some Chuck Norris Facts. Enjoy it!
## How it works?
User can search for facts using an input text, a suggestion showed as tag cloud or the search history.

## How to run:
1. You can [clone](https://help.github.com/en/articles/cloning-a-repository) or [download](https://stackoverflow.com/questions/6466945/fastest-way-to-download-a-github-project) the repository
2. [Install CocoaPods on your machine](https://guides.cocoapods.org/using/getting-started.html) (Just if your don't have it yet)
3. Run `pod install` in the project folder
4. You're free to run

## Detailed explanation
#### There are two screens on the project:
1. **Home screen:** Here the user see the list of facts. And a message while there's no facts to show.
2. **Search screen:** Here the user search for the fact. He can search for a term you input, a tag choosed on the tag cloud or choosing any entry from the search history (terms with no result don't go to the history). He can, also, delete any history entry by swiping.

## Libraries used
1. [MaterialComponents](https://github.com/material-components/material-components-ios)
     - For loading progress and text field customization
2. [DGCollectionViewLeftAlignFlowLayout](https://github.com/Digipolitan/collection-view-left-align-flow-layout)
     - For keep tag cloud aligned to left
3. [RxSwift](https://github.com/ReactiveX/RxSwift) and [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa)
     - For bind lists and collections to their data
4. [Alamofire](https://github.com/Alamofire/Alamofire)
     - For request facts and categories
5. [Realm](https://github.com/realm)
     - For save categories and search history
6. [AlamofireObjectMapper](https://github.com/tristanhimmelman/AlamofireObjectMapper)
     - For map jsons to objects inside the app
7. [SwiftLint](https://github.com/realm/SwiftLint)
     - To be sure the code is following the best practices
8. Some other to support these

## Methods
1. Trying to use MVVM in Swift, but still learning.
2. Use Network and Database connection as Singletons, so I can access them anywhere in the app.
3. Custom alerts inside UIViewController extension, so I can use it inside any UIViewController.
4. Injecting ViewModel through prepare for segue function, as it is only one needed.
5. Used native XCTest so I can learn the basic of testing.
