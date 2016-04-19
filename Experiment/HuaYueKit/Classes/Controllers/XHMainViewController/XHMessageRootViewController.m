//
//  XHMessageRootViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-26.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageRootViewController.h"
#import "XHNewsTableViewController.h"
#import "XHCustomLoadMoreButtonDemoTableViewController.h"
#import "XHFoundationCommon.h"
#import "LoopScrollView.h"
#import "MyLabel.h"
#import "NetManager.h"
#import "SBJsonParser.h"
#import "UIButton+WebCache.h"
#import "HuiDaWyTableViewCell.h"
#import "TiWenWYTableViewCell.h"
#import "HomeCommonTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "DDSearchViewController.h"
#import "XHMyselfViewController.h"
#import "XHMyButton.h"
#import "xiangqingye.h"
#import "XHBannerViewController.h"
#import "HYBannerView.h"
#import "HYHelper.h"
#import "MZToast.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Masonry.h"
#import "MZAnswerListVC.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "XHProfileTableViewController.h"
#import "MZAnswerChatVC.h"

@interface XHMessageRootViewController ()<HYBannerViewDataSource,HYBannerViewDelegate,UISearchBarDelegate>
{
    UIView *view;
    UIView *topView;
    UISearchBar *search;
    NSArray *banners;
    UIButton *keyHiddenView;
    UIView  *verLine;
    HYBannerView *bannerView;
}
@end

@implementation XHMessageRootViewController

- (void)enterMessage {
    XHCustomLoadMoreButtonDemoTableViewController *demoWeChatMessageTableViewController = [[XHCustomLoadMoreButtonDemoTableViewController alloc] init];
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

- (void)enterNewsController {
    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    [self pushNewViewController:newsTableViewController];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadBannerView];
    self.tabBarController.title = @"";
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:topView];
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            if (!verLine) {
                verLine = [[UIView alloc] initWithFrame:CGRectMake(30, 190, 1, 1000000)];
                verLine.backgroundColor    = [UIColor redColor];
                [self.tableView insertSubview:verLine atIndex:0];
            }
        }else{
            if (verLine) {
                [verLine removeFromSuperview];
                verLine = nil;
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    keyHiddenView.alpha = 1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _topTableView.alpha = 1;
    DDSearchViewController *control = [[DDSearchViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}
- (void)searchClick:(UIButton *)sender{
    DDSearchViewController *control = [[DDSearchViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.tableView.frame = CGRectOffset(self.tableView.frame, 0, VWidth(self.view)/3.5+27.5);
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(-15, 0, 100, 40)];
    [left setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(85, 7, 210, 34)];
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(85, 7, 210, 34)];
    search.delegate = self;
    search.placeholder = @"搜索";
    
    [topView addSubview:left];
    [topView addSubview:search];
    [topView addSubview:btn];
    [btn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([search respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1){ //iOS7.1
            [[[[search.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [search setBackgroundColor:[UIColor clearColor]];
        }
        else{//iOS7.0
            [search setBarTintColor:[UIColor clearColor]];
            [search setBackgroundColor:[UIColor clearColor]];
        }
    }else{  //iOS7.0以下
        [[search.subviews objectAtIndex:0] removeFromSuperview];
        [search setBackgroundColor:[UIColor clearColor]];
    }
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:topView];
    self.tabBarController.title = @"";
    UIView *headerView = [[UIView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 200.0)];
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    bannerView = [[HYBannerView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 160.0)];
    bannerView.dataSource = self;
    bannerView.delegate  = self;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, VHeight(bannerView), VWidth(self.view), 27.5)];
    img.image = [UIImage imageNamed:@"mainTop"];
    [headerView addSubview:bannerView];
    [headerView addSubview:img];
    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加上拉加载更多
    __weak XHMessageRootViewController *blockSelf = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData:nil];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf requestDataComment];
    }];
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= (self.navigationController.viewControllers.count > 1) ? [XHFoundationCommon getAdapterNavHeight] : [XHFoundationCommon getAdapterHeight];
    _topTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _topTableView.delegate = self;
    _topTableView.dataSource = self;
    _topTableView.backgroundColor = RGBCOLOR(242, 242, 242);
    _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_topTableView];
    _topTableView.alpha = 0;
    keyHiddenView = [[UIButton alloc] initWithFrame:self.tableView.bounds];
    [keyHiddenView addTarget:self action:@selector(closeKey) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:keyHiddenView];
    keyHiddenView.alpha = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"wangyu" object:nil];
    [self.tableView.legendHeader beginRefreshing];
}
//13472592965
- (void)reloadData:(NSNotification *)n{
    if (![HYHelper mLoginID:nil]) {
        UIView *loginView = ViewFromXib(@"TiWenView", 3);
        loginView.frame = Rect(0, 0, VWidth(self.view), 350);
        UIButton *loginBtn = (UIButton*)VIEWWITHTAG(loginView, 999);
        [loginBtn addTarget:self action:@selector(gotologin:) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = loginView;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        return;
    }else{
        self.tableView.tableFooterView = nil;
        self.pageNum = 0;
        [self requestDataComment];
    }
}

/**
 *  @author 崔俊红, 15-04-08 21:04:17
 *
 *  @brief  加载首页数据
 *  @since v1.0
 */
-(void)requestDataComment{
    __weak XHMessageRootViewController *weakMy = self;
    NSArray *keyValue = [EXPERIMENTALRING_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],[NSString stringWithFormat:@"%ld",(long)self.pageNum],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    if (![NetManager isNetAlive]) {
        NSString *filePath = NSDocFilePath(kCacheMainDSFileName);
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[[NSArray alloc]initWithContentsOfFile:filePath]];
            [self.tableView reloadData];
        }
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }else{
        [[NetManager sharedManager] myRequestParam:dic withUrl:EXPERIMENTALRING_API withType:EXPERIMENTALRING success:^(id responseObject){
            if (self.pageNum==0) {
                [self.dataSource removeAllObjects];
            }
            self.pageNum =  [((NSObject*)responseObject).info[@"maxid"] integerValue];
            [weakMy.dataSource addObjectsFromArray:responseObject];
            [weakMy.tableView reloadData];
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
            if(responseObject!=nil && ((NSArray*)responseObject).count>0){
                [[NSBlockOperation blockOperationWithBlock:^{
                    [self mCacheDataSource:kCacheMainDSFileName];
                }]start];
            }
        }failure:^(id error){
            [self.tableView reloadData];
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
        }];
    }
}

