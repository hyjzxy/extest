//
//  XHPaiHangBanViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHPaiHangBanViewController.h"
#import "UIImage+DD.h"
#import "XHShaiXuanView.h"
#import "UIButton+WebCache.h"
#import "XHMyButton.h"
#import "XHMyselfViewController.h"
#import "HYHelper.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
@interface XHPaiHangBanViewController (){
    int selectedIndex;
    int page;
    XHShaiXuanView *_topTableView;
    UIView *bottnSelectd0;
    UIView *bottnSelectd1;
    UIImageView *buttonBg;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIButton *back;
}
@property(nonatomic, strong)UIButton *btn1;
@property(nonatomic, strong)UIButton *btn2;
@property(nonatomic, strong)UIButton *btn3;

@property (nonatomic,assign)int isFistBtn;
@end

@implementation XHPaiHangBanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"paihangbang" owner:self options:nil][3];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
    view.layer.borderColor = UIColorFromRGB(0x75C7FA).CGColor;
    view.layer.borderWidth = 1.0f;
    UIButton *btn1 = (UIButton *)[view viewWithTag:201];
    UIButton *btn2 = (UIButton *)[view viewWithTag:202];
    UIButton *btn3 = (UIButton *)[view viewWithTag:203];
    
    btn1.layer.borderColor = UIColorFromRGB(0x75C7FA).CGColor;
    btn1.layer.borderWidth = 0.5f;
    
    btn2.layer.borderColor = UIColorFromRGB(0x75C7FA).CGColor;
    btn2.layer.borderWidth = 0.5f;
    
    btn3.layer.borderColor = UIColorFromRGB(0x75C7FA).CGColor;
    btn3.layer.borderWidth = 0.5f;
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;
    selectedIndex = 0;
    btn1.selected = YES;
    [btn1 addTarget:self action:@selector(titleViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(titleViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(titleViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = view;
    self.title = @"排行榜";
    page = 1;
    self.isFistBtn = 1;
    buttonBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [buttonBg setUserInteractionEnabled:YES];
    [self.view addSubview:buttonBg];
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,  160,  35)];
    [leftBtn setTitle:@"本周排行" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn.titleLabel setFont:BOLDSYSTEMFONT(14.0)];
    [leftBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [leftBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    [buttonBg addSubview:leftBtn];
    //#67B4D4
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 0,  160,  35)];
    [rightBtn setTitle:@"总排行" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [rightBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:BOLDSYSTEMFONT(14)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBg addSubview:rightBtn];
    
    bottnSelectd0 = [[UIView alloc]initWithFrame:CGRectMake(0, 31,  160,  4)];
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1 = [[UIView alloc]initWithFrame:CGRectMake(160, 31,  160,  4)];
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    [buttonBg addSubview:bottnSelectd0];
    [buttonBg addSubview:bottnSelectd1];
    
    
    CGRect frame = self.tableView.frame;
    frame.origin.y = 35;
    frame.size.height = frame.size.height - 35;
    
    self.tableView.frame = frame;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    __weak XHPaiHangBanViewController *blockSelf = self;
    /*[self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];*/
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    CGRect tableViewFrame = self.view.bounds;
    
    back = [[UIButton alloc] initWithFrame:tableViewFrame];
    back.backgroundColor = RGBACOLOR(100, 100, 100, .7);
    [back addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
    _topTableView = list[6];
    [back addSubview:_topTableView];
    [self.tabBarController.view addSubview:back];
    [self.tabBarController.view bringSubviewToFront:back];
    back.alpha = 0;
    [self.tableView.legendHeader beginRefreshing];
}

-(void)titleViewBtnClick:(UIButton *)sender{
    if (sender.tag == 201) {
        selectedIndex = 0;
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
    }else if(sender.tag == 202){
        selectedIndex = 1;
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
    }else{
        selectedIndex = 2;
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;

    }
    [self reloadMoreData];
}

-(void)leftBtnClick:(id)sender
{
    self.isFistBtn =1;
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    [self.dataSource removeAllObjects];
    [self reloadMoreData];
    
}

-(void)rightBtnClick:(id)sender
{
    bottnSelectd0.backgroundColor = UIColorFromRGB(0xDBDADA);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0x00A6F4);
    self.isFistBtn =0;
    [self reloadMoreData];
    
    
}

-(void)reloadMoreData{
    
    if (selectedIndex == 0) {
        [self reloadZJData];
    }else if (selectedIndex == 1){
        [self reloadHDData];
    }else{
        [self reloadZSData];
    }
}

- (void)reloadZJData{
    __block id uid = @0;
    [HYHelper mLoginID:^(id userId) {
        if (userId) {
            uid = userId;
        }
    }];
    NSArray *keyValue = [ZJ_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:uid, @(self.isFistBtn),nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:ZJ_API withType:ZJ success:^(id responseObject){
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }failure:^(id error){
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }];
}

- (void)reloadHDData{
    __block id uid = @0;
    [HYHelper mLoginID:^(id userId) {
        if (userId) {
            uid = userId;
        }
    }];
    NSArray *keyValue = [HD_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:uid, @(self.isFistBtn),nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:HD_API withType:HD success:^(id responseObject){
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }failure:^(id error){
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }];
}

- (void)reloadZSData{
    __block id uid = @0;
    [HYHelper mLoginID:^(id userId) {
        if (userId) {
            uid = userId;
        }
    }];
    NSArray *keyValue = [ZS_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:uid, @(self.isFistBtn),nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:ZS_API withType:ZS success:^(id responseObject){
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }failure:^(id error){
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
    }];

}
- (void)reloadData
{
    page = 1;
    [self reloadMoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count - 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 98;
    }else{
        return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"paihangbangcell"];
    if (indexPath.row == 0) {
        UITableViewCell *cell = ViewFromXib(@"paihangbang", 0);
        XHMyButton *headImage1 = (XHMyButton *)[cell viewWithTag:501];
        XHMyButton *headImage2 = (XHMyButton *)[cell viewWithTag:502];
        XHMyButton *headImage3 = (XHMyButton *)[cell viewWithTag:503];
        
        [headImage1 addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
        headImage1.arrayIndex = 0;
        
        [headImage2 addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
        headImage2.arrayIndex = 1;
        
        [headImage3 addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
        headImage3.arrayIndex = 2;
        
        
        UILabel *nickName1 = (UILabel *)[cell viewWithTag:504];
        UILabel *campName1 = (UILabel *)[cell viewWithTag:505];
        UILabel *nickName2 = (UILabel *)[cell viewWithTag:506];
        UILabel *campName2 = (UILabel *)[cell viewWithTag:507];
        UILabel *nickName3 = (UILabel *)[cell viewWithTag:508];
        UILabel *campName3 = (UILabel *)[cell viewWithTag:509];
        UIImageView *iv1 = (UIImageView *)[cell viewWithTag:510];
        UIImageView *iv2 = (UIImageView *)[cell viewWithTag:511];
        UIImageView *iv3 = (UIImageView *)[cell viewWithTag:512];
        
        [HYHelper mSetVImageView:iv1 v:self.dataSource[0][@"type"] head:headImage1];
        [HYHelper mSetVImageView:iv2 v:self.dataSource[1][@"type"] head:headImage2];
        [HYHelper mSetVImageView:iv3 v:self.dataSource[2][@"type"] head:headImage3];
        
        
        [headImage1 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dataSource[0] objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        
        [headImage2 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dataSource[1] objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        
        [headImage3 sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dataSource[2] objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];

        NSString *str1 = [NSString stringWithFormat:@"%@ Lv%@", WYISBLANK(self.dataSource[0][@"nickname"]), N2V(self.dataSource[0][@"rank"], @"0")];
        
        NSString *str2 = [NSString stringWithFormat:@"%@ Lv%@", WYISBLANK(self.dataSource[1][@"nickname"]), N2V(self.dataSource[1][@"rank"], @"0")];
        
        NSString *str3 = [NSString stringWithFormat:@"%@ Lv%@", WYISBLANK(self.dataSource[2][@"nickname"]), N2V(self.dataSource[2][@"rank"], @"0")];
        
        nickName1.text = str1;
        nickName2.text = str2;
        nickName3.text = str3;
        
        campName1.text = self.dataSource[0][@"num"];
        campName2.text = self.dataSource[1][@"num"];
        campName3.text = self.dataSource[2][@"num"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (!cell) {
        cell = ViewFromXib(@"paihangbang", 1);
    }
    UILabel *xuhaoLabel = (UILabel *)[cell viewWithTag:601];
    UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:603];
    UILabel *campLabel = (UILabel *)[cell viewWithTag:604];
    UILabel *numLabel = (UILabel *)[cell viewWithTag:605];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:606];
    UILabel *level = (UILabel *)[cell viewWithTag:607];
    UIImageView *typeIV = (UIImageView*)[cell viewWithTag:608];
    if (selectedIndex == 0) {
        contentLabel.text = @"被采纳数";
    }else if (selectedIndex == 1){
        contentLabel.text = @"回答数";
    }else{
        contentLabel.text = @"邀请数";
    }
   
    NSDictionary *data = self.dataSource[indexPath.row+2];
    XHMyButton *headBtn = (XHMyButton *)[cell viewWithTag:602];
    [headBtn addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.arrayIndex = indexPath.row+2;
    xuhaoLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row+3];
    nickNameLabel.text = WYISBLANK(self.dataSource[indexPath.row+2][@"nickname"]);
    campLabel.text = WYISBLANK(self.dataSource[indexPath.row+2][@"company"]);
    numLabel.text = [NSString stringWithFormat:@"%d", [self.dataSource[indexPath.row+2][@"num"] intValue]];
    NSString *le = @"0";
    if ([data.allKeys containsObject:@"rank"]) {
        le = data[@"rank"];
    }
    [HYHelper mSetLevelLabel:level level:N2V(le,@"0")];
    [HYHelper mSetVImageView:typeIV v:data[@"type"] head:headBtn];
    [headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dataSource[indexPath.row+2] objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    headBtn.layer.masksToBounds = YES;
    headBtn.layer.cornerRadius = MAX(VWidth(headBtn), VHeight(headBtn))*0.5;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)gointoInformationWith:(XHMyButton *)sender Index:(int)index{
    [HYHelper pushPersonCenterOnVC:self uid:[self.dataSource[sender.arrayIndex][@"id"] intValue]];
}

@end
