//
//  XHKJIFenViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHCollectionViewController.h"

@protocol jifenDelegate <NSObject>

@optional
- (void)jifenClickZhuanjiFen;

@end

@interface XHKJIFenViewController : XHCollectionViewController
@property(assign,nonatomic)int _id;

@property (nonatomic, assign) id<jifenDelegate> delegate;

@end
