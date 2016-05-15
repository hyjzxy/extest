//
//  AppDelegate.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "AppDelegate.h"
#import "ProgressHUD.h"

#import "XHMessageRootViewController.h"
#import "XHContactTableViewController.h"
#import "XHDiscoverTableViewController.h"
#import "XHProfileTableViewController.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "NewfeatureController.h"

#import "xiangqingye.h"
#import "XHKJIFenViewController.h"
#import "UIAlertView+Block.h"
#import "AttentionViewController.h"
#import "XHZhuShouIDViewController.h"
#import "MZAnswerListVC.h"
#import "MZAnswerChatVC.h"
#import "XHPaiHangBanViewController.h"
#import "HYHelper.h"
#import "UIButton+Theme.h"
#import "UITableViewCell+Theme.h"
#import "UIScrollView+Theme.h"
#import "LNNotificationsUI.h"
#import "NSObject+Cate.h"
#import "XHMyNewsViewController.h"
#import "XHShiYanViewController.h"
#import "XHLawViewController.h"
#import "XHNyActiviyViewController.h"
#import "XHPeiXunViewController.h"
#import "XHBrandCuViewController.h"
#import "systemViewController.h"
#import "XHFansHelpViewController.h"
#import "MZApp.h"
#import "GexinSdk.h"

#define kAppId          @"nZWe1sNnGq6vzrK5NLCIW6"
#define kAppKey         @"yf0m3vgB9L8UJ8cg9Kmw93"
#define kAppSecret      @"zSfbrCpFXv9xvCDfXjajn9" //@"l4PWbRdeXc6FMun0VArnQ6"
#define __SDK_Version__                 [[[UIDevice currentDevice] systemVersion] doubleValue]


static int RTIME = 15;

@interface AppDelegate ()
@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (void)registerRemoteNotification
{
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}

- (NSString *)currentLogFilePath
{
    NSMutableArray * listing = [NSMutableArray array];
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray * fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docsDirectory error:nil];
    if (!fileNames) {
        return nil;
    }
    
    for (NSString * file in fileNames) {
        if (![file hasPrefix:@"_log_"]) {
            continue;
        }
        
        NSString * absPath = [docsDirectory stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:absPath isDirectory:&isDir]) {
            if (isDir) {
                [listing addObject:absPath];
            } else {
                [listing addObject:absPath];
            }
        }
    }
    
    [listing sortUsingComparator:^(NSString *l, NSString *r) {
        return [l compare:r];
    }];
    
    if (listing.count) {
        return [listing objectAtIndex:listing.count - 1];
    }
    
    return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    UIImage *image = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0) forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
     [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"NIL"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"chat-nav"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [UIImage imageNamed:@"NIL"];
    // 字体着色
    [[UINavigationBar appearance]setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:SYSTEMFONT(16)}];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:SYSTEMFONT(15)} forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UIScrollView appearance]setInputKey:nil];
    
    [[UITableViewCell appearance]touchTheme:nil];
    
    [MobClick startWithAppkey:@"54b9aefefd98c5f227000907" reportPolicy:BATCH channelId:nil];
    
    [UMSocialData setAppKey:@"54b9aefefd98c5f227000907"];
    [UMSocialData openLog:YES];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    [UMSocialWechatHandler setWXAppId:@"wxaea6f7ec5263cd4e" appSecret:@"54b9aefefd98c5f227000907" url:@"http://www.baidu.com"];
    [UMSocialQQHandler setQQWithAppId:@"1105023611" appKey:@"54b9aefefd98c5f227000907" url:@"http://www.umeng.com/social"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick endEvent:@"startApp"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    _tabbarView = [[DailyBoothViewController alloc] initWithNibName:nil bundle:nil];
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, RTIME * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [_tabbarView resetNotice];
    });
    dispatch_resume(_timer);
    _tabbarView.delegate = self;
    navigationController = [[XHBaseNavigationController alloc] initWithRootViewController:_tabbarView];
    navigationController.delegate = self;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"Guided"]) {
        NewfeatureController *guideCtrler = [[NewfeatureController alloc]initWithNibName:nil bundle:nil];
        guideCtrler.navigationController = navigationController;
        [self.window setRootViewController:guideCtrler];
    }else{
        [self.window setRootViewController:navigationController];
    }
    [self.window makeKeyAndVisible];
    // [2]:注册APNS
    [self registerRemoteNotification];

 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationWasTapped:) name:LNNotificationWasTappedNotification object:nil];
    [[LNNotificationCenter defaultCenter] registerApplicationWithIdentifier:@"SYZS" name:@"实验助手" icon:[UIImage imageNamed:@"logotip"]];
    NSDictionary *dic = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (dic) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        mdic[@"content"] = dic[@"payload"];
        mdic[@"notifycontent"] = dic[@"aps"][@"alert"][@"body"];
        mdic[@"notifytitle"] = dic[@"aps"][@"alert"][@"action-loc-key"];
        [self apnsPushViewWithContent:mdic isSysnoti:YES];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

