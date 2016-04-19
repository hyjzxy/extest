//
//  XHKJIFenViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHKJIFenViewController.h"
#import "XHJiFenView.h"
#import "XHShiMingRZViewController.h"

#import "MyLabel.h"
#import "XHCollectionViewCell.h"
#import "BMMyCollectionReusableView.h"
#import "UIImageView+WebCache.h"
#import "ApatrinViewController.h"
#import "LoopScrollView.h"
#import "xiangqingye.h"
#import "XHMyWuPinViewController.h"
#import "HYHelper.h"
#import "MZTabView.h"
#import "Masonry.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SVProgressHUD.h"

@interface XHKJIFenViewController ()<UISearchBarDelegate,UIWebViewDelegate>
{
    UISearchBar *search;
    UIImageView *buttonBg;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *detailView;
    UILabel *myJifen;
    UIImageView*myRenzheng;
    int page;
    int selectedIndex;
}

@property (nonatomic,strong) NSDictionary    *adDic;
@property (nonatomic,strong) UIImageView    *adImageView;

@property(nonatomic, strong)NSDictionary *myinforMationDic;
@property(nonatomic, strong)NSDictionary *profile;
@end

@implementation XHKJIFenViewController

- (void)dealloc{
    detailView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    page=1;
    selectedIndex = 0;
    self.title = @"积分商城";
    XHJiFenView *jifen = (XHJiFenView *)ViewFromXib(@"CollectionCell", 1);
    [jifen.jiFenBtn addTarget:self action:@selector(jiFenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [jifen.liPinBtn addTarget:self action:@selector(liPinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jifen];
    
    myJifen    = (UILabel*)[jifen viewWithTag:101];
    myRenzheng = (UIImageView*)[jifen viewWithTag:102];
    
    NSString *jifenStr = [[NSUserDefaults standardUserDefaults] objectForKey:INTEGRAL];
    myJifen.text = [NSString stringWithFormat:@"我的积分：%@分",jifenStr];
    
    //广告图片
    self.adImageView = (UIImageView*)[jifen viewWithTag:4399];
    [self addADViewToHead];
    
    UITapGestureRecognizer  *tap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickADView)];
    self.adImageView.userInteractionEnabled = YES;
    [self.adImageView addGestureRecognizer:tap];
    
    CGRect frame = self.collectionView.frame;
    
    frame.origin.y = 185;
    frame.size.height = frame.size.height - 185 - 40;
    
    self.collectionView.frame = frame;
    self.collectionView.layer.contents = (__bridge id)([UIImage imageNamed:@"marketbg"].CGImage);
    
    [self.collectionView registerClass:[XHCollectionViewCell class] forCellWithReuseIdentifier:@"XHCollectionViewCell"];
    [self.collectionView registerClass:[BMMyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryCollectionCell"];
    WS(ws);
    MZTabView *tabView = [[MZTabView alloc]initWithTitles:@[@"实物礼品",@"学习资料"] blocks:@[^(id m){
        selectedIndex = 0;
        [self.dataSource removeAllObjects];
        [self.collectionView.legendHeader beginRefreshing];
    },^(id m){
        selectedIndex = 1;
        [self.dataSource removeAllObjects];
        [self.collectionView.legendHeader beginRefreshing];
    },]];
    [self.view addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.collectionView.mas_bottom);
        make.leading.trailing.bottom.equalTo(ws.view);
    }];
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        [ws.dataSource removeAllObjects];
        selectedIndex==0?[ws loadDataSource]:[ws loadStudyDataSource];
    }];
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        selectedIndex==0?[ws loadDataSource]:[ws loadStudyDataSource];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiRefresh:) name:@"RefreshGoods" object:nil];
    [self notiRefresh:nil];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [HYHelper mLoginID:^(id uid) {
        NSArray *keyValue = [MY_MEMEBERINFO_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[uid,uid,@1] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:MY_MEMEBERINFO_API
                                          withType:MY_MEMEBERINFO
                                           success:^(id responseObject)
         {
             self.profile = responseObject;
             [SVProgressHUD dismiss];
         }failure:^(id error){
             [SVProgressHUD dismiss];
         }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.tag = 9001;
    rightBarButton.frame = Rect(Main_Screen_Width-75, 10, 70, 25);
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"bar-btn"] forState:UIControlStateNormal];
    [rightBarButton setTitle:@"我的物品" forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = SYSTEMFONT(14);
    [rightBarButton addTarget:self action:@selector(myGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightBarButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    UIView *right = [self.navigationController.navigationBar viewWithTag:9001];
    [right removeFromSuperview];
    //[self.navigationController.navigationBar.layer displayIfNeeded];
}

- (void)notiRefresh:(NSNotification*)noti
{
    [self requestPersonalInformation];
    [self.collectionView.legendHeader beginRefreshing];
}

//请求用户信息
- (void)requestPersonalInformation
{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            NSArray*keyValue= [MY_MEMEBERINFO_PARAM componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[uid,uid,@1] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:dic
                                               withUrl:MY_MEMEBERINFO_API
                                              withType:MY_MEMEBERINFO
                                               success:^(id responseObject)
             {
                 self.myinforMationDic = [[NSDictionary alloc] initWithDictionary:responseObject];
                 myJifen.text = [NSString stringWithFormat:@"我的积分：%@分",[self.myinforMationDic objectForKey:@"integral"]];
                 NSInteger realname_status = [[self.myinforMationDic objectForKey:@"realname_status"] integerValue];
                 myRenzheng.image = [UIImage imageNamed:realname_status == 1?@"btn_certified":@"btn_unauthenticated"];
             }failure:^(id error){
                 [BMUtils showError:error];
             }];
        }
    }];
    
}

