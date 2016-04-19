//
//  XHDiscoverTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHDiscoverTableViewController.h"

#import "XHMyNewsViewController.h"
#import "XHShiYanViewController.h"
#import "XHLawViewController.h"
#import "XHNyActiviyViewController.h"
#import "XHBrandCuViewController.h"
#import "XHPeiXunViewController.h"
#import "XHKJIFenViewController.h"
#import "XHPaiHangBanViewController.h"
#import "XHFeedBackViewController.h"
#import "XHStoreManager.h"
#import "HYHelper.h"

#import "AppDelegate.h"
#import "UIViewController+Cate.h"

@interface XHDiscoverTableViewController ()<jifenDelegate>

@end

@implementation XHDiscoverTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getDiscoverConfigureArray];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarController.title = @"发现";
    
    [self configuraTableViewNormalSeparatorInset];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"NOTI" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NOTI" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.title = @"发现";
    
//    self.tabBarController.navigationItem.leftBarButtonItem.title = @"";
//    self.tabBarController.navigationItem.rightBarButtonItem.title = @"";
}

-(void)clickedLeftAction{
    XHFeedBackViewController *control = [[XHFeedBackViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

-(void)clickedBarButtonItemAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row < self.dataSource.count) {
        NSArray *datas = self.dataSource[indexPath.section];
        cell.imageView.image = [UIImage imageNamed:datas[indexPath.row][@"image"]];
        NSMutableAttributedString *mAtts = [[NSMutableAttributedString alloc]initWithString:datas[indexPath.row][@"title"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [mAtts appendAttributedString:[[NSAttributedString alloc] initWithString:[@"  " stringByAppendingString:datas[indexPath.row][@"subTitle"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}]];
        cell.textLabel.attributedText = mAtts;
    }
    
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);

    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (delegate.tabbarView.dNum > 0) {
                cell.accessoryView =  [self accessLabel:delegate.tabbarView.dNum];
            }
        }else if (indexPath.row == 1)
        {
            if (delegate.tabbarView.wNum > 0) {
                cell.accessoryView =  [self accessLabel:delegate.tabbarView.wNum];
            }
        }else if (indexPath.row == 2)
        {
            /*
            if (delegate.tabbarView.nNum) {
                cell.accessoryView = [self accessLabel:delegate.tabbarView.nNum];
            }*/
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            if (delegate.tabbarView.pNum > 0) {
                cell.accessoryView = [self accessLabel:delegate.tabbarView.pNum];
            }
        }else if (indexPath.row == 1)
        {
            /*if (delegate.tabbarView.bNum) {
                cell.accessoryView = [self accessLabel:delegate.tabbarView.bNum];
            }*/
        }else if (indexPath.row == 2)
        {
            if (delegate.tabbarView.tNum > 0) {
                cell.accessoryView = [self accessLabel:delegate.tabbarView.tNum];
            }
        }
    }else if (indexPath.section == 2)
    {
        
    }
    
    return cell;
}

#pragma markr - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    switch (indexPath.section) {
        case 0: {
            
            switch (indexPath.row) {
                case 0: {//助手日报数
                    [self pushNewViewController:[[XHMyNewsViewController alloc] init]];
                    if(delegate.tabbarView.dNum>0){
                        delegate.tabbarView.dNum = 0;
                        [self resetNoti:@1];
                    }
                    break;
                }
                case 1: {// 实验周刊数
                    [self pushNewViewController:[[XHShiYanViewController alloc] init]];
                    if (delegate.tabbarView.wNum > 0) {
                         delegate.tabbarView.wNum = 0;
                        [self resetNoti:@2];
                    }
                    break;
                }
                case 2: {
                    [HYHelper mLoginID:^(id uid) {
                        if (uid) {
                            [self pushNewViewController:[[XHLawViewController alloc] init]];
                        } else {
                            return [BMUtils showError:@"请先登录"];
                        }
                    }];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {//活动中心
                    [self pushNewViewController:[[XHNyActiviyViewController alloc] init]];
                    if (delegate.tabbarView.pNum>0) {
                        delegate.tabbarView.pNum = 0;
                        [self resetNoti:@3];
                    }
                    break;
                }
                case 1: {
                    [self pushNewViewController:[[XHBrandCuViewController alloc] init]];
                    break;
                }
                case 2: {//培训信息数
                    [self pushNewViewController:[[XHPeiXunViewController alloc] init]];
                    if (delegate.tabbarView.tNum>0) {
                        delegate.tabbarView.tNum = 0;
                        [self resetNoti:@4];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [HYHelper mLoginID:^(id uid) {
                        if (uid) {
                            XHKJIFenViewController *ji = [[XHKJIFenViewController alloc] init];
                            ji.delegate = self;
                            [self pushNewViewController:ji];
                        } else {
                            return [BMUtils showError:@"请先登录"];
                        }
                    }];
                    break;
                }
                case 1: {//chartnum 排行榜
                    [self pushNewViewController:[[XHPaiHangBanViewController alloc] init]];
                    if (delegate.tabbarView.chartnum>0) {
                        delegate.tabbarView.chartnum = 0;
                        [self resetNoti:@5];
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        
        default:
            break;
    }
    
    [self.tableView reloadData];
    if (indexPath.section==1&&indexPath.row==0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"huoDongZhpngXin"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"huoDongZhpngXin"];
    }
}
- (void)jifenClickZhuanjiFen
{
    self.tabBarController.selectedIndex = 1;
}

- (UILabel *)accessLabel:(NSInteger)num
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%ld",(long)num];
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


- (UILabel *)accessLabelNil
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    label.backgroundColor = [UIColor redColor];
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
