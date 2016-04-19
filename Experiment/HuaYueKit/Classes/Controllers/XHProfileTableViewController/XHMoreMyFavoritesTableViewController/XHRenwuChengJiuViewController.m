//
//  XHRenwuChengJiuViewController.m
//  HuaYue
//
//  Created by lee on 15/1/12.
//
//

#import "XHRenwuChengJiuViewController.h"
#import "XHContactTableViewCell.h"
#import "UIImage+DD.h"
@interface XHRenwuChengJiuViewController ()
{
    int page;
    UIButton *daylogin;
    UIButton *dayquestion;
    UIButton *dayanswer;
    
}

@end

@implementation XHRenwuChengJiuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务成就";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    //添加上拉加载更多
//    __weak XHRenwuChengJiuViewController *blockSelf = self;
//    
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        NSLog(@"上拉刷新");
//        //使用GCD开启一个线程，使圈圈转2秒
//        int64_t delayInSeconds = .5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            
////            [blockSelf reloadMoreData];
//            
//        });
//    }];
//    //添加下拉刷新
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        NSLog(@"下拉更新");
//        //使用GCD开启一个线程，使圈圈转2秒
//        int64_t delayInSeconds = .5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            
//            [blockSelf reloadData];
//            
//        });
//    }];
//    
//    [self.tableView triggerPullToRefresh];


    // Do any additional setup after loading the view.
}

- (void)reloadData
{
    page = 1;
    
//    [self reloadMoreData];
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
        //        [scrollView removeFromSuperview];
        
        //        [self configuraTableViewNormalSeparatorInset];
        
        
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
        
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myrenwuchengjiu";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
        
        cell = (XHContactTableViewCell *)cellList[11];
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:901];
    
    UIButton *lingquBtn = (UIButton *)[cell viewWithTag:902];
    [lingquBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    switch (indexPath.row) {
        case 0:{
            titleLabel.text = @"每日登入";
            daylogin = lingquBtn;
            [lingquBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 1:{
            titleLabel.text = @"每日提问";
            dayquestion = lingquBtn;
            [lingquBtn addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;

        case 2:{
            titleLabel.text = @"每日采纳";
            dayanswer = lingquBtn;
            [lingquBtn addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)clickBtn:(UIButton *)sender{
    
        NSArray *keyValue = [LIN_Qu_PARAM componentsSeparatedByString:@","];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@"daylogin",nil] forKeys:keyValue];
        
        [[NetManager sharedManager] myRequestParam:dic withUrl:LIN_QU_API withType:LIN_QU success:^(id responseObject){
            //将登录信息保存本地
            daylogin.enabled = NO;
        }failure:^(id error){
            [BMUtils showError:error];
        }];
        

}
- (void)clickBtn1:(UIButton *)sender{
    
    NSArray *keyValue = [LIN_Qu_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@"dayquestion",nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:LIN_QU_API withType:LIN_QU success:^(id responseObject){
        //将登录信息保存本地
        dayquestion.enabled = NO;
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
    
}

- (void)clickBtn2:(UIButton *)sender{
    
    NSArray *keyValue = [LIN_Qu_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@"dayanswer",nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:LIN_QU_API withType:LIN_QU success:^(id responseObject){
        dayanswer.enabled = NO;
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [self.dataSource count];
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, 30)];
//    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].applicationFrame.size.width, 30)];
    label.text = @"每天任务";
    label.font = [UIFont systemFontOfSize:13.f];
    [view addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    
    //    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    //    newsTableViewController.dic = dic;
    //    [self pushNewViewController:newsTableViewController];
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
