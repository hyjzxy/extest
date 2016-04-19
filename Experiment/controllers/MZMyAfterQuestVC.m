//
//  MZMyAfterQuestVC.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/2.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZMyAfterQuestVC.h"
#import "MZCTabView.h"
#import "Masonry.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MJRefresh.h"
#import "NetManager.h"
#import "HYHelper.h"
#import "MZAnswerChatVC.h"
#import "MZImageView.h"
#import "NSObject+Cate.h"
#import "AppDelegate.h"
#import "UIViewController+Cate.h"

@interface MZMyAfterQuestVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UITableView *afterMeTBV;
@property (weak, nonatomic) IBOutlet UITableView *myAfterTBV;
@property (strong, nonatomic) NSMutableArray *afterMeDatas;
@property (strong, nonatomic) NSMutableArray *myAfterDatas;
@property (weak, nonatomic) UITableViewCell *tmp;
@property (strong, nonatomic) UILabel *badge;
@end

@implementation MZMyAfterQuestVC
{
    NSInteger afterLastId;
    NSInteger myAfterLastId;
    NSInteger selectedIndex;
    NSInteger myAfterPage;
    NSInteger afterMePage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"追问";
    selectedIndex = 0;
    afterMePage = 0;
    myAfterPage = 0;
    self.myAfterDatas = [NSMutableArray array];
    self.afterMeDatas = [NSMutableArray array];
    _afterMeTBV.estimatedRowHeight = 80.0f;
    _afterMeTBV.rowHeight = UITableViewAutomaticDimension;
    
    _myAfterTBV.estimatedRowHeight = 80.0f;
    _myAfterTBV.rowHeight = UITableViewAutomaticDimension;
    
    [_myAfterTBV addLegendHeaderWithRefreshingBlock:^{
        myAfterPage = 0;
        [self loadData];
    }];
    [_myAfterTBV addLegendFooterWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [_afterMeTBV addLegendHeaderWithRefreshingBlock:^{
        afterMePage = 0;
        [self loadData];
    }];
    [_afterMeTBV addLegendFooterWithRefreshingBlock:^{
        [self loadData];
    }];
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    NSInteger qsum = delegate.tabbarView.afternum;
    MZCTabView *cTabView = [[MZCTabView alloc]initWithTitles:@[@"我的追问",@"追问我的"] blocks:@[^(id index){
        selectedIndex = [index integerValue];
        if (_myAfterDatas.count==0) {
            [_myAfterTBV.legendHeader beginRefreshing];
        }
        _myAfterTBV.hidden = NO;
        _afterMeTBV.hidden = YES;
    },^(id index){
        selectedIndex = [index integerValue];
        if (_afterMeDatas.count==0) {
            [_afterMeTBV.legendHeader beginRefreshing];
        }
        _myAfterTBV.hidden = YES;
        _afterMeTBV.hidden = NO;
        if (qsum>0) {
            delegate.tabbarView.afternum = 0;
            [self resetNoti:@14];
            [self resetNoti:@15];
        }
        [_badge removeFromSuperview];
    }]];
    if(qsum>0){
        self.badge = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 14)];
        _badge.tag = 9900;
        _badge.text = [NSString stringWithFormat:@"%zd",qsum];
        _badge.backgroundColor = [UIColor redColor];
        _badge.layer.masksToBounds = YES;
        _badge.layer.cornerRadius = 7;
        _badge.textColor = [UIColor whiteColor];
        _badge.font = [UIFont boldSystemFontOfSize:10];
        _badge.textAlignment = NSTextAlignmentCenter;
        UIButton *btn = (UIButton*)cTabView.btns[1];
        [btn.superview addSubview:_badge];
        [_badge mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@14);
            make.centerX.equalTo(btn).with.offset(35);
            make.centerY.equalTo(btn).with.offset(-7);
        }];
    }
    [_tabView addSubview:cTabView];
    WS(ws);
    [cTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(ws.tabView);
    }];
    [_myAfterTBV.legendHeader beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)loadData
{
    [HYHelper mLoginID:^(id uid) {
        if (selectedIndex == 0) {
            NSString *url = kINTERFACE_ADDRESS(@"Member/myquestionclosely");
            [[NetManager sharedManager]myRequestParam:[NSMutableDictionary dictionaryWithObjects:@[uid,@(myAfterPage),@20] forKeys:@[@"uid",@"pid",@"num"]] withUrl:url withType:@"我的追问" success:^(id responseObject) {
                if (myAfterPage==0)[self.myAfterDatas removeAllObjects];
                myAfterPage++;
                [_myAfterDatas addObjectsFromArray:responseObject];
                [_myAfterTBV.legendHeader endRefreshing];
                [_myAfterTBV.legendFooter endRefreshing];
                [_myAfterTBV reloadData];
            } failure:^(id errorString) {
                [_myAfterTBV.legendHeader endRefreshing];
                [_myAfterTBV.legendFooter endRefreshing];
            }];
        }else if(selectedIndex == 1) {
            NSString *url = kINTERFACE_ADDRESS(@"Member/askmelist.html");
            [[NetManager sharedManager]myRequestParam:[NSMutableDictionary dictionaryWithObjects:@[uid,@(afterMePage),@20] forKeys:@[@"uid",@"pid",@"num"]] withUrl:url withType:@"追问我的" success:^(id responseObject) {
                if (afterMePage==0)[self.afterMeDatas removeAllObjects];
                afterMePage++;
                [_afterMeDatas addObjectsFromArray:responseObject];
                [_afterMeTBV.legendHeader endRefreshing];
                [_afterMeTBV.legendFooter endRefreshing];
                [_afterMeTBV reloadData];
            } failure:^(id errorString) {
                [_afterMeTBV.legendHeader endRefreshing];
                [_afterMeTBV.legendFooter endRefreshing];
            }];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectedIndex==0?_myAfterDatas.count:_afterMeDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (selectedIndex == 0) {
        cell = ViewFromXib(@"Cells", 0);
        UILabel *l101 = (UILabel*)[cell viewWithTag:101];
        UILabel *l102 = (UILabel*)[cell viewWithTag:102];
        UILabel *l103 = (UILabel*)[cell viewWithTag:103];
        UILabel *l104 = (UILabel*)[cell viewWithTag:104];
        UILabel *l105 = (UILabel*)[cell viewWithTag:105];
        UILabel *l109 = (UILabel*)[cell viewWithTag:109];
        UIImageView *qImage = (UIImageView*)[cell viewWithTag:110];
        
        NSDictionary *dic = _myAfterDatas[indexPath.row];
        l101.text = [NSString stringWithFormat:@"我追问%@:",dic[@"askname"]];
        l102.text = dic[@"inputtime"];
        NSString *imageURL = dic[@"image"];
        [[l103 viewWithTag:1]removeFromSuperview];
        if (imageURL && imageURL.length>0) {
            l103.text = @"【图片】";
            /*MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(imageURL)];
            iv.tag = 1;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:IMG_URL(imageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [l103 addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(l103);
                make.size.mas_equalTo(CGSizeMake(80, 50));
            }];*/
        }else{
            l103.text = dic[@"zcontent"];
        }
        NSString *ansupperlist = N2V(dic[@"ansupperlist"], @"");
        l104.text =  [NSString stringWithFormat:@"%@的回答:",dic[@"askname"]];
        NSString *aimageURL = dic[@"aimage"];
        [[l109 viewWithTag:2]removeFromSuperview];
        if (aimageURL && aimageURL.length>0) {
            l109.text = [NSString stringWithFormat:@"%@【图片】",ansupperlist];
            /*MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(aimageURL)];
            iv.tag = 2;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:IMG_URL(aimageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [l109 addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(l109);
                make.size.mas_equalTo(CGSizeMake(80, 50));
            }];*/
        }else{
            l109.text = [NSString stringWithFormat:@"%@%@",ansupperlist,dic[@"acontent"]];
        }
        
        NSString *qimage = dic[@"qimage"];
        l105.text = dic[@"qtitle"];
        if (qimage && qimage.length>0) {
             [qImage setImageWithURL:IMG_URL(qimage) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [qImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(@45);
            }];
        } else {
            [qImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(@0);
            }];
        }
//        [[l105 viewWithTag:3]removeFromSuperview];
        /*if (qimage && qimage.length>0) {
            l105.text = @"";
            MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(qimage)];
            iv.tag = 3;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:IMG_URL(qimage) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [l105 addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(l105);
                make.size.mas_equalTo(CGSizeMake(80, 50));
            }];
        }else{
            l105.text = dic[@"qtitle"];
        }*/
    }else {
        cell = ViewFromXib(@"Cells", 1);
        UIImageView *head = ViewWithTag(UIImageView*, cell, 100);
        UILabel *rank = ViewWithTag(UILabel*, cell, 101);
        UILabel *afterMe = ViewWithTag(UILabel*, cell, 102);
        UILabel *inputTime = ViewWithTag(UILabel*, cell, 103);
        UILabel *content = ViewWithTag(UILabel*, cell, 104);
        UILabel *asker = ViewWithTag(UILabel*, cell, 105);
        UILabel *aTitle= ViewWithTag(UILabel*, cell, 106);
        UILabel *qTitle = ViewWithTag(UILabel*, cell, 107);
        UIImageView *gbView = ViewWithTag(UIImageView*, cell, 108);
        UIImageView *qImage = ViewWithTag(UIImageView*, cell, 109);
        
        NSDictionary *dic = _afterMeDatas[indexPath.row];
        [HYHelper mSetLevelLabel:rank level:dic[@"rank"]];
        afterMe.text = [NSString stringWithFormat:@"%@追问我：",dic[@"znickname"]];
        inputTime.text  = dic[@"inputtime"];

        NSString *imageURL = dic[@"image"];
        [[content viewWithTag:1]removeFromSuperview];
        if (imageURL && imageURL.length>0) {
            content.text = @"【图片】";
            /*MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(imageURL)];
            iv.tag = 1;
            [iv setImageWithURL:IMG_URL(imageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [content addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(content);
                make.size.mas_equalTo(CGSizeMake(80, 50));
            }];*/
        }else{
            content.text = dic[@"zcontent"];
        }
        asker.text = [NSString stringWithFormat:@"%@的回答：",dic[@"anickname"]];
        
        NSString *aimageURL = dic[@"aimage"];
        [[aTitle viewWithTag:2]removeFromSuperview];
        if (aimageURL && aimageURL.length>0) {
            aTitle.text = @"【图片】";
            /*MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(aimageURL)];
            iv.tag = 2;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:IMG_URL(aimageURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [aTitle addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(aTitle);
                make.width.mas_equalTo(CGSizeMake(80, 50));
            }];*/
        }else{
            aTitle.text = dic[@"acontent"];
        }
        
        qTitle.text = dic[@"qtitle"];
        NSString *qimageStr = dic[@"qimage"];
//        [[qTitle viewWithTag:3]removeFromSuperview];
        if (qimageStr && qimageStr.length>0) {
            [qImage setImageWithURL:IMG_URL(qimageStr) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [qImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(@45);
            }];
        }else {
            [qImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(@0);
            }];
        }
           /* qTitle.text = @"";
            MZImageView *iv = [[MZImageView alloc]initWithImageURL:IMG_URL(qimage)];
            iv.tag = 3;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [iv setImageWithURL:IMG_URL(qimage) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [qTitle addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(qTitle);
                make.size.mas_equalTo(CGSizeMake(80, 50));
            }];
        }else{
            qTitle.text = dic[@"qtitle"];
        }*/
        [head setImageWithURL:IMG_URL(dic[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        gbView.image = [[UIImage imageNamed:@"lightbluebox"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 60, 5, 5) resizingMode:UIImageResizingModeStretch];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = selectedIndex==0?_myAfterDatas[indexPath.row]:_afterMeDatas[indexPath.row];
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.chatType = kAddQuestChat;
    chatVC.isAddQuest = YES;
    chatVC.qid = [dic[@"qid"]intValue];
    chatVC.nickName = [HYHelper isSameName:dic[@"aftername"]]?@"我":dic[@"aftername"];
    chatVC.auid = [dic[@"auid"]intValue];
    chatVC.aid =  [dic[@"aid"]intValue];
    [self.navigationController pushViewController:chatVC animated:YES];
   
}
@end
