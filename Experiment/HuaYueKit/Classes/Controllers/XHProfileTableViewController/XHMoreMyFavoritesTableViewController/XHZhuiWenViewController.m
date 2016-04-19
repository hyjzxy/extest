//
//  XHZhuiWenViewController.m
//  HuaYue
//
//  Created by lee on 15/1/12.
//
//

#import "XHZhuiWenViewController.h"
#import "XHContactTableViewCell.h"
#import "XHNewsTableViewController.h"

#import "UIButton+WebCache.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface XHZhuiWenViewController ()
{
    int page;
}

@end

@implementation XHZhuiWenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"追问我的";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    __weak XHZhuiWenViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
          [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

-(void)reloadMoreData{
    
    __weak XHZhuiWenViewController *weakMy = self;
    
    
    NSArray *keyValue = [MY_ASKSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_ASKSLIST_API withType:MY_ASKSLIST success:^(id responseObject){
        
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

- (void)loadDataSource{
    NSArray *keyValue = [MY_QUESTIONSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(1),@(5),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_QUESTIONSLIST_API withType:MY_QUESTIONSLIST success:^(id responseObject){
        //将登录信息保存本地
        NSLog(@"class%@", [responseObject class]);
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myzhuiwen";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = (XHContactTableViewCell *)ViewFromXib(@"MyTableViewCell", 8);
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:201];
    UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:202];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:203];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:204];
    UILabel *newContenLabel = (UILabel *)[cell viewWithTag:205];
    UILabel *levelLabel = (UILabel *)[cell viewWithTag:206];
    contentLabel.text = WYISBLANK(dic[@"content"]);
    nickNameLabel.text = WYISBLANK(dic[@"nickname"]);
    newContenLabel.text = WYISBLANK(dic[@"title"]);
    timeLabel.text =  N2V(dic[@"inputtime"], @"");
    [HYHelper mSetLevelLabel:levelLabel level:dic[@"rank"]];
    [headImage setImageWithURL:IMG_URL(dic[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = VHeight(headImage)*0.5;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.dataSource count];
    return self.dataSource.count;
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    /*XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    newsTableViewController.dic     = dic;
    newsTableViewController.strQID  = dic[@"qid"];
  */
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    
    answerListVC.qid = [dic[@"qid"]integerValue];
    answerListVC.chatFrom = kChatFromMyAddQuest;
    answerListVC.chatType = kAddQuestChat;
    [self pushNewViewController:answerListVC];
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
