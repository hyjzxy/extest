//
//  DDBaseTableViewController.m
//  DDMessage
//
//  Created by HuiPeng Huang on 13-12-26.
//  Copyright (c) 2013年 HuiPeng Huang. All rights reserved.
//

#import "DDBaseTableViewController.h"
#import "DDBarButton.h"
#import "UIImage+DD.h"
@interface DDBaseTableViewController ()

@end

@implementation DDBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
//    _backButton = nil;
}
- (void)loadView {
    [super loadView];
    
    if (!self.first) {
        DDBarButton *backButton = [[DDBarButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImage:[UIImage imageNamed:@"TopLeft_back_red"] forState:UIControlStateNormal];
        if (IS_IOS_7) {
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 40);
        }else {
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        }
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
