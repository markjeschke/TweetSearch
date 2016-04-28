//
//  Utils.m
//  TweetSearch
//
//  Created by Valentin Filip on 4/24/13.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (NSString*)getTimeAsString:(NSDate *)lastDate {
    NSTimeInterval dateDiff =  [[NSDate date] timeIntervalSinceDate:lastDate];
    
    int nrSeconds = dateDiff;//components.second;
    int nrMinutes = nrSeconds / 60;
    int nrHours = nrSeconds / 3600;
    int nrDays = dateDiff / 86400; //components.day;
    
    NSString *time;
    if (nrDays > 5){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        [dateFormat setTimeStyle:NSDateFormatterNoStyle];
        
        time = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:lastDate]];
    } else {
        // days=1-5
        if (nrDays > 0) {
            if (nrDays == 1) {
                time = @"1d";
            } else {
                time = [NSString stringWithFormat:@"%dd", nrDays];
            }
        } else {
            if (nrHours == 0) {
                if (nrMinutes < 1) {
                    if (nrSeconds < 60) {
                        time = [NSString stringWithFormat:@"%ds", nrSeconds];
                    }
                } else {
                    time = [NSString stringWithFormat:@"%dm", nrMinutes];
                }
            } else { // days=0 hours!=0
                if (nrHours == 1) {
                    time = @"1h";
                } else {
                    time = [NSString stringWithFormat:@"%dh", nrHours];
                }
            }
        }
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"%@", @"label"), time];
}

@end
