//
//  XHLawViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHLawViewController.h"
#import "MyLabel.h"
#import "XHStoreManager.h"
#import "UIImageView+WebCache.h"

#import "xiangqingye.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "HYHelper.h"
@interface XHLawViewController ()<UISearchBarDelegate>
{
    CGFloat headerHeight;
    UISearchBar *search;
    int page;
}

@property (nonatomic,assign) int searchPage;    //搜索数据页码

@property (nonatomic,assign) BOOL    isSearch;//是否是搜索数据

@end

@implementation XHLawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headerHeight = 70;
    self.title = @"法规文献";
    
//    [self configuraTableViewNormalSeparatorInset];
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    __weak XHLawViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if (blockSelf.isSearch) {
            [blockSelf requestSearchData];
        }else {
            [blockSelf reloadMoreData];
        }
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        if (blockSelf.isSearch) {
            blockSelf.searchPage  = 1;
            [blockSelf requestSearchData];
        }else {
            [blockSelf reloadData];
        }
    }];
    [self.tableView.legendHeader beginRefreshing];
    
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 82)];
    back.backgroundColor = RGBCOLOR(240, 240, 240);
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 34)];
    search.delegate             = self;
    search.placeholder          = @"搜索";
    [back addSubview:search];
    UIView *tsView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, Main_Screen_Width, 48)];
    [back addSubview:tsView];
    [tsView mTSWithType:kTSFGWX];
    tsView.info = @{@"CALL":^(){
        CGRectSetHeight(back, 34);
        self.tableView.tableHeaderView = back;
    }};
    headerHeight = VHeight(back);
    self.tableView.tableHeaderView = back;
    
}

-(void)reloadMoreData{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            NSArray *keyValue = [FIND_XIAN_PARAM componentsSeparatedByString:@","];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],uid,nil] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_XIAN_API withType:FIND_XIAN success:^(id responseObject){
                if (page == 1) [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:responseObject];
                page++;
                [self.tableView reloadData];
                [self.tableView.legendHeader endRefreshing];
                [self.tableView.legendFooter endRefreshing];
            }failure:^(id error){
                [self.tableView reloadData];
                [self.tableView.legendHeader endRefreshing];
                [self.tableView.legendFooter endRefreshing];
            }];
        }
    }];
}

- (void)reloadData
{
    page = 1;
    [self reloadMoreData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [search resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 56;
}


- (void)loadDataSource{

}
//- (void)loadDataSource {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableArray *dataSource = [[NSMutableArray alloc] initWithObjects:@"请问你现在在哪里啊？我在广州天河", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点进入聊天页面，这里有多种显示样式", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点进入聊天页面，这里有多种显示样式", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", @"点击我查看最新消息，里面有惊喜哦！", nil];
//        
//        NSMutableArray *indexPaths;
//        if (self.requestCurrentPage) {
//            indexPaths = [[NSMutableArray alloc] initWithCapacity:dataSource.count];
//            [dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [indexPaths addObject:[NSIndexPath indexPathForRow:self.dataSource.count + idx inSection:0]];
//            }];
//        }
//        sleep(1.5);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.requestCurrentPage) {
//                if (self.requestCurrentPage == arc4random() % 10) {
//                    [self handleLoadMoreError];
//                } else {
//                    
//                    [self.dataSource addObjectsFromArray:dataSource];
//                    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                    [self endLoadMoreRefreshing];
//                }
//            } else {
//                
//                self.dataSource = dataSource;
//                [self.tableView reloadData];
//                [self endPullDownRefreshing];
//            }
//        });
//    });
//}

- (NSString *)lastUpdateTimeString {
    
    NSDate *nowDate = [NSDate date];
    
    NSString *destDateString = [nowDate timeAgo];
    
    return destDateString;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 别把这行代码放到别处，然后导致了错误，那就不好了嘛！
//    [self startPullDownRefreshing];
}
#pragma mark - UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
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
    [self pushNewViewController:[[xiangqingye alloc] initWithWID:[dic[@"id"] intValue] title:@"法规文献"]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark # UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length <= 0) return;
    [self.view endEditing:YES];
    self.isSearch   = YES;
    self.searchPage = 1;
    [self requestSearchData];
}

- (void)requestSearchData
{
    if (search.text.length <= 0) return;
    
    __weak XHLawViewController *weakMy = self;

    NSArray     *keyValue   = [FIND_SEARCH_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(self.searchPage),@20,@6,search.text] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:FIND_SEARCH_API
                                      withType:FIND_SEARCH
                                       success:^(id responseObject) {
                                           if (weakMy.searchPage == 1)[weakMy.dataSource removeAllObjects];
                                        [weakMy.dataSource addObjectsFromArray:responseObject];
                                           weakMy.searchPage++;
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                           [weakMy.tableView.legendFooter endRefreshing];
                                       }failure:^(id error){
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                           [weakMy.tableView.legendFooter endRefreshing];
                                           [BMUtils showError:@"没有搜索到相应的结果"];
                                       }];
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
