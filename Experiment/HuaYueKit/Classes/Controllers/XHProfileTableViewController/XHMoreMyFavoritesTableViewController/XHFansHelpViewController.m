//
//  XHFansHelpViewController.m
//  HuaYue
//
//  Created by lee on 15/1/12.
//
//

#import "XHFansHelpViewController.h"
#import "XHContactTableViewCell.h"
#import "SBJsonParser.h"
#import "UIButton+WebCache.h"
#import "XHNewsTableViewController.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "Masonry.h"
#import "NSObject+Cate.h"

@interface XHFansHelpViewController ()
{
    int page;
}
@end

@implementation XHFansHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粉丝求助";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    __weak XHFansHelpViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}
-(void)reloadMoreData{
    
    __weak XHFansHelpViewController *weakMy = self;
    
    
    NSArray *keyValue = [MY_FANSSLIST_NEW_PARAM componentsSeparatedByString:@","];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_FANSSLIST_NEW_API withType:MY_FANSSLIST_NEW success:^(id responseObject){
        
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
- (void)loadDataSource{
    NSArray *keyValue = [MY_FANSSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(1),@(5),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_FANSSLIST_API withType:MY_FANSSLIST success:^(id responseObject){
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

- (void)toPerson:(UIButton*)sender
{
    NSIndexPath *indexPath = sender.info[@"IndexPath"];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [HYHelper pushPersonCenterOnVC:self uid:[dic[@"uid"]intValue]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactTableViewCellIdentifier";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = (XHContactTableViewCell *)ViewFromXib(@"MyTableViewCell", 0);
    }
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    [cell.headBtn addTarget:self action:@selector(toPerson:) forControlEvents:UIControlEventTouchUpInside];
    cell.headBtn.info = @{@"IndexPath":indexPath};
    cell.headBtn.arrayIndex = indexPath.row;
    [HYHelper mSetLevelLabel:cell.level level:dic[@"rank"]];
    cell.userName.text = WYISBLANK([dic objectForKey:@"nickname"]);
    cell.time.text = N2V(dic[@"inputtime"], @"");
    cell.tipImageView.hidden = YES;
    if (!isEmptyDicForKey(dic, @"reward")) {
        UIFont *font  = cell.reward.font;
        NSString *reward = [NSString stringWithFormat:@"  %@分 ",WYISBLANK([dic objectForKey:@"reward"]) ];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"answer_M"];
        textAttach.bounds = CGRectMake(2, -1, font.pointSize, font.pointSize);
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:reward attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:cell.reward.textColor}];
        [contentAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:1];
        cell.reward.attributedText = contentAtt;
    }else{
        cell.reward.text = @"";
    }
    // 崔俊红 2015.03.31
    cell.logImg.hidden = !([N2V(dic[@"image"],@"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0);
    cell.checkBtn.hidden = [WYISBLANK([dic objectForKey:@"issolveed"]) isEqualToString:@"0"];
    cell.content.text = WYISBLANK([dic objectForKey:@"content"]);
    cell.reward.layer.masksToBounds = YES;
    cell.reward.layer.borderWidth = 1;
    cell.reward.layer.borderColor = [UIColor colorWithWhite:0.741 alpha:0.290].CGColor;
    cell.reward.layer.cornerRadius = VHeight(cell.reward)/2;
    [cell.huidaIMG setImage:[UIImage imageNamed:[dic[@"isanswer"]boolValue]?@"huida":@"unhuida"]];
    NSString* label = WYISBLANK([dic objectForKey:@"lable"]);
    cell.label.text = [label stringByReplacingOccurrencesOfString:@" " withString:@"/"];
    [cell.label makeRoundCornerWithRadius:2];
    
    CGSize sizeEng = XZ_MULTILINE_TEXTSIZE(cell.label.text, [UIFont systemFontOfSize:10], CGSizeMake(SCREENWIDTH, 20), NSLineBreakByWordWrapping);
    [cell.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeEng.width+10));
    }];
    [cell.label setColorWithText:cell.label.text];
    id superlist  = dic[@"superlist"];
    cell.gaoShou.text = [superlist isEqualToString:@"null"]||!superlist||[superlist length]<=0?@"":[NSString stringWithFormat:@"邀请%@回答",superlist];
    [HYHelper mSetVImageView:cell.head v:dic[@"type"] head:cell.headBtn];
    cell.count.text = [NSString stringWithFormat:@"%@",WYISBLANK([dic objectForKey:@"anum"])];
    if(cell.checkBtn.hidden){
        [cell.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
        }];
    }else{
        [cell.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@46);
        }];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [self.dataSource count];
    return  self.dataSource.count;
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    answerListVC.qid = [dic[@"id"]integerValue];
    answerListVC.chatFrom = kChatFromWaitAnswer;
    [self pushNewViewController:answerListVC];
}
@end
