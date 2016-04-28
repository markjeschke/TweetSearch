//
//  TweetCell.h
//  TweetPeek
//
//  Created by Jeschke, Mark on 1/13/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface TweetCell : UITableViewCell <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetMessage;
@property (weak, nonatomic) IBOutlet UILabel *twitterName;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetMessageButton;
@property (weak, nonatomic) IBOutlet UIImageView *postedImage;


@end
