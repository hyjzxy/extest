//
//  HYBaseView.m
//  HuaYue
//
//  Created by 崔俊红 on 15-3-29.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "HYBaseView.h"

@implementation HYBaseView

- (void)mAddSubViews:(NSArray *)views
{
    for (UIView* view in views) {
        [self addSubview:view];
    }
}

@end
