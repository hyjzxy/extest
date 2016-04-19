//
//  XHUserDefaultObject.h
//  HuaYue
//
//  Created by Appolls on 14-12-15.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUAYUE @"huayue"
#define XH_LOGIN_SUCCESS @"登录成功"
#define USERLGN [NSString stringWithFormat:@"%@_lgn",HUAYUE]
#define USERPWD [NSString stringWithFormat:@"%@_pwd",HUAYUE]
#define USERNAME [NSString stringWithFormat:@"%@_username",HUAYUE]
#define USERHEAD [NSString stringWithFormat:@"%@_head",HUAYUE]
#define SEX [NSString stringWithFormat:@"%@_sex",HUAYUE]
#define UID [NSString stringWithFormat:@"%@_uid",HUAYUE]
#define INVITATION [NSString stringWithFormat:@"%@_invitation",HUAYUE]
#define REALNAME_STASUS [NSString stringWithFormat:@"%@_realname_status",HUAYUE]
#define CAMPNAME [NSString stringWithFormat:@"%@_company",HUAYUE]

#define AUTH @"AUTH"
#define INTEGRAL [NSString stringWithFormat:@"%@integral",HUAYUE]

@interface XHUserDefaultObject : NSObject


+ (XHUserDefaultObject *)sharedManager;
-(NSString *)objectForUserDefault:(NSString *)value;


@end