- (void)notificationWasTapped:(NSNotification*)notification
{
    LNNotification* tappedNotification = notification.object;
    mz_block_t block = tappedNotification.userInfo;
    if (block) {
        block(nil);
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;

//    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if([viewController isKindOfClass:[XHMessageRootViewController class]]){
        return YES;
    }else if ([viewController isKindOfClass:[XHContactTableViewController class]]){
       return YES;
    }else if ([viewController isKindOfClass:[XHDiscoverTableViewController class]]){
        return YES;
    }else if ([viewController isKindOfClass:[XHProfileTableViewController class]]){
       return YES;
    }else{
        if ([tabBarController respondsToSelector:@selector(openTIWenView)])
            [tabBarController performSelector:@selector(openTIWenView) withObject:nil];
        return NO;
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if([viewController isKindOfClass:[XHMessageRootViewController class]]){
        ((XHMessageRootViewController *)viewController).tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
        ((XHMessageRootViewController *)viewController).topTableView.alpha = 0;
        
    }else if ([viewController isKindOfClass:[XHContactTableViewController class]]){
    
        viewController.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
    }else if ([viewController isKindOfClass:[XHDiscoverTableViewController class]]){
        viewController.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
        viewController.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
    }else if ([viewController isKindOfClass:[XHProfileTableViewController class]]){
        if(![HYHelper mLoginID:nil]){
            viewController.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
            
            viewController.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        }
    }
}

/**
 *  @author 麦子, 15-05-28 14:05:58
 * @{@"content":{@"type":@"giveintegral",@"notifycontent":@"你好"}}
 *  @brief  处理消息推送
 *  @param type   类型
 *  @param pushId id
 *  af8e523e6e5e72ef1e107163f262d0f45c1d209deaf6020a4ed985f6f001c4d5
 *  @since v1.0
 */
- (void)apnsPushViewWithContent:(NSDictionary*)content isSysnoti:(BOOL)_SYSNOTI
{   //{"notifytitle":"我的测试","notifycontent":"日报信息，现在找开","content":"{\"type\":\"daily\",\"id\":\"71\",\"enter\":\"1\"}"}
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[content[@"content"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSString *type = dic[@"type"];
    NSString *msg = content[@"notifycontent"];
    NSString *title = content[@"notifytitle"];
    if ([type isEqualToString:@"daily"]
        || [type isEqualToString:@"weekly"]
        || [type isEqualToString:@"documents"]
        || [type isEqualToString:@"party"]
        || [type isEqualToString:@"train"]
        || [type isEqualToString:@"brands"]) {
        NSInteger enter = [dic[@"enter"]integerValue];
        mz_block_t block = nil;
        if (enter == 1) {
            block = ^(id m){
                [navigationController pushViewController:[[xiangqingye alloc] initWithWID:[dic[@"id"] intValue] title:title] animated:YES];
            };
        } else if(enter == 2){
            block = ^(id m){
                if ([type isEqualToString:@"daily"]) {
                    [navigationController pushViewController:[XHMyNewsViewController new] animated:YES];
                } else if([type isEqualToString:@"weekly"]) {
                    [navigationController pushViewController:[XHShiYanViewController new] animated:YES];
                } else if([type isEqualToString:@"documents"]){
                    [HYHelper mLoginID:^(id uid) {
                        if (uid) {
                            [navigationController pushViewController:[XHLawViewController new] animated:YES];
                        } else {
                            return [BMUtils showError:@"法规文献有新消息,请先登录"];
                        }
                    }];
                }else if([type isEqualToString:@"party"]) {
                    [navigationController pushViewController:[XHNyActiviyViewController new] animated:YES];
                } else if([type isEqualToString:@"train"]) {
                    [navigationController pushViewController:[XHPeiXunViewController new] animated:YES];
                } else if([type isEqualToString:@"brands"]) {
                    [navigationController pushViewController:[XHBrandCuViewController new] animated:YES];
                }
            };
        }
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"product"]) {
        //7、积分商城
        mz_block_t block = ^(id m){
            XHKJIFenViewController *control = [[XHKJIFenViewController alloc] init];
            [navigationController pushViewController:control animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo =block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"ph"]) {
        mz_block_t block = ^(id m){
            XHPaiHangBanViewController *vc = [[XHPaiHangBanViewController alloc] init];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo =block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"realname"]) {
        //9、实名认证
        mz_block_t block = ^(id m){
            XHKJIFenViewController *control = [[XHKJIFenViewController alloc] init];
            [navigationController pushViewController:control animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo =block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    }else if([type isEqualToString:@"exchange"]||[type isEqualToString:@"report"]||[type isEqualToString:@"reported"]) {//11、举报
        mz_block_t block = ^(id m){
            systemViewController *control = [[systemViewController alloc] init];
            [navigationController pushViewController:control animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo =block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }

    } else if ([type isEqualToString:@"giveintegral"]
               || [type isEqualToString:@"market"]) {
        //10、赠送积分通知
        //12、积分商城
        if(!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }
    } else if([type isEqualToString:@"fanshelp"]){
        mz_block_t block = ^(id m){
            XHFansHelpViewController *vc = [[XHFansHelpViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"addanswer"]) {
        // 13、我提问有新回答  14、我的提问 的回答有新互动 16、我的回答 有新互动 OK
        mz_block_t block = ^(id m){
            MZAnswerChatVC *vc = [[MZAnswerChatVC alloc]init];
            vc.isAddQuest = NO;
            vc.chatType = kAnswerChat;
            vc.auid = [dic[@"auid"] intValue];
            vc.aid = [dic[@"aid"] intValue];
            vc.qid = [dic[@"qid"] intValue];
            vc.nickName = dic[@"nickname"];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"addanswerafter"]) {
        // 15、我的提问 的回答有新追问 // 17、我的回答 有新追问 OK
        mz_block_t block = ^(id m){
            MZAnswerChatVC *vc = [[MZAnswerChatVC alloc]init];
            vc.isAddQuest = YES;
            vc.chatType = kAddQuestChat;
            vc.auid = [dic[@"auid"] intValue];
            vc.aid = [dic[@"aid"] intValue];
            vc.qid = [dic[@"qid"] intValue];
            vc.nickName = dic[@"nickname"];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"adopted"]||[type isEqualToString:@"adopt"]||[type isEqualToString:@"questionkey"]) {
        // 18、我的回答 被采纳 27、提问后，问题涉及某个关键词
        mz_block_t block = ^(id m){
            MZAnswerListVC *vc = [[MZAnswerListVC alloc]init];
            vc.qid = [dic[@"id"] intValue];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } /*else if ([type isEqualToString:@"fanshelp"]) {
        // 19、我有新的粉丝求助
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }
    } */else if ([type isEqualToString:@"assistantinfo"]) {
        // 20、注册登陆成功后
        mz_block_t block = ^(id m){
            XHZhuShouIDViewController *vc = [[XHZhuShouIDViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"upgrade"]) {
        // 21、用户升级，发送系统消息
        mz_block_t block = ^(id m){
            XHKJIFenViewController *vc = [[XHKJIFenViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    } else if ([type isEqualToString:@"questionadd"]
               || [type isEqualToString:@"attentionlist"]
               || [type isEqualToString:@"registration"]) {
        // 22、用户提问未通过审核通知
        // 23、积分商城，用户兑换学习资料
        // 24、系统消息：若用户的关注对象 ≤ 10人
        // 25、培训信息-我要报名，提交报名信息后
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }
    } else if ([type isEqualToString:@"invitation"]) {
        // 26、某人填写某个助手号注册成功后
        mz_block_t block = ^(id m){
            AttentionViewController *vc = [[AttentionViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
        };
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            notification.userInfo = block;
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }else{
            block(nil);
        }
    }else {
        if (!_SYSNOTI) {
            LNNotification* notification = [LNNotification notificationWithTitle:title message:msg];
            notification.date = [NSDate dateWithTimeIntervalSinceNow:2];
            [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"SYZS"];
        }
    }
}

#pragma mark - Loading

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(willAppearIn:)])
        [viewController performSelector:@selector(willAppearIn:) withObject:navController];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[_tabbarView resetNotice];
    [HYHelper mCheckVersionUpdate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.if
    /*NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"" forKey:UID];
    [userDefault setValue:@"" forKey:HUAYUE_ISLOGIN];
    [userDefault synchronize];*/
}
//9dee9a6e674322988c5c11e6f5c2a57941fefb80dba9194d918faf26a3b653a9
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    [MZApp share].deivceToken = token;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:token forKey:@"DTOKEN"];
    [ud synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [MZApp share].deivceToken = @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"DTOKEN"];
    [ud synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    mdic[@"content"] = userinfo[@"payload"];
    mdic[@"notifycontent"] = userinfo[@"aps"][@"alert"][@"body"];
    mdic[@"notifytitle"] = userinfo[@"aps"][@"alert"][@"action-loc-key"];
    [self apnsPushViewWithContent:mdic isSysnoti:[UIApplication sharedApplication].applicationState != UIApplicationStateActive];
}
@end
