//
//  systemViewController.m
//  HuaYue
//
//  Created by lee on 15/1/23.
//
//

#import "systemViewController.h"

@interface systemViewController ()
{
    int page;

}
@end

@implementation systemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    __weak systemViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.title = @"系统消息";
    // Do any additional setup after loading the view.
}
-(void)reloadMoreData{
    __weak systemViewController *weakMy = self;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *keyValue = [MY_MESSAGE_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID], [NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_MESSAGE_API
                                      withType:MY_MESSAGE
                                       success:^(id responseObject){
                                       if (page == 1) [weakMy.dataSource removeAllObjects];
                                        [weakMy.dataSource addObjectsFromArray:responseObject];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"systemmessage"];
    if (!cell) {
        cell = ViewFromXib(@"MyTableViewCell", 14);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic   =   self.dataSource[indexPath.row];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *descLabel = (UILabel *)[cell viewWithTag:103];
    UIImageView *logo = (UIImageView*)[cell viewWithTag:104];
    titleLabel.text  = dic[@"description"];
    timeLabel.text  = N2V(dic[@"inputtime"], @"");
    descLabel.text  = dic[@"content"];
    logo.image = [UIImage imageNamed:[NSString stringWithFormat:@"noti-%@",dic[@"valname"]]];
    return cell;
}

@end
