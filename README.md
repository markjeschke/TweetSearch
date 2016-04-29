TweetSearch
===========

I created this iOS example by following this excellent [Twitter API integration tutorial](http://useyourloaf.com/blog/migrating-to-the-new-twitter-search-api/) on [Use Your Loaf](http://useyourloaf.com/) by [Keith Harrison](https://github.com/kharrison). I added the following features that weren't in the tutorial:

1. Separated the Twitter API functionality into its own `TwitterAPIManager` class.
2. Search input field within an AlertController pop-up alertView. The default search is `@starwars`
3. Persistent data via NSUserDefaults, so that the app remembers your search even after you close or restart it. The default .plist is specified in the `AppDelegate.m` file.
4. Pull-to-refresh and infinite scroll to load in the next 15 tweets.
5. Screen name, profile pic, and elapsed date stamp of the tweet and its author.
6. Dynamic tableview cell that adjusts its height, based upon the character length of the tweet message.
7. Custom font, size, and colors to the TableView cells.
8. Overall app appearance, set inside of the `AppDelegate.m` file.

## Installation

1. Run `git clone https://github.com/markjeschke/TweetSearch.git` or download the [zip](https://github.com/markjeschke/TweetSearch.git) to your local drive.
2. If you have CocoaPods already installed, simply open the `TweetSearch.xcworkspace` source, and deploy the app to your iPhone or iPad. It unfortunately doesn't access the Twitter data via the iOS simulator. But, that could be a weird bug on my end.

#### If you don't have CocoaPods installed, please follow these directions:

1. Within Terminal, enter `$ sudo gem install cocoapods` in the command line.
2. Change directory, so that it's pointing to the root directory of this "TweetSearch" Xcode project. 
3. Run `pod install` to install the pods that are listed in the Podfile.
4. Once the installation has completed, open the project by clicking to open `TweetSearch.xcworkspace` – not the `TweetSearch.xcodeproj`.

#### Note: If you're having trouble installing CocoaPods, please refer to their [installation instructions](https://cocoapods.org/#install).

This example utilizes the following third-party frameworks via [CocoaPods](https://cocoapods.org/):

* [SDWebImage](https://github.com/rs/SDWebImage) - by [Olivier Poitrey](https://github.com/rs)
* [TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel) - by [Mattt Thompson](https://github.com/mattt)
* [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) - by [Sam Vermette](https://github.com/samvermette) 
* [SVPullToRefresh](https://github.com/samvermette/SVPullToRefresh) - by Pull-to-refresh + infinite Scrolling by [Sam Vermette](https://github.com/samvermette)