-(void)closeKey{
    [search resignFirstResponder];
    keyHiddenView.alpha = 0;
}

#pragma mark - 加载数据
/**
 *  @author 崔俊红, 15-04-08 21:04:54
 *
 *  @brief  加载广告数据
 *  @since v1.0
 */
- (void)loadBannerView
{
    NSArray *keyValue = [AD_INFO_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:@"1"] forKeys:keyValue];
    if (![NetManager isNetAlive]) {
        NSString *filePath = NSDocFilePath(kCacheMainBannerFileName);
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
            banners = [NSArray arrayWithContentsOfFile:filePath];
            [bannerView reloadData];
        }
    }else{
        [[NetManager sharedManager] myRequestParam:dic withUrl:AD_INFO_API withType:AD_INFO success:^(id responseObject){
            banners = responseObject;
            [bannerView reloadData];
            [[NSBlockOperation blockOperationWithBlock:^{
                [banners writeToFile:NSDocFilePath(kCacheMainBannerFileName) atomically:YES];
            }]start];
        }failure:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - HYBannerViewDataSource
-  (NSArray *)bannerDatas
{
    return  banners;
}

#pragma mark - HYBannerViewDelegate
- (void)bannerView:(id)bannerView selectedData:(NSInteger)index
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[banners[index][@"url"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    [self pushNewViewController:[[xiangqingye alloc] initWithWID:[dic[@"articleid"]intValue]title:banners[index][@"title"]]];
}

- (void)buildImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary *dic = banners[index];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = SYSTEMFONT(15.0f);
    titleLabel.text = dic[@"title"];
    titleLabel.textColor = [UIColor whiteColor];
   
    UIView *bg = [[UIView alloc]init];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.7f;
    [bg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
    }];
     [imageView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(imageView);
        make.height.mas_equalTo(@28);
    }];
    
}

#pragma mark - UITableView DataSource

