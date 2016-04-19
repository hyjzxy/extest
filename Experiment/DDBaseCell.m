//
//  DDBaseCell.m
//  DDMessage
//
//  Created by HuiPeng Huang on 13-12-26.
//  Copyright (c) 2013年 HuiPeng Huang. All rights reserved.
//

#import "DDBaseCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DDContentView

- (void)drawRect:(CGRect)rect {
    
    DDBaseCell *cell;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0f && version < 8.0f) {
        cell = (DDBaseCell *)[[self superview] superview];
    }else {
        cell = (DDBaseCell *)[self superview];
    }
    [cell drawContentView:rect];
    
}

@end

@interface DDBaseCell ()

@end

@implementation DDBaseCell

- (void)dealloc
{
    self.customView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.customView = [[DDContentView alloc] init];
        self.customView.opaque = YES;
        [self addSubview:self.customView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    self.customView.frame = [self bounds];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.customView setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
