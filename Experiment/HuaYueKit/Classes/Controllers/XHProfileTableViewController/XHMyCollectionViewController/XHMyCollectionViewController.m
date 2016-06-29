//
//  XHMyCollectionViewController.m
//  HuaYue
//
//  Created by Gideon on 16/6/21.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "XHMyCollectionViewController.h"
#import "HKSegView.h"

@interface XHMyCollectionViewController ()

@property(nonatomic,strong)HKSegView* segView;

@end

@implementation XHMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    NSArray* titleArray = @[@"问答",@"文章"];
    HKSegView* segView = [[HKSegView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    segView.titleArray = titleArray;
    segView.normalBackgroundColor = [UIColor whiteColor];
    segView.selectBackgroundColor = [UIColor whiteColor];
    segView.titleColor = [UIColor blackColor];
    [self.view addSubview:segView];
    // Do any additional setup after loading the view.
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
