//
//  XHNyActiviyViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNyActiviyViewController.h"
#import "XHStoreManager.h"
#import "UIImageView+WebCache.h"
#import "HYBannerView.h"
#import "Masonry.h"

@interface XHNyActiviyViewController ()<HYBannerViewDataSource,HYBannerViewDelegate>
{
    HYBannerView *bannerView;
    NSMutableArray *imgAry;
    UIView *view;
    UIView *topView;
    UISearchBar *search;
    int page;
}
@property (nonatomic,strong) NSMutableArray *bannerDS;
@end

@implementation XHNyActiviyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动中心";
    
    self.bannerDS  = [[NSMutableArray alloc] init];
    
    UIView *headerView = [[UIView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 0)];
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    bannerView = [[HYBannerView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 160)];
    bannerView.dataSource = self;
    bannerView.delegate  = self;
    self.tableView.tableHeaderView = bannerView;
    [self addADViewToHead];
    page = 1;
    [self configuraTableViewNormalSeparatorInset];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加上拉加载更多
    __weak XHNyActiviyViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}
-(void)reloadMoreData{
    __weak XHNyActiviyViewController *weakMy = self;
    NSArray *keyValue = [FIND_ACT_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_ACT_API withType:FIND_ACT success:^(id responseObject){
        if (page == 1) {
            [weakMy.dataSource removeAllObjects];
            [weakMy.dataSource addObjectsFromArray:responseObject];
        }else {
            [weakMy.dataSource addObjectsFromArray:responseObject];
        }
        page++;
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }failure:^(id error){
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }];
}

- (void)reloadData
{
    page = 1;
    [self reloadMoreData];
}

#pragma mark - HYBannerViewDataSource
- (NSArray*)bannerDatas
{
    return _bannerDS;
}
#pragma mark - HYBannerViewDelegate
- (void)bannerView:(id)bannerView selectedData:(NSInteger)index
{
    NSDictionary *dic   = _bannerDS[index];
    [self pushNewViewController:[[xiangqingye alloc] initWithWID:[dic[@"articleid"] intValue] title:@"活动中心"]];
}

-(void)buildImageView:(UIImageView *)imageView index:(NSInteger)index
{
    NSDictionary *dic = self.bannerDS[index];
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

- (void)addADViewToHead{
    __weak XHNyActiviyViewController *weakSelf = self;
    NSArray *keyValue = [AD_INFO_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObject:@"8"] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:AD_INFO_API
                                      withType:AD_INFO
                                       success:^(id responseObject){
                                           [weakSelf.bannerDS removeAllObjects];
                                           [weakSelf.bannerDS addObjectsFromArray:responseObject];
                                           imgAry = [[NSMutableArray alloc] init];
                                           for(NSDictionary *dic in weakSelf.bannerDS){
                                               NSString *url = [IMAGE_ADDRESS stringByAppendingString:[dic objectForKey:@"image"]];
                                               [imgAry addObject:url];
                                           }
                                           [bannerView reloadData];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
}

- (NSString *)lastUpdateTimeString {
    NSDate *nowDate = [NSDate date];
    NSString *destDateString = [nowDate timeAgo];
    return destDateString;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

#pragma mark - UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [[NSDictionary alloc] init];
    if (self.dataSource.count) {
        dic = self.dataSource[indexPath.row];
    }

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
        
        cell = cellList[1];
        
    }
    UIImageView *image = cell.contentView.subviews[0];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] placeholderImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage.png"]];
    UILabel *titleLabel = cell.contentView.subviews[1];
    titleLabel.text = WYISBLANK(dic[@"title"]);
    
    UILabel *timeLabel = cell.contentView.subviews[2];
    NSString *timeStr = WYISBLANK([BMUtils getDateByStringOld:[dic objectForKey:@"inputtime"]]);
    timeLabel.text = timeStr;
    return cell;
}

#pragma markr - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataSource[indexPath.row];
    [self pushNewViewController:[[xiangqingye alloc] initWithWID:[dic[@"id"] intValue] title:@"活动中心"]];
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
