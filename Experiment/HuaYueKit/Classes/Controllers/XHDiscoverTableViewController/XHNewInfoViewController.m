//
//  XHNewInfoViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewInfoViewController.h"
#import "xiangqingye.h"
@interface XHNewInfoViewController ()

@end

@implementation XHNewInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"助手日报";
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.bounds) - (iOS7?64:44))];
    image.image = [UIImage imageNamed:@"问卷调查"];
    [self.view addSubview:image];
    
    for (int i=0; i<3; i++) {
        xiangqingye*XP=[[xiangqingye alloc]init];
        XP.wenjuandiaochaView.frame=CGRectMake(0,48+185*i, self.view.frame.size.width, 185);
        [self.view addSubview: XP.wenjuandiaochaView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
