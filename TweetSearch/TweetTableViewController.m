//
//  TweetTableViewController.m
//  TweetSearch
//
//  Created by Jeschke, Mark on 4/24/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import "TweetTableViewController.h"
#import "TwitterAPIManager.h"
#import "TweetCell.h"
#import "Utils.h"
#import "PostedTimestamp.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <dispatch/dispatch.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define PAGING_COUNT 15;

@interface TweetTableViewController () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) TwitterAPIManager *twitterManager;
@property (nonatomic) int tweetCount;
@property (nonatomic, strong) NSString *searchText;

// Initialize the app when it first loads.

@property (nonatomic) BOOL initialize;
@property (nonatomic) BOOL pullToRefresh;
@property (nonatomic) BOOL infiniteScrolling;

// Initialize the Twitter composer when it first loads.
@property (nonatomic) BOOL initialRetweet;

@end

@implementation TweetTableViewController

#pragma mark -
#pragma mark View Did Load
#pragma mark -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _twitterManager = [[TwitterAPIManager alloc] init];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    _initialize = true;
    _pullToRefresh = false;
    _infiniteScrolling = false;
    _initialRetweet = true;
    _tweetCount = PAGING_COUNT;
    _searchText = [_defaults stringForKey:@"query"];
    
    // Styled the refreshControl, which is Apple's built-in "Pull to Refresh."
    self.refreshControl.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.refreshControl.tintColor = [UIColor grayColor];
    
    __weak TweetTableViewController *weakSelf = self;
    
    // Handle the SVPullToRefresh and infinite scrolling by adding paging to the tweetCounts.
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        // Increment the amount of tweets that are in the timeline.
        _tweetCount += PAGING_COUNT;
        NSLog(@"infiniteRefresh");
        [_twitterManager loadQuery:_tweetCount];
    }];
    
    [_twitterManager loadQuery:_tweetCount];
    
    // The title will match the Twitter connection state enumeration in the API manager.
    self.title = [_twitterManager searchMessageForState:_twitterManager.searchState];
    
    // Notification for when the loadQuery function completes its connection in the TwitterAPIManager object.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadQuery:)
                                                 name:@"query_loaded" object:nil];
    
    /*
     
     Please note that the Twitter API will NOT be able to access JSON data results via the iOS simulator.
     The only way to test the data is to run it on an actual iOS hardware device.
     
     */
    
    // The estimatedRowHeight will allow the individual cells to have dynamic heights, based upon the amount of text in the tweet.
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTableView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(newSearchAction)];
}

#pragma mark -
#pragma mark Update App Title
#pragma mark -

- (void) updateAppTitle {
    self.title = [NSString stringWithFormat:@"%@", _searchText];
    [self setNeedsStatusBarAppearanceUpdate];
    [_defaults setObject:_searchText forKey:@"query"];
}

#pragma mark -
#pragma mark Load Query Notification
#pragma mark -

-(void) loadQuery:(NSNotification*)notification {
    
    __weak TweetTableViewController *weakSelf = self;
    
    // Animate the populated TableView down only when it first loads.
    if (_initialize) {
        _initialize = false;
        [self reloadTableView:1.0];
    } else {
        if (_pullToRefresh) {
            _pullToRefresh = false;
            [weakSelf.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else if (_infiniteScrolling) {
            [self reloadTableView:0.5];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        }
    }
    [self updateAppTitle];
}

#pragma mark -
#pragma mark Load Table View Data with Animation
#pragma mark -

- (void) reloadTableView:(NSTimeInterval)timeInterval {
    
    __weak TweetTableViewController *weakSelf = self;
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFromBottom;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.fillMode = kCAFillModeForwards;
    transition.duration = timeInterval;
    transition.subtype = kCATransitionFromBottom;
    [[self.tableView layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
    
    // Flash the tableView scrolling indicators after 1 second when the table loads.
    // This indicates how much content is scrollable.
    [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                     target:self
                                   selector:@selector(flashScrollingIndicators)
                                   userInfo:nil
                                    repeats:NO];
    [weakSelf.tableView reloadData];
}

#pragma mark -
#pragma mark Table View Data Source
#pragma mark -

#pragma mark Number of Sections

// Return the amount of sections in your table.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -
#pragma mark Number of Rows

// Return the amount of cells in your table. This is determined dynamically via the api results array count.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_twitterManager.resultsDataArray count];
}

#pragma mark -
#pragma mark Cell Population


// Display the tweet results in each cell. This is determined by the indexPath.row matching the results array index number.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ResultCellIdentifier = @"ResultCell";
    
    // Insert each result into its own key/value dictionary.
    
    NSDictionary *tweet = [_twitterManager.resultsDataArray objectAtIndex:indexPath.row];
    
    // Insert each username into its own key/value dictionary.
    NSDictionary *userNameDict = [tweet objectForKey:@"user"];
    
    // The TweetCell class is connected to the ResultCellIdentifier TableViewCell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    // Display and stylize the user name text.
    cell.twitterName.text = userNameDict[@"name"];
    
    // Display and stylize the screen name text.
    cell.screenName.text = [NSString stringWithFormat:@"@%@", userNameDict[@"screen_name"]];
    
    // Display and stylize the tweet message text.
    NSString *labelText = tweet[@"text"];
    
    // Add line spacing to the tweet message for greater legibility.
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    cell.tweetMessage.attributedText = attributedString;
    
    NSDate *date = [PostedTimestamp timestamp:[tweet objectForKey:@"created_at"]];

    cell.dateLabel.text = [Utils getTimeAsString:date];
        
        // Eliminate any potential image stuttering when loading the profile images into the background thread.
        // Reference: http://stackoverflow.com/questions/23745874/tableview-scrolling-stutters-after-adding-images-from-remote-url
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            // Using the setImageWithURL to cache the image. Otherwise, it will flicker over the previous indexed image.
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[userNameDict objectForKey:@"profile_image_url_https"]]
                                 placeholderImage:nil];
            
            cell.profileImage.contentMode = UIViewContentModeScaleAspectFit;
        });
    
    return cell;
}

