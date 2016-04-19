//
//  XHTaoLunViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPullRefreshTableViewController.h"
#import "UIButton+WebCache.h"
//@interface XHTaoLunViewController : XHPullRefreshTableViewController

@interface XHTaoLunViewController : XHBaseTableViewController
- (void)replayCommentAxtion:(NSString *)disId;
- (instancetype)initWithWID:(int)wid;
@property(nonatomic, assign)int wid;
@end
