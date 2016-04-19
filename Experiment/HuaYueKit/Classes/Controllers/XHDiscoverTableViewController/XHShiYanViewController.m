//
//  XHShiYanViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHShiYanViewController.h"
#import "XHNewsTemplateTableViewCell.h"
#import "XHNewsContainerView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "shiYanZhouKanCell.h"

//我自己创建的详情页类
#import "xiangqingye.h"
#import "NSObject+Cate.h"
@interface XHShiYanViewController ()
{
    int page;
    UITableView*_tableView;
    NSMutableArray*_numberArray;
}
@end

@implementation XHShiYanViewController

- (void)loadDataSource {
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    page=1;
    self.title = @"实验周刊";
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(kTableViewFrameX, 0, self.view.frame.size.width-kTableViewFrameX*2, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;_tableView.delegate=self;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, -25, 0, -25);
    _tableView.clipsToBounds = NO;
    NSArray *keyValue = [FIND_KAN_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_KAN_API withType:FIND_KAN success:^(id responseObject){
        _numberArray=responseObject;
        [_tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

    _tableView.tableFooterView=[[UIView alloc]init];
    if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
        _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:_tableView];
}

-(void)reloadMoreData{
    
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _numberArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id subdata = _numberArray[section][@"subdata"];
    if (![subdata isEqual:@"null"]) {
        id jsonSeria = [NSJSONSerialization JSONObjectWithData:[subdata dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        return [jsonSeria count];
    }else{
        return 0;
    }
}

- ( shiYanZhouKanCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    shiYanZhouKanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = ViewFromXib(@"shiYanZhouKanCell", 0);
    }
    
    NSArray *jsonSeria = [NSJSONSerialization JSONObjectWithData:[_numberArray[indexPath.section][@"subdata"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSDictionary *dic = jsonSeria[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text=[dic objectForKey:@"title"];
    cell.imageBtn.frame=CGRectMake(cell.frame.size.width-85, 5, cell.frame.size.width/5,cell.frame.size.height-10);
    [cell.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] forState:0 placeholderImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage.png"]];
    [cell addSubview:cell.imageBtn];
    [cell.imageBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageBtn.info = @{@"id":dic[@"id"],@"type":@2};
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 160)];
    UILabel*dateLabel=[[UILabel alloc]init];
    dateLabel.center=CGPointMake(dateView.frame.size.width/2, 20);
    dateLabel.bounds=CGRectMake(0, 0, 70, 15);
    dateLabel.textAlignment=1;
    dateLabel.font=[UIFont systemFontOfSize:12];
    dateLabel.backgroundColor=RGBCOLOR(194, 194, 194);
    dateLabel.textColor=[UIColor whiteColor];
    dateLabel.layer.masksToBounds = YES;
    dateLabel.layer.cornerRadius = 5.0f;
    NSDictionary *dic = _numberArray[section];
    NSString*time = [dic objectForKey:@"inputtime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate*confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[time intValue]];
    NSString*confromTimespStr = [formatter stringFromDate:confromTimesp];
    dateLabel.text=confromTimespStr;
    [dateView addSubview:dateLabel];
    //
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 40, _tableView.frame.size.width, 160)];
    UILabel*lable=[[UILabel alloc]initWithFrame:view.bounds];
    lable.backgroundColor=[UIColor whiteColor];
    
    UIButton*button=[UIButton buttonWithType:0];
    button.center=CGPointMake(view.center.x, view.center.y);
    button.frame=CGRectMake(5, 5, view.frame.size.width-10, view.frame.size.height-10);
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] forState:0 placeholderImage:[UIImage imageNamed:@"shiyan-pic.png"]];
    [button addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.info = @{@"id":dic[@"id"],@"type":@1};
    
    UILabel*lablename=[[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.size.height-28, button.frame.size.width, 28)];
    lablename.backgroundColor=[UIColor blackColor];
    lablename.alpha=0.7; lablename.font=[UIFont systemFontOfSize:14];
    lablename.text=[dic objectForKey:@"title"];
    lablename.textColor=[UIColor whiteColor];
    [view addSubview:lable];
    [view addSubview:button];
    [view addSubview:lablename];
    [button addSubview:lablename];
    [dateView addSubview:view];
    return dateView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    xiangqingye*vc= [[xiangqingye alloc]init];
    
    NSArray *jsonSeria = [NSJSONSerialization JSONObjectWithData:[_numberArray[indexPath.section][@"subdata"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSDictionary *dic = jsonSeria[indexPath.row];
    vc.wID=[[dic objectForKey:@"id"]intValue];
    vc.title = @"实验周刊";
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 200.0f;
}

#pragma mark - void
-(void)headBtnClick:(UIButton*)btn
{
    xiangqingye*vc= [[xiangqingye alloc]initWithWID:[btn.info[@"id"]intValue] title:@"实验周刊"];
    vc.type = [btn.info[@"type"]intValue];
    vc.isSuper = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
