//
//  TwitterAPIManager.m
//  TweetSearch
//
//  Created by Jeschke, Mark on 4/24/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import "TwitterAPIManager.h"

@interface TwitterAPIManager ()

@end

@implementation TwitterAPIManager

#pragma mark -
#pragma mark === Account Status ===
#pragma mark -

// Check the Account store. If it's nil, then create an object and initialize it.

- (ACAccountStore *)accountStore
{
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

#pragma mark -
#pragma mark === Twitter State ===
#pragma mark -

- (NSString *)searchMessageForState:(UYLTwitterSearchState)state
{
    switch (state)
    {
        case UYLTwitterSearchStateLoading:
            return @"Loading...";
            break;
        case UYLTwitterSearchStateNotFound:
            return @"No results found";
            break;
        case UYLTwitterSearchStateRefused:
            return @"Twitter Access Refused";
            break;
        default:
            return @"Not Available";
            break;
    }
}

#pragma mark -
#pragma mark === Load the Twitter Search Query ===
#pragma mark -

- (void)loadQuery:(int)tweetCount
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _query = [defaults stringForKey:@"query"];

    self.searchState = UYLTwitterSearchStateLoading;
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error) {
         if (granted) {
             // The search query is URL encoded, in the event that the query contains characters such as # and @.
             NSString *encodedQuery = [_query stringByAddingPercentEncodingForFormData:NO];
             NSString *requestToAPI = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@&count=%d", encodedQuery, tweetCount];
             NSURL *url = [NSURL URLWithString:requestToAPI];
             SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:url
                                                          parameters:nil];
             
             NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
             slRequest.account = [accounts lastObject];
             NSURLRequest *request = [slRequest preparedURLRequest];
             
             // Establish connection on the main thread.
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
             });
         } else {
             self.searchState = UYLTwitterSearchStateRefused;
         }
     }];
}

#pragma mark -
#pragma mark === NSURL Connection Status ===
#pragma mark -

// The connection methods kind of act like a low-level Reachability.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.connection = nil;
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    
    if ([_resultsDataArray count] == 0)
    {
        NSArray *errors = jsonResults[@"errors"];
        if ([errors count]) {
            self.searchState = UYLTwitterSearchStateFailed;
        } else {
            self.searchState = UYLTwitterSearchStateNotFound;
        }
    }
    
    _resultsDataArray = jsonResults[@"statuses"];

    _buffer = nil;
    
    // Send notification to the TweetTableViewController that the NSURLConnection has finished loading.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"query_loaded"
                                                        object:self
                                                      userInfo:nil];
}

@end
