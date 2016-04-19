//
//  DailyBoothViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "DailyBoothViewController.h"
#import "XHBaseNavigationController.h"
#import "XHMessageRootViewController.h"
#import "XHContactTableViewController.h"
#import "XHDiscoverTableViewController.h"
#import "XHProfileTableViewController.h"
#import "XHTiWenViewController.h"
#import "MZTabBar.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "HYHelper.h"
#import "UIViewController+Cate.h"
#import "MZApp.h"

@interface DailyBoothViewController ()

@property(nonatomic, strong) NSString    *urlOpen;

@end

@implementation DailyBoothViewController
{
    UINavigationController *nc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    XHProfileTableViewController *loginVC = [[XHProfileTableViewController alloc] init];
    loginVC.otherDimiss = YES;
    nc = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginVC.title = @"登录";
    [[self tabBar] setShadowImage:[UIImage imageNamed:@"tabbarBackground.png"]];
    [[self tabBar] setBackgroundImage:[UIImage imageNamed:@"tabbarBackground.png"]];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab-bg"]];
    img.frame = CGRectMake(0, -10, self.tabBar.frame.size.width, self.tabBar.frame.size.height+10);
    img.contentMode = UIViewContentModeScaleToFill;
    [[self tabBar] insertSubview:img atIndex:0];
    UITabBar *tab = [self tabBar];
    if(iOS7){
        tab.tintColor = RGBCOLOR(15, 190, 227);
        tab.barTintColor = RGBCOLOR(15, 190, 227);
    }else{
        tab.tintColor = RGBCOLOR(15, 190, 227);
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont systemFontOfSize:12],NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       RGBCOLOR(15, 190, 227), NSForegroundColorAttributeName,
                                                       [UIFont systemFontOfSize:12],NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    [self setupViewControllers];
    
    //发现消息提醒灯
    self.findCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 2, 10, 10)];
    self.findCountLabel.layer.masksToBounds  = YES;
    self.findCountLabel.layer.cornerRadius   = 5;
    self.findCountLabel.layer.borderWidth    = 1;
    self.findCountLabel.layer.borderColor    = [UIColor clearColor].CGColor;
    self.findCountLabel.font                 = [UIFont systemFontOfSize:10];
    self.findCountLabel.textColor            = [UIColor clearColor];
    self.findCountLabel.backgroundColor      = [UIColor redColor];
    self.findCountLabel.textAlignment        = NSTextAlignmentCenter;
    self.findCountLabel.hidden = YES;
    [self.tabBar addSubview:self.findCountLabel];
    
    //我的消息提醒灯
    self.meCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(295, 2, 15, 15)];
    self.meCountLabel.layer.masksToBounds  = YES;
    self.meCountLabel.layer.cornerRadius   = 7.5;
    self.meCountLabel.layer.borderWidth    = 1;
    self.meCountLabel.layer.borderColor    = [UIColor clearColor].CGColor;
    self.meCountLabel.font                 = [UIFont systemFontOfSize:10];
    self.meCountLabel.textColor            = [UIColor whiteColor];
    self.meCountLabel.backgroundColor      = [UIColor redColor];
    self.meCountLabel.textAlignment        = NSTextAlignmentCenter;
    self.meCountLabel.hidden = YES;
    [self.tabBar addSubview:self.meCountLabel];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectIndex:) name:@"SelectWenTI" object:nil];
}

