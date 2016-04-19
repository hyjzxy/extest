//
//  XHBaseTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-6.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseTableViewController.h"
#import "XHFoundationCommon.h"
#import "XHProfileTableViewController.h"
@interface XHBaseTableViewController ()<UIAlertViewDelegate>

/**
 *  判断tableView是否支持iOS7的api方法
 *
 *  @return 返回预想结果
 */
- (BOOL)validateSeparatorInset;

@end

@implementation XHBaseTableViewController

#pragma mark - Publish Method

- (void)configuraTableViewNormalSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}

- (void)loadDataSource {
    // subClasse
}

#pragma mark - Propertys

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = self.view.bounds;
        tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1) ? [XHFoundationCommon getAdapterNavHeight] : [XHFoundationCommon getAdapterHeight];
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (![self validateSeparatorInset]) {
            if (self.tableViewStyle == UITableViewStyleGrouped) {
                UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
                backgroundView.backgroundColor = _tableView.backgroundColor;
                _tableView.backgroundView = backgroundView;
            }
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.pageNum = 1;
    self.alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要登入后才能查看，请先登入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alertView.delegate = self;
    [self.view addSubview:self.tableView];
}



- (void)dealloc {
    self.dataSource = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Helper Method

- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // in subClass
    return nil;
}

- (void)changeToLongUp{
//    XHProfileTableViewController *control = [[XHProfileTableViewController alloc] init];
//    [self.navigationController pushViewController:control animated:YES];
}

- (void)setUpRightBtnWithTitle:(NSString *)title{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
}

- (void)clickedBarButtonItemAction{

}

- (void)mCacheDataSource:(NSString*)fileName
{
    NSString *filePath = NSDocFilePath(fileName);
    [_dataSource writeToFile:filePath atomically:YES];
}
@end
