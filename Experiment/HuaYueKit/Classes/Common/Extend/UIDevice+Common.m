//
//  UIDevice+Common.m
//  Les
//
//  Created by 朱 亮亮 on 14-9-5.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UIDevice+Common.h"

@implementation UIDevice (Common)

+ (float)currentIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
