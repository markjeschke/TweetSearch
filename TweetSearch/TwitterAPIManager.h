//
//  TwitterAPIManager.h
//  TweetSearch
//
//  Created by Jeschke, Mark on 4/24/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "NSString+URLEncoding.h"

// This Twitter API integration was referenced and inspired by Use Your Loaf's iOS blog:
// http://useyourloaf.com/blog/migrating-to-the-new-twitter-search-api.html

@interface TwitterAPIManager : NSObject

// Twitter API connection states.
typedef NS_ENUM(NSUInteger, UYLTwitterSearchState)
{
    UYLTwitterSearchStateLoading,
    UYLTwitterSearchStateNotFound,
    UYLTwitterSearchStateRefused,
    UYLTwitterSearchStateFailed
};

@property NSString *query;
@property NSMutableData *buffer;
@property NSURLConnection *connection;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,assign) UYLTwitterSearchState searchState;

// Store the Twitter results data in an array.

@property (nonatomic, strong) NSMutableArray *resultsDataArray;

- (NSString *)searchMessageForState:(UYLTwitterSearchState)state;

// Send the query to the Twitter API and load the results.

- (void)loadQuery:(int)tweetCount;

@end