- (void)selectIndex:(NSNotification*)noti
{
    [self.navigationController pushViewController:noti.userInfo[@"TargetVC"] animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setupViewControllers {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:@"" forKey:USERNAME];
    [userDefault setValue:@"" forKey:USERHEAD];
    [userDefault setValue:@"" forKey:SEX];
    [userDefault removeObjectForKey:UID];
    [userDefault setBool:NO forKey:AUTH];
    [userDefault synchronize];
    BOOL isAuto = [userDefault boolForKey:@"IsAutoLogin"];
    if ([userDefault boolForKey:@"Remember"] && isAuto) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault stringForKey:USERLGN],[userDefault stringForKey:USERPWD],[MZApp share].deivceToken,nil]
                                                                        forKeys:[MY_LOGIN_PARAM componentsSeparatedByString:@","]];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:MY_LOGIN_API
                                          withType:MY_LOGIN
                                           success:^(id responseObject){
                                               //将登录信息保存本地
                                               [userDefault setValue:[responseObject objectForKey:@"nickname"] forKey:USERNAME];
                                               [userDefault setValue:[responseObject objectForKey:@"head"] forKey:USERHEAD];
                                               [userDefault setValue:[responseObject objectForKey:@"sex"] forKey:SEX];
                                               [userDefault setValue:[responseObject objectForKey:@"id"] forKey:UID];
                                               [userDefault setBool:[responseObject[@"realname_status"]boolValue]forKey:AUTH];
                                               [userDefault setValue:[responseObject objectForKey:@"integral"] forKey:INTEGRAL];
                                               [userDefault setValue:[responseObject objectForKey:@"invitation"] forKey:INVITATION];
                                               [userDefault synchronize];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"wangyu" object:nil userInfo:nil];
                                               [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                                               [MobClick endEvent:@"login"];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
    }

    XHMessageRootViewController *messageRootViewController = [[XHMessageRootViewController alloc] init];
    messageRootViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tab-0-n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-0-l"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [messageRootViewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    [messageRootViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    // contact
    XHContactTableViewController *contactTableViewController = [[XHContactTableViewController alloc] init];
    contactTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"等你答" image:[[UIImage imageNamed:@"tab-1-n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-1-l"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [contactTableViewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    [contactTableViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    UIViewController *view = [[UIViewController alloc] init];
    view.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"提问" image:[[UIImage imageNamed:@"camera_button_take"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"camera_button_take"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [view.tabBarItem setImageInsets:UIEdgeInsetsMake(-7, 0, 7, 0)];
    [view.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    
    // discover
    XHDiscoverTableViewController *discoverTableViewController = [[XHDiscoverTableViewController alloc] init];
    discoverTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[[UIImage imageNamed:@"tab-3-n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"tab-3-l"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [discoverTableViewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    [discoverTableViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    // profile
    XHProfileTableViewController *profileTableViewController = [[XHProfileTableViewController alloc] init];
    profileTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[[UIImage imageNamed:@"tab-4-n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab-4-l"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [profileTableViewController.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    [profileTableViewController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    self.viewControllers = [NSArray arrayWithObjects:messageRootViewController,contactTableViewController,view,discoverTableViewController,profileTableViewController,nil];
    self.selectedIndex = 1;
    // [[[MZTabBar alloc]init]setupWithTabVC:self];
}

-(void)openTIWen:(id)s{
    XHTiWenViewController *tiwen = [[XHTiWenViewController alloc] init];
    XHBaseNavigationController *navigationController = [[XHBaseNavigationController alloc] initWithRootViewController:tiwen];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
}

-(void)openTIWenView{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            [self openTIWen:nil];
        }else{
            [BMUtils showError:@"登录后才能提问"];
        }
    }];
}

- (void)resetNotice
{
    [self checkNotice];
}

//anum回答数，bnum品牌数，dnum日报数，fnum粉丝求助数，gnum关注数，mnum系统消息数，nnum法规文献数，pnum活动中心数，qnum提问数，tnum培训信息数，wnum周刊数，znum追问数

- (void)checkNotice
{
    [HYHelper mLoginID:^(id userId) {
        if (userId) {
            NSMutableDictionary *param = [NSMutableDictionary new];
            [param setObject:userId forKey:@"uid"];
            NSLog(@"%@",param);
            [[NetManager sharedManager] myRequestParam:param withUrl:MY_NUM_API withType:MY_NUM success:^(id responseObject) {
                self.messageNumDict = responseObject;
                 NSLog(@"%@",responseObject);
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    self.aNum = [[responseObject objectForKey:@"anum"] integerValue];
                    //self.bNum += [[responseObject objectForKey:@"bnum"] integerValue];
                    self.dNum = [[responseObject objectForKey:@"dnum"] integerValue];
                    self.fNum = [[responseObject objectForKey:@"fnum"] integerValue];
                    self.gNum = [[responseObject objectForKey:@"gnum"] integerValue];
                    self.mNum = [[responseObject objectForKey:@"mnum"] integerValue];
                    //self.nNum += [[responseObject objectForKey:@"nnum"] integerValue];
                    self.pNum = [[responseObject objectForKey:@"pnum"] integerValue];
                    self.qNum = [[responseObject objectForKey:@"qnum"] integerValue];
                    self.tNum = [[responseObject objectForKey:@"tnum"] integerValue];
                    self.wNum = [[responseObject objectForKey:@"wnum"] integerValue];
                    self.status = [[responseObject objectForKey:@"status"]integerValue];
                    self.afternum = [[responseObject objectForKey:@"afternum"] integerValue];
                    self.chartnum = [[responseObject objectForKey:@"chartnum"] integerValue];
                }
                if (self.status==0 && ![nc isBeingPresented]) {
                    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
                    [UD setBool:NO forKey:@"Remember"];
                    [UD setBool:NO forKey:@"IsAutoLogin"];
                    [UD removeObjectForKey:UID];
                    [UD synchronize];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:^{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"对不起，您的账号已经被停封" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
                    }];
                } else {
                    [self updateSysNoto];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTI"  object:nil];
                }
            } failure:^(id errorString) {
                NSLog(@"%@",errorString);
            }];
        }
    }];
}

-(void)willAppearIn:(UINavigationController *)navigationController
{
//  [self addCenterButtonWithImage:[UIImage imageNamed:@"camera_button_take.png"] highlightImage:[UIImage imageNamed:@"tabBar_cameraButton_ready_matte.png"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"立即更新"]) {
        if (self.urlOpen.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlOpen]];
        }
    }
}

@end
