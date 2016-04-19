//
//  MZTabBar.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/17.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZTabBar.h"

@interface MZTabBar ()
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation MZTabBar
{
    UITabBarController *tabBarVC;
}

- (void)setupWithTabVC:(UITabBarController*)tvc
{
    tabBarVC = tvc;
    self.frame = Rect(0, VMinY(tabBarVC.tabBar)-65-15, VWidth(tabBarVC.tabBar), 60);
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab-bg"]];
    
    UIImageView *i = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab-bg"]];
    i.frame = Rect(0, 0, VWidth(self), VHeight(self)+20);
    i.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:i];
    // 装载假UITabBarItems
    NSInteger index = 0;
    NSInteger count = tabBarVC.tabBar.items.count;
    CGFloat unit = VWidth(self)/count;
    for(UITabBarItem *tabItem in tabBarVC.tabBar.items){
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = Rect(0, 0, index==2?40:30, index==2?40:30);
        [btn setBackgroundImage:tabItem.image forState:UIControlStateNormal];
        [btn setBackgroundImage:tabItem.selectedImage forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectBar:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:tabItem.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.184 green:0.741 blue:1.000 alpha:1.000] forState:UIControlStateSelected];
        btn.center = Point(unit*0.5+unit*index, VHeight(btn)*0.5+(index==2?10:20));
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -VHeight(btn)-10.0f, 0)];
        if (tabBarVC.selectedIndex==index) {
            self.selectBtn = btn;
            _selectBtn.selected = YES;
        }
        btn.tag = index++;
        [self addSubview:btn];
    }
    tabBarVC.tabBar.hidden = YES;
    [tabBarVC.view addSubview:self];
}

- (void)selectBar:(UIButton*)sender
{
    self.selectBtn.selected = NO;
    sender.selected = YES;
    tabBarVC.selectedIndex = sender.tag;
    self.selectBtn = sender;
}

@end
