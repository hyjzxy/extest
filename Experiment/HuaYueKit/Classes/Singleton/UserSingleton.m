//
//  UserSingleton.m
//  Les
//
//  Created by 朱亮亮 on 14-11-4.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UserSingleton.h"
#import "UIAlertView+Common.h"

@implementation UserSingleton

+ (WYUserModel *) userDefault
{
    static WYUserModel * user = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!user) {
            user = [[WYUserModel alloc] init];
        }
        
    });
    
    return user;
}

- (void)dealloc
{
    [UIAlertView alertWithTitle:@"提示" message:@"userDefault被释放" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
}

@end
