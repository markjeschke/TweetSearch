//
//  TweetCell.m
//  TweetPeek
//
//  Created by Jeschke, Mark on 1/13/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    _twitterName.textColor = [UIColor colorWithRed:20/255.0f green:20/255.0f blue:20/255.0f alpha:1.0f];
    _twitterName.font = [UIFont fontWithName:@"Raleway-Bold" size:14.0];
    
    _screenName.textColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
    _screenName.font = [UIFont fontWithName:@"Raleway-Regular" size:14.0];
    _tweetMessage.textColor = [UIColor colorWithRed:30/255.0f green:55/255.0f blue:62/255.0f alpha:1.0f];
    
    _dateLabel.textColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0f];
    _dateLabel.font = [UIFont fontWithName:@"Raleway-Regular" size:14.0];
}

@end
