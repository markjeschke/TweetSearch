//
//  AppDelegate.m
//  TweetSearch
//
//  Created by Jeschke, Mark on 4/24/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    // Load NSUserDefaults from a local plist file. The default query string is @starwars.
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    
    
    // Customize the appearance of the UIStatusBarStyle.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Customize the appearance of the UINavigationBar. Set the UINavigationBar to black.
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    // Set the UINavigationBar's text and icon colors:
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:252.0/255.0 green:243.0/255.0 blue:27.0/255.0 alpha:1.0]];
    
    // Set the UINavigationBar's font family and size.
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:252.0/255.0 green:243.0/255.0 blue:27.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"Raleway-Light" size:24.0], NSFontAttributeName, nil]];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"Raleway-Regular" size:14.0f],NSFontAttributeName,
                                                          nil] forState:UIControlStateNormal];
    
    // Set the UITableViewCell's UIButton
    
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:48.0/255.0 green:160.0/255.0 blue:255.0/255.0 alpha:1.0]];

    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [_tweetTableViewController refreshTableView];
}

@end
