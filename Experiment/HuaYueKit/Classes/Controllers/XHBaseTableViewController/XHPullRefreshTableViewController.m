//
//  XHPullRefreshTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-6-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPullRefreshTableViewController.h"

@interface XHPullRefreshTableViewController ()

@property (nonatomic, strong) XHRefreshControl *refreshControl;

@end

@implementation XHPullRefreshTableViewController

- (UIButton *)customLoadMoreButton {
    UIButton *_loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(self.view.bounds) - 20, CGRectGetHeight(self.view.bounds) - 10)];
    _loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loadMoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loadMoreButton setBackgroundColor:RGBCOLOR(240, 240, 240)];
    [_loadMoreButton.layer setMasksToBounds:YES];
    [_loadMoreButton.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    return _loadMoreButton;
}

- (void)startPullDownRefreshing {
    [self.refreshControl startPullDownRefreshing];
}

- (void)endPullDownRefreshing {
    [self.refreshControl endPullDownRefreshing];
}

- (void)endLoadMoreRefreshing {
    [self.refreshControl endLoadMoreRefresing];
}

- (void)endMoreOverWithMessage:(NSString *)message {
    [self.refreshControl endMoreOverWithMessage:message];
}

- (void)handleLoadMoreError {
    [self.refreshControl handleLoadMoreError];
}

#pragma mark - Life Cycle

- (void)setupRefreshControl {
    if (!_refreshControl) {
        _refreshControl = [[XHRefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        self.pullDownRefreshed = YES;
        self.loadMoreRefreshed = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.pullDownRefreshed) {
        [self setupRefreshControl];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHRefreshControl Delegate

- (void)beginPullDownRefreshing {
    self.requestCurrentPage = 0;
    [self loadDataSource];
}

- (void)beginLoadMoreRefreshing {
    self.requestCurrentPage ++;
    [self loadDataSource];
}

- (NSString *)lastUpdateTimeString {
    
    NSString *destDateString;
    destDateString = @"从未更新";
    
    return destDateString;
}

- (NSInteger)autoLoadMoreRefreshedCountConverManual {
    return 5;
}

- (BOOL)isPullDownRefreshed {
    return self.pullDownRefreshed;
}

- (BOOL)isLoadMoreRefreshed {
    return self.loadMoreRefreshed;
}

- (XHRefreshViewLayerType)refreshViewLayerType {
    return XHRefreshViewLayerTypeOnScrollViews;
}

- (XHPullDownRefreshViewType)pullDownRefreshViewType {
    return self.refreshViewType;
}

- (NSString *)displayAutoLoadMoreRefreshedMessage {
    return @"显示下10条";
}

@end
