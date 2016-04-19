//
//  MZApp.m
//  HuaYue
//
//  Created by 崔俊红 on 15/7/6.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZApp.h"

@implementation MZApp
+ (instancetype)share
{
    static MZApp *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[MZApp alloc]init];
        shareInstance.deivceToken = @"";
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *token = [ud stringForKey:@"DTOKEN"];
        if (token) {
            shareInstance.deivceToken = token;
        }
    });
    return shareInstance;
}
@end
