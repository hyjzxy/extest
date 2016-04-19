//
//  BMGlobalValue.m
//  XinCaiFu
//
//  Created by super man on 14-7-23.
//  Copyright (c) 2014年 bluemobi. All rights reserved.
//

#import "BMGlobalValue.h"

@implementation BMGlobalValue
+ (BMGlobalValue *)sharedClient {
    static BMGlobalValue *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BMGlobalValue alloc] init];
    });
    return _sharedClient;
}
@end
