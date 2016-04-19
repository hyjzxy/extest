//
//  NSObject+Cate.m
//  HuaYue
//
//  Created by 崔俊红 on 15/5/1.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "NSObject+Cate.h"
#import <objc/runtime.h>

static const char *C_INFO = "C_INFO";
@implementation NSObject (Cate)
@dynamic info;
- (NSDictionary*)info
{
    return objc_getAssociatedObject(self, C_INFO);
}

- (void)setInfo:(NSDictionary *)newInfo
{
    objc_setAssociatedObject(self, C_INFO, newInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
