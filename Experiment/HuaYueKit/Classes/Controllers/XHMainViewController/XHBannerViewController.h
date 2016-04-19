//
//  XHBannerViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-12.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseViewController.h"

@interface XHBannerViewController : XHBaseViewController
@property(nonatomic, assign)int wID;
@property(nonatomic, assign)int type;
@property (nonatomic,strong) NSString   *catId;

- (instancetype)initWithWID:(int)wID title:(NSString *)title withType:(int)type;
- (void)initShareSdk;
@end