- (void)gointoInformationWith:(XHMyButton *)sender Index:(int)index{
    [HYHelper pushPersonCenterOnVC:self uid:[self.dataSource[sender.arrayIndex][@"uid"] intValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     //1：我的提问，
     //2：我的回答，
     //3：我的粉丝求助，
     4：我的答案被采纳，
     //5：我的追问，
     6：我关注的人的提问 ，
     7：我关注的人的回答，
     //8：XX关注了我，
     //9：我关注XXX，
     10：XXX受我邀请注册了实验助手并关注了我，
     11：活动中心培训信息的主动推送内容）
     */
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSDictionary *data = self.dataSource[indexPath.row];
    NSInteger type = [N2V(data[@"type"],@-1)integerValue];
    UIImageView *headerIV = nil;
    NSString *headImageName = @"";
    // 问题型 14 问题分享
    if (type == 1 || type == 3 || type==6 || type == 14) {
        cell = ViewFromXib(@"FirstPage", 2);
        headerIV = (UIImageView*)VIEWWITHTAG(cell, 1001);
        UILabel *nickNameLB = (UILabel*)VIEWWITHTAG(cell, 1002);
        UILabel *inputTimeLB = (UILabel*)VIEWWITHTAG(cell, 1003);
        UILabel *contentLB = (UILabel*)VIEWWITHTAG(cell, 1004);
        UIImageView *imageIV = (UIImageView*)VIEWWITHTAG(cell, 1005);
        UILabel *invateLB = (UILabel*)VIEWWITHTAG(cell, 1006);
        UILabel *lableLB = (UILabel*)VIEWWITHTAG(cell, 1007);
        UIButton *ansSumLB = (UIButton*)VIEWWITHTAG(cell, 1008);
        UIImageView *solveedIV = (UIImageView*)VIEWWITHTAG(cell, 1009);
        UILabel *titleLB = (UILabel*)VIEWWITHTAG(cell, 1010);
        titleLB.text = N2V(data[@"bewrite"],@"");
        nickNameLB.text = [HYHelper mNickLable:N2V(data[@"nickname"],@"") userId:data[@"uid"]];
        inputTimeLB.text = N2V(data[@"inputtime"],@"");
        contentLB.text = N2V(data[@"content"],@"");
        lableLB.attributedText = [HYHelper mBuildLable:N2V(data[@"lable"],@"") font:lableLB.font];
        [HYHelper mSuperList:invateLB supers:N2V(data[@"superlist"],@"")];
        [ansSumLB setTitle:[NSString stringWithFormat:@" %@人回答",N2V(data[@"anum"],@0)] forState:UIControlStateNormal];
        solveedIV.hidden = !(type==3&&[data[@"issolveed"]boolValue]);
        NSString *image = N2V(data[@"image"], @"");
        [imageIV mas_updateConstraints:^(MASConstraintMaker *make) {
            if (image.length>0) {
                [imageIV setImageWithURL:IMG_URL(image) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                make.height.mas_equalTo(@50);
            }else{
                make.height.mas_equalTo(@1);
            }
        }];
        headerIV.info = @{@"uid":data[@"uid"]};
        headerIV.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
    //回答型
    } else if (type == 2 || type == 4 || type == 5 || type==7 || type == 13) {
        cell = ViewFromXib(@"FirstPage", 0);
        headerIV = (UIImageView*)VIEWWITHTAG(cell, 1001);
        UILabel *nickNameLB = (UILabel*)VIEWWITHTAG(cell, 1002);
        UILabel *inputTimeLB = (UILabel*)VIEWWITHTAG(cell, 1003);
        UILabel *contentLB = (UILabel*)VIEWWITHTAG(cell, 1004);
        UILabel *lableLB = (UILabel*)VIEWWITHTAG(cell, 1005);
        UILabel *newAskLB = (UILabel*)VIEWWITHTAG(cell, 1006);
        UIButton *solvedBtn = (UIButton*)VIEWWITHTAG(cell, 1007);
        UILabel *titleLB = (UILabel*)VIEWWITHTAG(cell, 1008);
        UIButton *toChatBtn = (UIButton*)VIEWWITHTAG(cell, 1009);// 切换到互动页
        UIImageView *qImageView = (UIImageView*)VIEWWITHTAG(cell, 1010);
        id auid = @"0";
        id aid = data[@"aid"];
        if (type==4||type==7) {
            auid=data[@"uid"];
        }else if(type == 3||type == 2){
            auid = data[@"auid"];
        }
        if (type == 7) {
            if (!aid||[aid integerValue]==0) {
                aid = data[@"findid"];
            }
        }else {
            if (!aid||[aid integerValue]==0) {
                aid = data[@"id"];
            }
        }
        NSString *nickname = @"";
        if (type == 13) {
            nickname = [HYHelper isSameName:data[@"answernickname"]]?@"我":data[@"answernickname"];
        } else if(type == 5) {
            nickname = [HYHelper isSameName:data[@"answernickname"]]?@"我":data[@"answernickname"];
        } else {
            nickname = data[@"nickname"];
        }
        toChatBtn.info = @{@"ChatType":@((type == 2 || type == 4|| type == 7)?kAnswerChat:kAddQuestChat),@"qid":data[@"qid"],@"uid":data[@"uid"],@"aid":aid,@"nickname":nickname,@"auid":auid,@"ID":data[@"id"]};
        [toChatBtn addTarget:self action:@selector(toChatAct:) forControlEvents:UIControlEventTouchUpInside];
        
        titleLB.text =  N2V(data[@"bewrite"],@"");
        nickNameLB.text = [HYHelper mNickLable:N2V(data[type==13?@"anickname":@"nickname"],@"") userId:data[@"uid"]];
        inputTimeLB.text = N2V(data[@"inputtime"], @"");
        if(type == 2 || type == 5 || type==7 || type == 13) {//questiontitle
            newAskLB.attributedText  = [HYHelper mBuildAnswer:N2V(type==7?data[@"acontent"]:data[@"content"], @"") font:newAskLB.font userId:data[@"uid"] isAnswer:type==2
                                        ||type==7];
            contentLB.text = N2V(type==7?data[@"qcontent"]:data[@"questiontitle"], @"");
        }else if(type==4){
            contentLB.text = N2V(data[@"title"], @"");
            newAskLB.attributedText  = [HYHelper mBuildAnswer:N2V(data[@"content"], @"")  font:newAskLB.font userId:data[@"uid"] isAnswer:type==4];
        }
        lableLB.attributedText = [HYHelper mBuildLable:data[@"lable"] font:lableLB.font];
        NSString *image = N2V(data[@"qimage"], @"");
        [qImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (image.length>0) {
                [qImageView setImageWithURL:IMG_URL(image) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                make.height.mas_equalTo(@50);
            }else{
                make.height.mas_equalTo(@1);
            }
        }];
        solvedBtn.hidden = ![data[@"isadopt"]boolValue];
        headerIV.info = @{@"uid":data[@"uid"]};
        headerIV.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
    //关注型 一句话显示
    }else if( type == 8 || type == 9|| type == 10) {
        cell = ViewFromXib(@"FirstPage", 1);
        headerIV = (UIImageView*)VIEWWITHTAG(cell, 1001);
        headerIV.info = @{@"uid":data[@"id"]?data[@"id"]:data[@"uid"]};
        [HYHelper mLoginID:^(id uid) {
            if (uid) {
    
            }
        }];
        headerIV.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
        UILabel *nickNameLB = (UILabel*)VIEWWITHTAG(cell, 1002);
        UILabel *inputTimeLB = (UILabel*)VIEWWITHTAG(cell, 1003);
        UILabel *titleLB = (UILabel*)VIEWWITHTAG(cell, 1004);
        inputTimeLB.text = data[@"inputtime"];
        if (type == 8) {
            nickNameLB.text = data[@"nickname"];
            titleLB.text = @"关注了我";
        }else if(type == 9){
            nickNameLB.text = @"我";
            titleLB.text = [NSString stringWithFormat:@"关注了%@",data[@"nickname"]];
        }else{
            nickNameLB.text = data[@"nickname"];
            titleLB.text = N2V(data[@"bewrite"],@"");
        }
    // 培训中心 、活动中心
    }else if(type == 11|| type == 12) {
        cell = ViewFromXib(@"FirstPage", 3);
        headerIV = (UIImageView*)VIEWWITHTAG(cell, 1001);
        UILabel *titleLB = (UILabel*)VIEWWITHTAG(cell, 1002);
        UILabel *inputTimeLB = (UILabel*)VIEWWITHTAG(cell, 1003);
        UIImageView *contentIV = (UIImageView*)VIEWWITHTAG(cell, 1004);
        int catId = [data[@"catid"]intValue];
        switch (catId) {
            case 4:
                headImageName  = @"ff_IconShowNews";
                break;
            case 5:
                headImageName  = @"ff_IconShowTest";
                break;
            case 6:
                headImageName  = @"ff_IconShowLaw";
                break;
            case 7:
                headImageName  = @"ff_IconTech";
                break;
            case 8:
                headImageName  = @"ff_IconActivity";
                break;
            case 9:
                headImageName  = @"ff_IconBrand";
                break;
            default:
                break;
        }
        [contentIV setImageWithURL:IMG_URL(data[@"thumb"]) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        UILabel *contentLB = (UILabel*)VIEWWITHTAG(cell, 1005);
        titleLB.text = N2V(data[@"bewrite"],@"");
        inputTimeLB.text = data[@"inputtime"];
        contentLB.text = N2V(data[@"title"],@"");
    }
    if (data[@"head"]) {
        [headerIV setImageWithURL:IMG_URL(data[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"]  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }else{
        [headerIV setImage:[UIImage imageNamed:headImageName]];
    }
    headerIV.layer.masksToBounds = YES;
    headerIV.layer.borderColor = [[UIColor redColor]CGColor];
    headerIV.layer.borderWidth = 1.0f;
    headerIV.layer.cornerRadius = MAX(VHeight(headerIV), VWidth(headerIV))*0.5;
    return cell;
}
 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![HYHelper mLoginID:nil])return;
    NSDictionary *dic = self.dataSource[indexPath.row];
    NSInteger type = [N2V(dic[@"type"],@-1)integerValue];
    if (type<=7 || type==13 || type==14) {
        MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
        answerListVC.qid = type==1||type==3||type==6||type==14?[dic[@"id"]integerValue]:[dic[@"qid"]integerValue];
        answerListVC.chatFrom = kChatFromMyQuest;
        [self pushNewViewController:answerListVC];
    } else if (type == 11 || type == 12) {
        int t  = 1;
        int catId = [dic[@"catid"]intValue];
        if (catId == 7) {
            XHBannerViewController  *fc = [[XHBannerViewController alloc] init];
            fc.wID = [dic[@"id"] intValue];
            fc.catId = dic[@"catid"];
            fc.type = 1;
            fc.title = @"培训信息";
            [self.navigationController pushViewController:fc animated:YES];
        }else{
            NSString *title = @"";
           
            if (catId==4) {
                title = @"助手日报";
            }else if(catId==5) {
                title = @"实验周刊";
                if ([dic.allKeys containsObject:@"mark"]&&[dic[@"mark"] intValue]==2) {
                     t = 2;
                }else {
                    t = 1;
                }
            }else if(catId==6) {
                title = @"法规文献";
            }else if(catId==8) {
                title = @"活动中心";
            }else if(catId==9) {
                title = @"品牌库";
            }
            [self pushNewViewController:[[xiangqingye alloc] initWithWID:[dic[@"id"] intValue] title:title type:t]];
        }
    }
}

- (void)gotologin:(UIButton *)sender{
    self.tabBarController.selectedIndex = 4;
}

//获取提问cell类型 的title描述
- (NSString*)getTiWenTitleDesLabelText:(NSString*)type
{
    if ([type isEqualToString:@"addquestion"]) {//提问
        return @"提了一个问题";
    } else if ([type isEqualToString:@"sharequestion"]) {//分享
        return @"分享了一个问题";
    }else if ([type isEqualToString:@"fanshelp"]) {//粉丝求助
        return @"向我求助一个问题";
    }
    return @"提了一个问题";
}

//获取回答cell类型 的title描述
- (NSString*)getHuiDaTitleDesLabelText:(NSString*)type
{
    if ([type isEqualToString:@"addafter"]) {//追问
        return @"追问我";
    } else if ([type isEqualToString:@"addadopted"]) {//被采纳
        return @"的回答被采纳为最佳答案";
    }
    return @"回答了一个问题";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self forKeyPath:@"wangyu"];
}

//切换到互动页面
- (void)toChatAct:(UIButton*)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if(!(userId.length>0)){
        [BMUtils showError:@"您还没有登录"];
        return;
    }
    NSDictionary *info = sender.info;
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.auid = [info[@"auid"]integerValue];
    chatVC.aid = [info[@"aid"]integerValue];
    chatVC.qid = [info[@"qid"]integerValue];
    chatVC.nickName = info[@"nickname"];
    chatVC.chatType = [info[@"ChatType"]integerValue];
    chatVC.isAddQuest = chatVC.chatType ==kAddQuestChat;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}
@end
