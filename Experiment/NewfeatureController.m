//
//  NewfeatureController.m
//  新浪微博
//
//  Created by apple on 13-10-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "NewfeatureController.h"
#import "UIImage+MJ.h"
#import "DailyBoothViewController.h"
#import "XHMessageRootViewController.h"
#import "XHContactTableViewController.h"
#import "XHDiscoverTableViewController.h"
#import "XHProfileTableViewController.h"
#define kCount 3

@interface NewfeatureController () <UIScrollViewDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
}
@end

@implementation NewfeatureController

#pragma mark 自定义view

/*
 一个控件无法显示：
 1.没有设置宽高(或者宽高为0)
 2.位置不对
 3.hidden=YES
 4.没有添加到控制器的view上面
 
 一个UIScrollView无法滚动：
 1.contentSize没有值
 2.不能接收到触摸事件
 
 一个按钮没法点击，有可能是父控件不支持点击
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    // 1.添加UIScrollView
    [self addScrollView];
    
    // 2.添加图片
    [self addScrollImages];
    
    // 3.添加UIPageControl
    [self addPageControl];
}

#pragma mark - UI界面初始化
#pragma mark 添加滚动视图
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO; // 隐藏水平滚动条
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0); // 内容尺寸
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark 添加滚动显示的图片
- (void)addScrollImages
{
    CGSize size = _scroll.frame.size;
    
    for (int i = 0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 1.显示图片
        NSString *name = [NSString stringWithFormat:@"welcome%d", i + 1];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:name];
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) { // 最后一页，添加2个按钮
            // 3.立即体验（开始）
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.center = CGPointMake(size.width * 0.5, size.height - 80);
            start.bounds = (CGRect){CGPointZero, {120, 80}};
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            // 4.分享
            UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
            // 普通状态显示的图片（selected=NO）
            UIImage *shareNormal = [UIImage imageNamed:@"new_feature_share_false.png"];
            [share setBackgroundImage:shareNormal forState:UIControlStateNormal];
            // 选中状态显示的图片（selected=YES）
            [share setBackgroundImage:[UIImage imageNamed:@"new_feature_share_true.png"] forState:UIControlStateSelected];
            
            share.center = CGPointMake(start.center.x, start.center.y - 50);
            share.bounds = (CGRect){CGPointZero, shareNormal.size};
            [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            share.selected = YES;
            share.adjustsImageWhenHighlighted = NO;
            [imageView addSubview:share];
            imageView.userInteractionEnabled = YES;
        }
    }
}

#pragma mark 添加分页指示器
- (void)addPageControl
{
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    //[self.view addSubview:page];
    _page = page;
}

#pragma mark - 监听按钮点击
#pragma mark 开始
- (void)start
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"Guided"];
    [userDefaults synchronize];
//    MyLog(@"开始微博");
    
//    [UIApplication sharedApplication].keyWindow;
    
    /*
     有显示状态栏时创建控制器，控制器view的高度：460
     没有显示状态栏时创建控制器，控制器view的高度：480
     */
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
//    [self.navigationController popViewControllerAnimated:YES];
   // [self dismissModalViewControllerAnimated:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = _navigationController;
    // 控制器的view是延迟加载：需要显示的\用到的时候才会加载
//    self.view.window.rootViewController = [[AppManager sharedAppManager] startApp];
//    DailyBoothViewController *viewController = [[DailyBoothViewController alloc] initWithNibName:nil bundle:nil];
//    viewController.delegate = self;
//    _navigationController = [[XHBaseNavigationController alloc] initWithRootViewController:viewController];
//    _navigationController.delegate = self;
//    [self.view.window setRootViewController:_navigationController];
}

#pragma mark 分享
- (void)share:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)dealloc
{
//    MyLog(@"new----销毁");
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
        
        //        viewController.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"问题反馈" style:UIBarButtonItemStyleBordered target:viewController action:@selector(clickedLeftAction)];
        
        ((XHMessageRootViewController *)viewController).tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
        ((XHMessageRootViewController *)viewController).topTableView.alpha = 0;
        
    }else if ([viewController isKindOfClass:[XHContactTableViewController class]]){
        
        viewController.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleBordered target:viewController action:@selector(clickedLeftAction)];
        
        viewController.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
    }else if ([viewController isKindOfClass:[XHDiscoverTableViewController class]]){
        
        viewController.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
        viewController.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nil];
        
    }else if ([viewController isKindOfClass:[XHProfileTableViewController class]]){
        
    }
    
}


@end
