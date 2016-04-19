//
//  XHBaseViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseViewController.h"
#import "ACMacros.h"

@interface XHBaseViewController ()<UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property (nonatomic, copy) XHBarButtonItemActionBlock barbuttonItemAction;
//@property(nonatomic, strong)UIAlertView *alertView;
@end

@implementation XHBaseViewController

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

- (NSString *)getUserId
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if(![userDefault objectForKey:UID]){
        return nil;
    }
    return [NSString stringWithFormat:@"%d", [[userDefault objectForKey:UID] intValue]];
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action {
    switch (style) {
        case XHBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"tab_profile.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"barbuttonicon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"图层-1-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleConfirm: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"提交"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        default:
            
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController {

    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Loading

- (void)showLoading {
    [self showLoadingWithText:nil];
}

- (void)showLoadingWithText:(NSString *)text {
    [self showLoadingWithText:text onView:self.view];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view {
    
}

- (void)showSuccess {
    
}
- (void)showError {
    
}

- (void)hideLoading {
    
}




#pragma mark - Life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        // iOS7顶部屏幕适配
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
#endif
        
        /*
//        // 导航栏左按钮
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 55, 44);
        [leftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 45);
        [leftButton addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButton;*/
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (iOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [super viewWillAppear:animated];
}

#pragma mark - 公有方法
- (void)addSubview:(UIView *)view
{
    [self.view addSubview:view];
}

- (void)addRightNavItem:(UIButton *)button
{
    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)cleanNavigationBar
{
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationItem.rightBarButtonItem = nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

//#pragma mark - 重写方法
//- (void)setRooterTitle:(NSString *)title
//{
//    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController].title = title;
//    self.title = title;
//}

#pragma mark - 点击事件
- (void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - View rotation

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
- (void)startWaiting
{
    if(waitingView) return;
    waitingView = [[WaitingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:waitingView];
//    [waitingView release];
}

- (void)stopWaiting
{
    if(waitingView)
    {
        [waitingView removeFromSuperview];
        waitingView = nil;
    }
}

@end
