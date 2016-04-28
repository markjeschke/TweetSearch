//
//  AppDelegate.h
//  TweetSearch
//
//  Created by Jeschke, Mark on 4/24/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TweetTableViewController *tweetTableViewController;

@end

