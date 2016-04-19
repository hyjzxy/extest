//
//  UIScrollView+Theme.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/19.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "UIScrollView+Theme.h"

@implementation UIScrollView (Theme)
- (void)setInputKey:(id)m
{
    if ([self respondsToSelector:@selector(setKeyboardDismissMode:)]) {
        [self setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
}
@end
