//
//  LNNotification+Cate.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/26.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "LNNotification+Cate.h"
#import <objc/runtime.h>

@implementation LNNotification (Cate)

- (void)setUInfo:(id)newUinfo
{
    objc_setAssociatedObject(self, @selector(uInfo), newUinfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)uInfo
{
    return objc_getAssociatedObject(self, @selector(uInfo));
}

@end
