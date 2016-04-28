//
//  RetweetButton.m
//  TweetPeek
//
//  Created by Jeschke, Mark on 1/14/16.
//  Copyright © 2016 Jeschke, Mark. All rights reserved.
//

#import "RetweetButton.h"

@implementation RetweetButton

- (void)drawRect:(CGRect)rect {
    
    // I used PaintCode 2 to convert my Illustrator vector artwork to CoreGraphics code, which is pasted here to display the Retweet button icon. By using PaintCode, I'm keeping the icon resolution independent for all flavors of iOS devices. This also cuts down on the use of multiple icon bitmap (rasterized) artwork graphics to maintain and import.
    
    //// Color Declarations
    UIColor* fillColor2 = [UIColor colorWithRed: 0.188 green: 0.627 blue: 1 alpha: 1];
    
    //// icon
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(48.9, 10.33)];
        [bezierPath addCurveToPoint: CGPointMake(48.12, 9.85) controlPoint1: CGPointMake(48.75, 10.04) controlPoint2: CGPointMake(48.45, 9.85)];
        [bezierPath addLineToPoint: CGPointMake(46.06, 9.85)];
        [bezierPath addLineToPoint: CGPointMake(46.06, 5.17)];
        [bezierPath addCurveToPoint: CGPointMake(44.88, 4) controlPoint1: CGPointMake(46.06, 4.52) controlPoint2: CGPointMake(45.53, 4)];
        [bezierPath addLineToPoint: CGPointMake(38.12, 4)];
        [bezierPath addCurveToPoint: CGPointMake(36.94, 5.17) controlPoint1: CGPointMake(37.47, 4) controlPoint2: CGPointMake(36.94, 4.52)];
        [bezierPath addCurveToPoint: CGPointMake(38.12, 6.34) controlPoint1: CGPointMake(36.94, 5.82) controlPoint2: CGPointMake(37.47, 6.34)];
        [bezierPath addLineToPoint: CGPointMake(43.41, 6.34)];
        [bezierPath addCurveToPoint: CGPointMake(43.71, 6.63) controlPoint1: CGPointMake(43.57, 6.34) controlPoint2: CGPointMake(43.7, 6.47)];
        [bezierPath addLineToPoint: CGPointMake(43.71, 9.85)];
        [bezierPath addLineToPoint: CGPointMake(41.65, 9.85)];
        [bezierPath addCurveToPoint: CGPointMake(40.86, 10.33) controlPoint1: CGPointMake(41.31, 9.85) controlPoint2: CGPointMake(41.01, 10.04)];
        [bezierPath addCurveToPoint: CGPointMake(40.94, 11.25) controlPoint1: CGPointMake(40.71, 10.63) controlPoint2: CGPointMake(40.74, 10.98)];
        [bezierPath addLineToPoint: CGPointMake(44.17, 15.64)];
        [bezierPath addCurveToPoint: CGPointMake(44.88, 16) controlPoint1: CGPointMake(44.34, 15.87) controlPoint2: CGPointMake(44.6, 16)];
        [bezierPath addCurveToPoint: CGPointMake(45.59, 15.64) controlPoint1: CGPointMake(45.16, 16) controlPoint2: CGPointMake(45.43, 15.87)];
        [bezierPath addLineToPoint: CGPointMake(48.83, 11.25)];
        [bezierPath addCurveToPoint: CGPointMake(48.9, 10.33) controlPoint1: CGPointMake(49.03, 10.98) controlPoint2: CGPointMake(49.05, 10.63)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezierPath fill];
        
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(39.88, 13.66)];
        [bezier2Path addLineToPoint: CGPointMake(34.59, 13.66)];
        [bezier2Path addCurveToPoint: CGPointMake(34.3, 13.38) controlPoint1: CGPointMake(34.43, 13.66) controlPoint2: CGPointMake(34.3, 13.53)];
        [bezier2Path addLineToPoint: CGPointMake(34.29, 10.15)];
        [bezier2Path addLineToPoint: CGPointMake(36.35, 10.15)];
        [bezier2Path addCurveToPoint: CGPointMake(37.14, 9.67) controlPoint1: CGPointMake(36.69, 10.15) controlPoint2: CGPointMake(36.99, 9.96)];
        [bezier2Path addCurveToPoint: CGPointMake(37.06, 8.75) controlPoint1: CGPointMake(37.29, 9.37) controlPoint2: CGPointMake(37.26, 9.02)];
        [bezier2Path addLineToPoint: CGPointMake(33.83, 4.36)];
        [bezier2Path addCurveToPoint: CGPointMake(33.12, 4) controlPoint1: CGPointMake(33.66, 4.13) controlPoint2: CGPointMake(33.4, 4)];
        [bezier2Path addCurveToPoint: CGPointMake(32.41, 4.36) controlPoint1: CGPointMake(32.84, 4) controlPoint2: CGPointMake(32.57, 4.13)];
        [bezier2Path addLineToPoint: CGPointMake(29.17, 8.75)];
        [bezier2Path addCurveToPoint: CGPointMake(29.1, 9.67) controlPoint1: CGPointMake(28.97, 9.02) controlPoint2: CGPointMake(28.94, 9.37)];
        [bezier2Path addCurveToPoint: CGPointMake(29.88, 10.15) controlPoint1: CGPointMake(29.25, 9.96) controlPoint2: CGPointMake(29.55, 10.15)];
        [bezier2Path addLineToPoint: CGPointMake(31.94, 10.15)];
        [bezier2Path addLineToPoint: CGPointMake(31.94, 14.83)];
        [bezier2Path addCurveToPoint: CGPointMake(33.12, 16) controlPoint1: CGPointMake(31.95, 15.48) controlPoint2: CGPointMake(32.47, 16)];
        [bezier2Path addLineToPoint: CGPointMake(39.88, 16)];
        [bezier2Path addCurveToPoint: CGPointMake(41.06, 14.83) controlPoint1: CGPointMake(40.53, 16) controlPoint2: CGPointMake(41.06, 15.48)];
        [bezier2Path addCurveToPoint: CGPointMake(39.88, 13.66) controlPoint1: CGPointMake(41.06, 14.18) controlPoint2: CGPointMake(40.53, 13.66)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [fillColor2 setFill];
        [bezier2Path fill];
    }
}

@end
