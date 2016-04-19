//
//  XHDemoTableViewController.h
//  XHRefreshControlExample
//
//  Created by 曾 宪华 on 14-6-8.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHPullRefreshTableViewController.h"

typedef NS_ENUM(NSInteger, ChatType) {
    ChatType_Ask = 0,
    ChatType_Answer = 1
};

//@interface XHDemoTableViewController : XHPullRefreshTableViewController
@interface XHDemoTableViewController : XHBaseTableViewController

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) ChatType mChatType;

@property (nonatomic, assign) BOOL inputHide;

@property (nonatomic, copy) NSString *aid;

- (instancetype)initWithQid:(NSDictionary *)dic;

@end
