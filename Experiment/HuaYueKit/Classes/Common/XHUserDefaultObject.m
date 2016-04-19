//
//  XHUserDefaultObject.m
//  HuaYue
//
//  Created by Appolls on 14-12-15.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHUserDefaultObject.h"

@implementation XHUserDefaultObject

+ (XHUserDefaultObject *)sharedManager
{
    static XHUserDefaultObject *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}



-(NSString *)objectForUserDefault:(NSString *)value{
    
    NSUserDefaults *defaultU = [NSUserDefaults standardUserDefaults];
    
    return [defaultU valueForKey:value];
}





@end
