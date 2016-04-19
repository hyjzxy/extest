//
//  XHMyNewsViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-4.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMyNewsViewController.h"
#import "XHStoreManager.h"
#import "MyLabel.h"
#import "WYRiBaoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "XHMyButton.h"
#import "xiangqingye.h"
#import "Masonry.h"
#import "HYHelper.h"

@interface XHMyNewsViewController ()<UIAlertViewDelegate>
{
    int page;
}
@property (strong, nonatomic) NSMutableDictionary *mData;
@property (strong, nonatomic) NSArray *mSections;
@end

@implementation XHMyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"助手日报";
    self.mData = [NSMutableDictionary dictionary];
    page = 1;
    [self configuraTableViewNormalSeparatorInset];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加上拉加载更多
    __weak XHMyNewsViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
         [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
         [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-13 22:05:59
 *
 *  @brief  接时间分组
 *  @param datas NSARRAY
 *  @since v1.0
 */
- (void)mBuildData:(NSArray*)datas
{
    for (NSDictionary *dic in datas) {
        if ([_mData.allKeys containsObject:dic[@"date"]]) {
            [_mData[dic[@"date"]] addObject:dic];
        }else{
            [_mData setObject:[NSMutableArray arrayWithObject:dic] forKey:dic[@"date"]];
        }
    }
    if (_mData.count>0) {
        self.mSections = [_mData.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj2 compare:obj1];
        }];
    }else{
        self.mSections = [NSArray array];
    }
}

-(void)reloadMoreData{
    [HYHelper mLoginID:^(id uid) {
        NSArray *keyValue = [FIND_BAO_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],uid?uid:@0,nil] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_BAO_API withType:FIND_BAO success:^(id responseObject){
            if (page == 1) {
                [self.mData removeAllObjects];
            }
            [self mBuildData:responseObject];
            page++;
            [self.tableView reloadData];
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
        }failure:^(id error){
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
        }];
    }];
}

- (void)reloadData
{
    page = 1;
    [self reloadMoreData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _mData.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_mData[_mSections[section]]count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        return 145;
    }else{
        return 56;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return 25.0f;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VWidth(tableView), 25)];
    head.backgroundColor = [UIColor clearColor];
    NSString *dateStr = _mSections[section];
    //左上角时间
    MyLabel *title = [[MyLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25) withText:[NSString stringWithFormat:@"%@月%@日",[dateStr substringWithRange:NSMakeRange(5, 2)],[dateStr substringWithRange:NSMakeRange(8, 2)]] withPosition:NSTextAlignmentCenter withFontSize:12 withColor:[UIColor whiteColor] withBackColor:UIColorFromRGB(0x62A121)];
    [head addSubview:title];
    title.tag = 9999;
    return head;
}
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *aa = [self.tableView indexPathsForVisibleRows];
    if (aa && aa.count>0) {
        NSIndexPath *indexPath = aa[0];
        NSInteger s = indexPath.section;
        MyLabel *v = (MyLabel*)[[self.tableView headerViewForSection:s]viewWithTag:9999];
        if([aa indexOfObject:indexPath]==0){
             v.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
        }else{
            v.backgroundColor = UIColorFromRGB(0x5D991F);
        }
    }
}*/


#pragma mark - UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSDictionary *dic = _mData[_mSections[indexPath.section]][indexPath.row];
   if(indexPath.row == 0 && indexPath.section == 0){
       static NSString *cellIdentifier = @"cellIdentifier222222";
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
       }
       for(UIView *view in cell.subviews){
        [view removeFromSuperview];
       }
       UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, Main_Screen_Width, 146)];
       [headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] placeholderImage:[UIImage imageNamed:@"日报.png"]];
       [cell addSubview:headImg];
       UILabel *titleLabel = [[UILabel alloc]initWithFrame:Rect(10, VHeight(headImg)-20.0f, VWidth(headImg)-20, 15.0f)];
       titleLabel.backgroundColor = [UIColor clearColor];
       titleLabel.textColor = [UIColor whiteColor];
       titleLabel.font = SYSTEMFONT(15.0f);
       titleLabel.text = dic[@"title"];
 
       UIView *bg = [[UIView alloc]init];
       bg.backgroundColor = [UIColor clearColor];
       [bg addSubview:titleLabel];
       [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(bg).with.insets(UIEdgeInsetsMake(0, 5, 0, 5));
       }];
       [headImg addSubview:bg];
       [bg mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.bottom.right.equalTo(headImg);
           make.height.mas_equalTo(@28);
       }];
       return cell;
    }else{
        static NSString *cellIdentifier = @"WYRiBaoTableViewCell";
        WYRiBaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = (WYRiBaoTableViewCell *)ViewFromXib(@"MyTableViewCell", 1);
        }
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] placeholderImage:[UIImage imageNamed:@"日报.png"]];
        cell.name.text = WYISBLANK([dic objectForKey:@"title"]);
        cell.time.text = @"";
        return cell;
    }
}

#pragma markr - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _mData[_mSections[indexPath.section]][indexPath.row];
    [self pushNewViewController:[[xiangqingye alloc] initWithData:dic title:@"助手日报"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self changeToLongUp];
}
@end
