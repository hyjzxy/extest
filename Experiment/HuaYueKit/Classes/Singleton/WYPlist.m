//
//  WYPlist.m
//  HuaYue
//
//  Created by Appolls on 15-1-4.
//
//

#import "WYPlist.h"

@implementation WYPlist

+ (NSDictionary *) userDefault
{
    static NSDictionary * user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!user) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WYCodeMsg" ofType:@"plist"];
            user = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
    });
    return user;
}

@end