#pragma mark -
#pragma mark Flash Scrolling Indicators

- (void) flashScrollingIndicators {
    [self.tableView flashScrollIndicators];
}

#pragma mark -
#pragma mark Refresh Table View from Button Action
#pragma mark -

- (void) refreshTableView {
    self.title = [_twitterManager searchMessageForState:_twitterManager.searchState];
    _tweetCount = PAGING_COUNT;
    _initialize = true;
    [_twitterManager loadQuery:_tweetCount];
}

#pragma mark -
#pragma mark Alternate Background Colors
#pragma mark -

// Alternate the background color for increased legibility for each tweet entry for improved legibility.

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row & 1) {
        cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
}

#pragma mark -
#pragma mark Refresh Search Results
#pragma mark -

// Refresh the connection and search query when "Pull to Refresh" has been triggered via a swipe down finger gesture.

- (IBAction)refreshSearchResults {
    _pullToRefresh = true;
    [self clearNetworkConnection];
    [_twitterManager loadQuery:_tweetCount];
}

#pragma mark -
#pragma mark Clear Network Connection
#pragma mark -

- (void)clearNetworkConnection {
    if (_twitterManager.connection != nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_twitterManager.connection cancel];
        _twitterManager.connection = nil;
        _twitterManager.buffer = nil;
    }
}

#pragma mark -
#pragma mark For Twitter Retweets with SLCompose View Controller
#pragma mark -

- (IBAction)retweet:(id)sender {
    
    // http://stackoverflow.com/a/1802875
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
    {
        NSDictionary *tweet = [_twitterManager.resultsDataArray objectAtIndex:indexPath.row];
        NSString *text = tweet[@"text"];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@", text]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            /* This HUD displays only the first time SLComposeViewController is called.
             It takes a couple of seconds to appear.
             Without this notification, the app could appear to be broken.
             */
            
            if (_initialRetweet) {
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [self showSuccessWithStatus];
                _initialRetweet = false;
            }
        }
        else
        {
            [self alertErrorMessage:@"It looks like you can't send a tweet right now. :( Please make sure that your device is connected to the internet. Also, be sure to have at least one Twitter account set up."];
        }
    }
    
}

#pragma mark - Alert View

#pragma mark -
#pragma mark Error Message

- (void) alertErrorMessage:(NSString *)errorMessage {
    UIAlertController * alert =   [UIAlertController
                                   alertControllerWithTitle:@"Snap!"
                                   message:errorMessage
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* dismissButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:nil];
    
    [alert addAction:dismissButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark New Search Input Alert
#pragma mark

- (void)newSearchAction  {
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Current Search:"
                                          message:_searchText
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter new search";
         textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
         textField.returnKeyType = UIReturnKeyDone;
         textField.keyboardAppearance = UIKeyboardAppearanceDark;
         [textField becomeFirstResponder];
         textField.clearButtonMode = true;
         textField.autocorrectionType = UITextAutocorrectionTypeNo;
         
         [textField addTarget:self
                       action:@selector(alertTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
         
     }];
    
    UIAlertAction *searchAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Search", @"Search")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *fileNameText = alertController.textFields.firstObject;
                                   _searchText = fileNameText.text;
                                   [_defaults setObject:_searchText forKey:@"query"];
                                   [_defaults synchronize];
                                   _searchText = [_defaults stringForKey:@"query"];
                                   _twitterManager.query = _searchText;
                                   [_twitterManager loadQuery:_tweetCount];
                                   [self updateAppTitle];
                               }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       //NSLog(@"Cancel action");
                                   }];
    
    
    [alertController addAction:searchAction];
    [alertController addAction:cancelAction];
    
    UITextField *fileNameText = alertController.textFields.firstObject;
    searchAction.enabled = fileNameText.text.length > 0;
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// Disable the Search button until the user enters more than 1 character in the textField.

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *fileNameText = alertController.textFields.firstObject;
        UIAlertAction *searchAction = alertController.actions.firstObject;
        fileNameText.clearButtonMode = true;
        searchAction.enabled = fileNameText.text.length > 0;
    }
}

#pragma mark - SVProgressHUD framework

#pragma mark -
#pragma mark SVProgressHUD Notification Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidAppearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDWillDisappearNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidDisappearNotification
                                               object:nil];
}

- (void)handleNotification:(NSNotification *)notification{
    //NSLog(@"Notification received: %@", notification.name);
    //NSLog(@"Status user info key: %@", notification.userInfo[SVProgressHUDStatusUserInfoKey]);
}

#pragma mark - Show Methods

- (void)showSuccessWithStatus {
    [SVProgressHUD showSuccessWithStatus:@"Starting up the tweet composer..."];
}

#pragma mark - Dismiss Methods

- (void)dismiss {
    [SVProgressHUD dismiss];
}

@end
