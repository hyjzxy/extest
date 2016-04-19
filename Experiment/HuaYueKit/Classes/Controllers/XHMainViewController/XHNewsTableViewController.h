//
//  XHNewsTableViewController.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseTableViewController.h"

@protocol loginBtnGotoLoginDelegate <NSObject>

@optional

- (void)gotoLogin;

@end

@interface XHNewsTableViewController : XHBaseTableViewController

@property (nonatomic,retain)NSDictionary *dic;
@property (nonatomic,strong)NSString     *strQID;//问题id
@property (nonatomic, weak)id<loginBtnGotoLoginDelegate>gotoLoginDelegate;
- (void)replayCommentAxtion:(NSString *)disId;

- (void)clickCamr;
- (void)clickAlt;
@end
