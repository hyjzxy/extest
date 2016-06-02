//
//  XHMoreSettingTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMoreSettingTableViewController.h"
#import "XHProfileTableViewController.h"
#import "XHStoreManager.h"
#import "XHChangePswdViewController.h"
#import "XHChangeNickNameViewController.h"
#import "MessageSettingViewController.h"
#import "XHSSLoadViewController.h"
#import "XHBangDingMBViewController.h"
#import "XHAboutUsViewController.h"
#import "XHShiMingRZViewController.h"
#import "UMSocial.h"
#import "MZShare.h"
#import "UIAlertView+Block.h"
#import "MZHelpeVC.h"

@interface XHMoreSettingTableViewController ()<UMSocialUIDelegate>

@property(nonatomic, strong)NSString    *urlOpen;

@end

@implementation XHMoreSettingTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getSettingConfigureArray];
}

#pragma mark - Life cycle
- (void)initShareSdk{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString* zhushouId = [userDefault objectForKey:INVITATION];
    NSString *str = [NSString stringWithFormat:@"实验助手，实验室从业人员的专属社区，邀请码%@，赶快来加入我们吧！", zhushouId];
    [[MZShare shared]shareInVC:self title:str image:[UIImage imageNamed:@"share-logo"] url:APPSTOREURL block:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self configuraTableViewNormalSeparatorInset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.textLabel.text = [self.dataSource[indexPath.section][indexPath.row] valueForKey:@"title"];
    if(indexPath.section == 0 && indexPath.row == 1){
        cell.detailTextLabel.text = @"积分翻倍，尊享特权";
    } else{
        cell.detailTextLabel.text = @"";
    }
    return cell;
}
#pragma mark - UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                XHChangeNickNameViewController *control = [[XHChangeNickNameViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];

            }
                break;
            case 1:{
                XHShiMingRZViewController *control = [[XHShiMingRZViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];
            }
                break;
            case 2:{
                XHChangePswdViewController *control = [[XHChangePswdViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];
            }
                break;
            case 3:{
                MessageSettingViewController *control = [[MessageSettingViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                [self initShareSdk];
            }
                break;
            /*
            case 1:{
                XHSSLoadViewController *control = [[XHSSLoadViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];
            }*/
                break;
                            
            default:
                break;
        }

    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:{
                XHAboutUsViewController *control = [[XHAboutUsViewController alloc] init];
                [self.navigationController pushViewController:control animated:YES];
            }
                break;
            case 1:{
                MZHelpeVC *helpVC = [[MZHelpeVC alloc]init];
                NSString *path = [[NSBundle mainBundle]pathForResource:@"Help" ofType:@"plist"];
                [helpVC loadHelpPlistFile:path];
                helpVC.title  = @"帮助";
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 2:{//退出账号
                [[UIAlertView mBuildWithTitle:@"提示" msg:@"您确定要退出吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
                    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                    [userDefault removeObjectForKey:UID];
                    [userDefault setBool:NO forKey:@"IsAutoLogin"];
                    [userDefault synchronize];
                    if ([self.mydelegate respondsToSelector:@selector(didClickLoginOut)]) {
                        [self.mydelegate didClickLoginOut];
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wangyu" object:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }]show];
            }
                break;
                
            default:
                break;
        }
    }

}

@end
