//
//  XHMoreMyFavoritesTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreMyFavoritesTableViewController.h"
#import "XHContactTableViewCell.h"
#import "XHNewsTableViewController.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "Masonry.h"
#import "MJRefresh.h"
@interface XHMoreMyFavoritesTableViewController ()

@end

@implementation XHMoreMyFavoritesTableViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"我的提问";
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WS(ws);
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [ws loadDataSource];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        ws.pageNum = 1;
        [ws loadDataSource];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

- (void)loadDataSource{
    NSArray *keyValue = [MY_QUESTIONSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(self.pageNum),@(20),nil] forKeys:keyValue];
//personalquestion
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_QUESTIONSLIST_API withType:MY_QUESTIONSLIST success:^(id responseObject){
        if (self.pageNum==1) {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        self.pageNum++;
        [self.tableView reloadData];
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }failure:^(id error){
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyQeustCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = ViewFromXib(@"MyTableViewCell", 17);
    }
    UILabel *userName = (UILabel*)VIEWWITHTAG(cell, 101);
    UILabel *level = (UILabel*)VIEWWITHTAG(cell, 102);
    UIImageView *logImg = (UIImageView*)VIEWWITHTAG(cell, 103);
    UILabel *rewards = (UILabel*)VIEWWITHTAG(cell, 104);
    UIButton *resovle = (UIButton*)VIEWWITHTAG(cell, 105);
    UILabel *content = (UILabel*)VIEWWITHTAG(cell, 106);
    UILabel *supperlists = (UILabel*)VIEWWITHTAG(cell, 107);
    UILabel *label = (UILabel*)VIEWWITHTAG(cell, 108);
    UILabel *time = (UILabel*)VIEWWITHTAG(cell, 109);
    UILabel *asum  = (UILabel*)VIEWWITHTAG(cell, 110);
    UILabel *newMsg  = (UILabel*)VIEWWITHTAG(cell, 111);
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    userName.text = WYISBLANK([dic objectForKey:@"nickname"]);
    [HYHelper mSetLevelLabel:level level:dic[@"rank"]];
    time.text = N2V(dic[@"inputtime"], @"");
    if (!isEmptyDicForKey(dic, @"reward")) {
        UIFont *font  = rewards.font;
        NSString *reward = [NSString stringWithFormat:@"  %@分 ",WYISBLANK([dic objectForKey:@"reward"]) ];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"answer_M"];
        textAttach.bounds = CGRectMake(2, -1, font.pointSize, font.pointSize);
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:reward attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:rewards.textColor}];
        [contentAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:1];
        rewards.attributedText = contentAtt;
    }else{
        rewards.text = @"";
    }
    // 崔俊红 2015.03.31
    logImg.hidden = !([N2V(dic[@"image"],@"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0);
    resovle.hidden = [WYISBLANK([dic objectForKey:@"issolveed"]) isEqualToString:@"0"];
    BOOL istop = [dic[@"istop"]boolValue];
    if (istop) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:@"【置顶】" attributes:@{NSFontAttributeName:content.font,NSForegroundColorAttributeName:[UIColor redColor]}];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:WYISBLANK([dic objectForKey:@"content"])  attributes:@{NSFontAttributeName:content.font,NSForegroundColorAttributeName:content.textColor}]];
        content.attributedText = mAttr;
    }else{
        content.text = WYISBLANK([dic objectForKey:@"content"]);
    }
    rewards.layer.masksToBounds = YES;
    rewards.layer.borderWidth = 1;
    rewards.layer.borderColor = [UIColor colorWithWhite:0.741 alpha:0.290].CGColor;
    rewards.layer.cornerRadius = VHeight(rewards)/2;
    label.attributedText = [HYHelper mBuildLable:dic[@"lable"] font:label.font];
    id superlist  = dic[@"superlist"];
    supperlists.text = [superlist isEqualToString:@"null"]||!superlist||[superlist length]<=0?@"":[NSString stringWithFormat:@"邀请%@回答",superlist];
    asum.text = [NSString stringWithFormat:@"%@人回答",WYISBLANK([dic objectForKey:@"anum"])];
    
    // 布局 LogImg reward checkbtn
    if(resovle.hidden){
        [resovle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
        }];
    }else{
        [resovle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@46);
        }];
    }
    
    NSInteger newreplay = [dic[@"newreply"]integerValue];
    NSString *newtime = dic[@"newtime"];
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
    return [self.dataSource count];
}
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    answerListVC.qid = [dic[@"id"]integerValue];
    answerListVC.chatFrom = kChatFromMyQuest;
    [self pushNewViewController:answerListVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
