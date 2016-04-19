//
//  AppDelegate.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "XHBaseNavigationController.h"
#import "DailyBoothViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) XHBaseNavigationController *navigationController;

@property (nonatomic, strong) DailyBoothViewController *tabbarView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *appSecret;
@property (strong, nonatomic) NSString *appID;

@end
