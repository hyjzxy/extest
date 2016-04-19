//
//  XHTaoLunViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHTaoLunViewController.h"
#import "XHFoundationCommon.h"
#import "taoLunCommentView.h"
#import "UIImageView+WebCache.h"

#import "UMSocial.h"

#import "taoLunTableViewCell.h"
#import "HYHelper.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "IQKeyboardManager.h"
#import "Masonry.h"
#import "MZChatView.h"
#import "SVProgressHUD.h"
@interface XHTaoLunViewController ()<UMSocialUIDelegate,TaoLunCommentDelegate,ChatDelegate>
{
    taoLunCommentView *comentView;
    int page;
}
@end

@implementation XHTaoLunViewController
{
    MZChatView *chatView;
}

- (instancetype)initWithWID:(int)wid{
    if (self = [super init]) {
        _wid = wid;
    }
    return self;
}

- (NSString *)lastUpdateTimeString {
    
    NSDate *nowDate = [NSDate date];
    
    NSString *destDateString = [nowDate timeAgo];
    
    return destDateString;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self configuraTableViewNormalSeparatorInset];
    self.view.backgroundColor=RGBCOLOR(230, 230, 230);
    //添加上拉加载更多
    self.tableView.sectionFooterHeight = 1.0f;
    __weak XHTaoLunViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView.legendHeader beginRefreshing];
    self.title = @"评论";
    chatView = ViewFromXib(@"MZChatView", 0);
    [chatView instKey];
    chatView.delegate = self;
    [self.view addSubview:chatView];
    WS(ws);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(ws.view);
    }];
    
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(ws.view);
        make.top.equalTo(ws.tableView.mas_bottom).with.offset(-45);
    }];
}

-(void)reloadMoreData
{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            NSArray *keyValue = [FIND_DISCUSS_PARAM componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[uid,@(page),@20,@(self.wid)] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_DISCUSS_API withType:FIND_DISCUSS success:^(id responseObject){
                if (page == 1)[self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:responseObject];
                page++;
                [self.tableView reloadData];
                [self.tableView.legendHeader endRefreshing];
                [self.tableView.legendFooter endRefreshing];
            }failure:^(id error){
                [self.tableView.legendHeader endRefreshing];
                [self.tableView.legendFooter endRefreshing];
            }];
        }else {
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
            [BMUtils showError:@"您还没有登录"];
        }
    }];
   
}
- (void)reloadData
{
    page = 1;
    
    [self reloadMoreData];
}

- (void)sendMsg:(NSString *)text
{
    [self.view endEditing:YES];
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            NSArray *keyValue   = [FIND_ADD_PARAM componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[uid,@(self.wid),text] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:dic
                                               withUrl:FIND_ADD_API
                                              withType:FIND_ADD
                                               success:^(id responseObject) {
                                                   [BMUtils showSuccess:@"发送成功"];
                                                   [self.tableView.legendHeader beginRefreshing];
                                               }failure:^(id error){
                                                   [BMUtils showError:error];
                                               }];
        } else {
            [BMUtils showError:@"登陆后才能操作"];
        }
    }];
}

- (void)startInput
{
    if (self.dataSource.count) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.tableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)replayCommentAxtion:(NSString *)disId{}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (taoLunTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"XHTaoLunViewController";
    taoLunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = ViewFromXib(@"taoLunTableViewCell", 0);
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.nameLabel.text=[dic objectForKey:@"nickname"];
    cell.dateLabele.text = [dic objectForKey:@"inputtime"];
    [HYHelper mSetLevelLabel:cell.numberLabel level:dic[@"rank"]];
    cell.sayLabel.text=[dic objectForKey:@"content"];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.headBtn.tag = indexPath.row;
    [cell.headBtn addTarget:self action:@selector(toPerson:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.tag = indexPath.row;
    [cell.praiseBtn setTitle:N2V(dic[@"hits"], @"0") forState:UIControlStateNormal];
    if ([dic[@"ispraise"]boolValue]) {
        [cell.praiseBtn setImage:[UIImage imageNamed:@"praise-on"] forState:UIControlStateNormal];
    }else{
        [cell.praiseBtn setImage:[UIImage imageNamed:@"praise-off"] forState:UIControlStateNormal];
    }
    [cell.praiseBtn addTarget:self action:@selector(praiseAct:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

/**
 *  @author 麦子, 15-05-25 16:05:52
 *
 *  @brief  切换到个人中心
 *
 *  @param btn UIButton
 *
 *  @since v1.0
 */
- (void)toPerson:(UIButton*)btn
{
    NSDictionary *dic = self.dataSource[btn.tag];
    [HYHelper pushPersonCenterOnVC:self uid:[dic[@"uid"]intValue]];
}

/**
 *  @author 麦子, 15-05-25 16:05:06
 *
 *  @brief  点赞
 *
 *  @param btn UIButton
 *
 *  @since v1.0
 */
- (void)praiseAct:(UIButton*)btn
{
    [self.view endEditing:YES];
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            [SVProgressHUD showWithStatus:@"处理中..." maskType:SVProgressHUDMaskTypeClear];
            NSDictionary *dic = self.dataSource[btn.tag];
            [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithObjects:@[uid,dic[@"id"]] forKeys:[FIND_HIT_PARAM componentsSeparatedByString:@","]]
                                           withUrl:FIND_HIT_API
                                          withType:FIND_HIT
                                           success:^(id responseObject) {
                                               BOOL isPraise = [responseObject[@"sign"]isEqualToString:@"add"];
                                               NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:dic];
                                               tmp[@"ispraise"] = @(isPraise);
                                               tmp[@"hits"] = [NSString stringWithFormat:@"%i",[tmp[@"hits"]intValue]+(isPraise?1:-1)];
                                               self.dataSource[btn.tag] = tmp;
                                               [self.tableView reloadData];
                                               [BMUtils showSuccess:@"操作成功"];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
        }else{
            [BMUtils showError:@"您还没有登录"];
        }
    }];
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   [self.view endEditing:YES];
}

@end
