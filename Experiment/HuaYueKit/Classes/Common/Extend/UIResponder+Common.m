//
//  UIResponder+Common.m
//  VMDai
//
//  Created by 朱亮亮 on 14-11-24.
//  Copyright (c) 2014年 Monica Yan. All rights reserved.
//

#import "UIResponder+Common.h"

@implementation UIResponder (Common)

- (void)routerEventWithName:(NSString *)eventName object:(id)object
{
    [[self nextResponder] routerEventWithName:eventName object:object];
}

@end
