//
//  MessageSettingViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "MessageSettingViewController.h"
#import "NSObject+Cate.h"

@interface MessageSettingViewController ()
@property(nonatomic, strong) NSArray *labelArray;
@end

@implementation MessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息设置";
    self.labelArray = @[@"活动推送", @"回答我的",@"回答被采纳",@"讨论/追问",@"系统消息",@"粉丝求助"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"XHMoreMyFavoritesTableViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"settingView" owner:nil options:nil];
        cell = cellList[4];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:201];
    UISwitch *witch = (UISwitch*)[cell viewWithTag:666];
    witch.info  = @{@"index":@(indexPath.row)};
    [witch addTarget:self action:@selector(switchAct:) forControlEvents:UIControlEventValueChanged];
    label.text = self.labelArray[indexPath.row];
    return cell;
}

- (void)switchAct:(UISwitch*)sw
{
    NSInteger index = [sw.info[@"index"]integerValue];
    if (sw.on) {
        
    }
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
