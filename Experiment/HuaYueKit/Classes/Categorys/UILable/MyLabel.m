//
//  myLabel.m
//  appollsLBS
//
//  Created by Appolls on 14-6-17.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (id)initWithFrame:(CGRect)frame withText:(NSString *)text withPosition:(NSTextAlignment)alignment withFontSize:(CGFloat)size withColor:(UIColor *)color withBackColor:(UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.text = text;
        self.textAlignment = alignment?alignment:NSTextAlignmentLeft;
        self.font = size?[UIFont systemFontOfSize:size]:[UIFont systemFontOfSize:14.0f];
        self.textColor = color?color:[UIColor blackColor];
        self.backgroundColor = backColor?backColor:[UIColor clearColor];
    }
    return self;
}

@end