- (void)loadDataSource{
    
    NSArray *keyValue = [PRODUC_LIST_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[@(page),@(20),@(1)] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:PRODUC_LIST_API withType:PRODUC_LIST success:^(id responseObject){
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        [self.collectionView reloadData];
        page++;
        [self.collectionView.legendHeader endRefreshing];
        [self.collectionView.legendFooter endRefreshing];
    }failure:^(id error){
        [self.collectionView.legendHeader endRefreshing];
        [self.collectionView.legendFooter endRefreshing];
    }];
    
}

- (void)loadStudyDataSource{
    NSArray *keyValue = [PRODUC_LIST_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects:@[@(page),@(20),@(2)] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:PRODUC_LIST_API withType:PRODUC_LIST success:^(id responseObject){
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        [self.collectionView reloadData];
        page++;
        [self.collectionView.legendHeader endRefreshing];
        [self.collectionView.legendFooter endRefreshing];
    }failure:^(id error){
        [self.collectionView.legendHeader endRefreshing];
        [self.collectionView.legendFooter endRefreshing];
    }];
    [self.collectionView reloadData];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(110, 135);
}
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 28, 10, 20);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XHCollectionViewCell *cell = (XHCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XHCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = [[NSDictionary alloc] init];
    if (self.dataSource.count) {
        dic = self.dataSource[indexPath.row];
    }
    
    UIImageView *image = cell.contentView.subviews[1];
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UILabel *titleLabel = cell.contentView.subviews[2];
    UILabel *scoreLabel = cell.contentView.subviews[3];
    UIImageView *finshIMG = cell.contentView.subviews[5];
    UIImageView *hotIMG = cell.contentView.subviews[6];
    titleLabel.text = WYISBLANK(dic[@"title"]);
    scoreLabel.text = WYISBLANK(dic[@"integral"]);
    BOOL isFinsh = [WYISBLANK([dic objectForKey:@"rechargestatus"]) boolValue];
    finshIMG.hidden = !isFinsh;
    hotIMG.hidden = YES;
    if (finshIMG.hidden) {
        hotIMG.hidden = ![dic[@"ishot"]boolValue];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   [self detailDataSourceWithProid:[self.dataSource[indexPath.row][@"id"] intValue]];
    
}
- (void)quxiao:(UIButton *)btn{
    detailView.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)jiFenBtnClick:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate jifenClickZhuanjiFen];
}
-(void)liPinBtnClick:(UIButton*)btn
{
    XHShiMingRZViewController *control = [[XHShiMingRZViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

-(void)duihuan:(UIButton*)btn
{
    [self quxiao:nil];
    ApatrinViewController*vc=[[ApatrinViewController alloc]init];
    vc._IDStr= [NSString stringWithFormat:@"%d",self._id];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)myGoods:(UIButton*)btn//我的问题
{
    [self.navigationController pushViewController:[[XHMyWuPinViewController alloc]init] animated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)clickADView
{
    if (self.adDic == nil) return;
    [self pushNewViewController:[[xiangqingye alloc] initWithWID:[self.adDic[@"articleid"] intValue] title:@"积分商城"]];

}

- (void)addADViewToHead
{
    __weak XHKJIFenViewController *weakSelf = self;
    
    NSArray *keyValue = [AD_INFO_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:@"9"] forKeys:keyValue];
    
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:AD_INFO_API
                                      withType:AD_INFO
                                       success:^(id responseObject){
                                           
                                           if([responseObject isKindOfClass:[NSArray class]]) {
                                               
                                               NSDictionary *dic = [responseObject objectAtIndex:0];
                                               NSString *url = [IMAGE_ADDRESS stringByAppendingString:[dic objectForKey:@"image"]];
                                               [weakSelf.adImageView  setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                               self.adDic   = dic;
                                           }
                                       }failure:^(id error){
                                          [BMUtils showError:error];
                                       }];
}

- (void)detailDataSourceWithProid:(int)proid{
    //纪录id 兑换接口需要
    self._id=proid;
    NSArray *keyValue = [PRODUC_INFO_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(proid),nil] forKeys:keyValue];
    [SVProgressHUD showWithStatus:@"请求中..." maskType:SVProgressHUDMaskTypeBlack];
    [[NetManager sharedManager] myRequestParam:dic withUrl:PRODUC_INFO_API withType:PRODUC_INFO success:^(id responseObject){
        [SVProgressHUD dismiss];
        detailView = ViewFromXib(@"paihangbang", 2);
        detailView.frame = CGRectMake(0, 0, CGRectGetWidth(detailView.frame), CGRectGetHeight(detailView.frame));
        UIButton *btn = (UIButton *)[detailView viewWithTag:201];
        [btn addTarget:self action:@selector(quxiao:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btn2 = (UIButton *)[detailView viewWithTag:207];
        UIScrollView *scrollView = (UIScrollView*)[detailView viewWithTag:202];
        UILabel *pageLabel = (UILabel*)[detailView viewWithTag:199];
        scrollView.delegate = self;
        [self.view addSubview:detailView];
        NSDictionary *dicM = responseObject[0];
        NSArray *tmp = dicM[@"imglist"];
        NSMutableArray *imglist = [NSMutableArray array];
        if (tmp) {
            [tmp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                if ([obj stringByReplacingOccurrencesOfString:@"\"" withString:@""].length>0 ) {
                    [imglist addObject:obj];
                }
            }];
        }
        if (imglist.count==0) {
            [imglist addObject:dicM[@"thumb"]];
        }
        if(imglist.count>0){
            scrollView.info = @{@"PageLabel":pageLabel,@"currPage":@1,@"totals":@(imglist.count)};
            [self setPageWithLabel:pageLabel currPage:1 totals:imglist.count];
            UIView *lastView = nil;
            UIView *container = [UIView new];
            [scrollView addSubview:container];
            [container mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(scrollView);
                make.height.equalTo(scrollView);
            }];
            for (NSString *imgURL in imglist) {
                UIImageView *iv = [[UIImageView alloc]init];
                [iv setImageWithURL:IMG_URL(imgURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                [container addSubview:iv];
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(container);
                    make.width.equalTo(scrollView);
                    if (lastView) {
                        make.leading.equalTo(lastView.mas_trailing);
                    }else{
                        make.leading.equalTo(container.mas_leading);
                    }
                }];
                lastView = iv;
            }
            if (lastView) {
                [container mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(lastView.mas_trailing);
                }];
            }
        }else{
            scrollView.info = @{@"PageLabel":pageLabel,@"currPage":@0,@"totals":@0};
            [self setPageWithLabel:pageLabel currPage:0 totals:0];
        }
        UILabel *titleLabel = (UILabel *)[detailView viewWithTag:203];
        UILabel *scoreLabel = (UILabel *)[detailView viewWithTag:204];
        UILabel *tjLabel = (UILabel *)[detailView viewWithTag:205];
        UIWebView *contentLabel = (UIWebView *)[detailView viewWithTag:206];
        contentLabel.delegate = self;
        [contentLabel setOpaque:NO];
        UIImageView *finshImage = (UIImageView *)[detailView viewWithTag:410];
        UIImageView *hotImage = (UIImageView *)[detailView viewWithTag:411];
        titleLabel.text = WYISBLANK([dicM objectForKey:@"title"]);
        scoreLabel.text = WYISBLANK([dicM objectForKey:@"integral"]);
        NSString *rank = [NSString stringWithFormat:@"Lv %@ ", WYISBLANK([dicM objectForKey:@"rank"])];
        NSString *str = [[dicM objectForKey:@"type"]boolValue]?@"需认证":@"";
        tjLabel.text = [NSString stringWithFormat:@"%@%@",rank,str];
        [contentLabel loadHTMLString:[NSString stringWithFormat:@"<div style='word-break:break-all;'>%@</div>",dicM[@"content"]] baseURL:nil];
        BOOL isFinsh =  [dicM[@"rechargestatus"]boolValue];
        finshImage.hidden = !isFinsh;
        hotImage.hidden = YES;
        if (finshImage.hidden) {
            hotImage.hidden = ![dicM[@"ishot"]boolValue];
        }
        [btn2 addTarget:self action:@selector(duihuan:) forControlEvents:UIControlEventTouchUpInside];
        btn2.enabled = !isFinsh;
        // 兑换条件判断
        // 1、是否需要认证
        BOOL isCredit = [[dicM objectForKey:@"type"]boolValue];
        BOOL realname = [_profile[@"realname_status"]boolValue];
        NSInteger grade = [_profile[@"rank"]integerValue];
        NSInteger integal = [_profile[@"integral"]integerValue];
        [[btn2 viewWithTag:1000]removeFromSuperview];
        if ((isCredit && !realname) || grade<[dicM[@"rank"]integerValue]||integal<[dicM[@"integral"]integerValue]) {
            btn2.enabled = NO;
            NSString *tip = @"";
            if(integal<[dicM[@"integral"]integerValue]){
                tip = @"积分不足";
            } else if(grade<[dicM[@"rank"]integerValue]){
                tip = @"等级不够";
            } else if (isCredit && !realname) {
                tip = @"没有认证";
            }
            UILabel *l = [[UILabel alloc]init];
            l.tag = 1000;
            l.text = tip;
            l.textAlignment = NSTextAlignmentCenter;
            l.textColor = [UIColor whiteColor];
            l.font = SYSTEMFONT(12);
            l.layer.cornerRadius = 4.0f;
            l.backgroundColor = UIColorFromRGB(0x999999);
            [btn2 addSubview:l];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(btn2);
            }];
        }
        [self.collectionView reloadData];
    }failure:^(id error){
        [SVProgressHUD dismiss];
        [BMUtils showError:error];
    }];
    
}
- (void)setPageWithLabel:(UILabel*)label currPage:(NSInteger)currPage totals:(NSInteger)totals
{
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd/%zd",currPage,totals]];
    [mAttr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFD5C12)} range:NSMakeRange(0, [@(currPage)stringValue].length)];
    label.attributedText = mAttr;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currPage = scrollView.contentOffset.x/VWidth(scrollView)+1;
    NSInteger totals = [scrollView.info[@"totals"]integerValue];
    [self setPageWithLabel:scrollView.info[@"PageLabel"] currPage:currPage totals:totals];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#915E01'"];
}
@end
