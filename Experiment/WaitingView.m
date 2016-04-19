//
//  WaitingView.m
//  iShip
//
//  Created by huangqingqing on 14-6-18.
//  Copyright (c) 2014年 huangqingqing. All rights reserved.
//

#import "WaitingView.h"

@implementation WaitingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - 40.0f,CGRectGetMidY(self.bounds) - 40.0f, 80.0f, 80.0f)];
        overlay.layer.cornerRadius = 8.0f;
        overlay.backgroundColor = [UIColor blackColor];
        [self addSubview:overlay];
        
        aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        aiv.center = CGPointMake(CGRectGetMidX(overlay.bounds), CGRectGetMidY(overlay.bounds));
        [overlay addSubview:aiv];
        
        [aiv startAnimating];
    }
    
    return self;
}

- (void)willRemoveSubview:(UIView *)subview
{
    [aiv stopAnimating];
    [self removeFromSuperview];
}

@end
