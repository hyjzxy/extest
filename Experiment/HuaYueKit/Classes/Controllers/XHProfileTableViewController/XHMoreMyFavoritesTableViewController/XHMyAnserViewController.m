//
//  XHMyAnserViewController.m
//  HuaYue
//
//  Created by lee on 15/1/12.
//
//

#import "XHMyAnserViewController.h"
#import "XHContactTableViewCell.h"
#import "XHNewsTableViewController.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "MZAnswerChatVC.h"
#import "NSObject+Cate.h"

@interface XHMyAnserViewController ()
{
    int page;
}
@end

@implementation XHMyAnserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的回答";
    self.tableView.backgroundColor = [UIColor clearColor];
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    __weak XHMyAnserViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}
-(void)reloadMoreData{
    
    __weak XHMyAnserViewController *weakMy = self;
    
    
    NSArray *keyValue = [MY_ANSWERSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_ANSWERSLIST_API withType:MY_ANSWERSLIST success:^(id responseObject){
        
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
    static NSString *cellIdentifier = @"myanwser";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
        cell = (XHContactTableViewCell *)cellList[9];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    UILabel *titileLabel = (UILabel *)[cell viewWithTag:201];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:202];
    UILabel *markLabel = (UILabel *)[cell viewWithTag:203];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:204];
    UIButton *btn = (UIButton *)[cell viewWithTag:205];
    UIButton *adopt = (UIButton *)[cell viewWithTag:206];
    UILabel *newMsg = (UILabel *)[cell viewWithTag:207];
    btn.info = dic;
    [btn addTarget:self action:@selector(toChatAct:) forControlEvents:UIControlEventTouchUpInside];
    titileLabel.text = WYISBLANK(dic[@"title"]);
    timeLabel.text = N2V(dic[@"inputtime"], @"");
    markLabel.attributedText = [HYHelper mBuildLable:N2V(dic[@"lable"], @"") font:markLabel.font];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    contentLabel.attributedText = [HYHelper mBuildAnswer:N2V(dic[@"content"], @"") font:contentLabel.font userId:uid isAnswer:YES];
    adopt.hidden = ![dic[@"isadopt"]boolValue];
    NSInteger newreplay = [dic[@"newreply"]integerValue];
    NSString *newtime = N2V(dic[@"newtime"], @"");
    if (newreplay>0) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]init];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"（%zd条新消息）",newreplay] attributes:@{NSFontAttributeName:SYSTEMFONT(12),NSForegroundColorAttributeName:UIColorFromRGB(0xF03E1E)}]];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:newtime attributes:@{NSFontAttributeName:SYSTEMFONT(12),NSForegroundColorAttributeName:UIColorFromRGB(0x7F7F7F)}]];
        newMsg.attributedText = mAttr;
    }else{
        newMsg.text = @"";
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    answerListVC.qid = [dic[@"qid"]integerValue];
    answerListVC.chatFrom = kChatFromMyAnswer;
    [self pushNewViewController:answerListVC];

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
    chatVC.nickName = @"我";
    chatVC.chatType = kAnswerChat;
    chatVC.isAddQuest = chatVC.chatType ==kAddQuestChat;
    [self.navigationController pushViewController:chatVC animated:YES];
    
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
