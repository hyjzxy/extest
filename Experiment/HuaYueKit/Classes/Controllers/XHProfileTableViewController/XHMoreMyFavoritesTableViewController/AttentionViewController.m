//
//  AttentionViewController.m
//  HuaYue
//
//  Created by lee on 15/1/25.
//
//

#import "AttentionViewController.h"

//#import "XHContactTableViewController.h"
#import "XHMyselfViewController.h"
#import "XHStoreManager.h"
#import "XHContactTableViewCell.h"
#import "XHFoundationCommon.h"
#import "XHShaiXuanView.h"
#import "XHNewsTableViewController.h"
#import "UIButton+WebCache.h"
#import "SBJsonParser.h"
#import "UIButton+WebCache.h"
#import "XHMyButton.h"
#import "HYHelper.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "UIViewController+Cate.h"

@interface AttentionViewController ()<loginBtnGotoLoginDelegate>
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *bottnSelectd0;
    UIView *bottnSelectd1;
    int page;
    UILabel *badge;
}
@property (nonatomic,assign)BOOL isArticle;
@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.title = @"关注信息";
    
    self.isArticle = YES;
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,  160,  35)];
    [leftBtn setTitle:@"我关注的" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn.titleLabel setFont:BOLDSYSTEMFONT(14.0)];
    [leftBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [leftBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    [self.view addSubview:leftBtn];
    
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 0,  160,  35)];
    [rightBtn setTitle:@"关注我的" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [rightBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:BOLDSYSTEMFONT(14)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    NSInteger qsum = delegate.tabbarView.gNum;
    if(qsum>0){
        badge = [[UILabel alloc]initWithFrame:CGRectMake(265, 0, 14, 14)];
        badge.tag = 9900;
        badge.text = [NSString stringWithFormat:@"%zd",qsum];
        badge.backgroundColor = [UIColor redColor];
        badge.layer.masksToBounds = YES;
        badge.layer.cornerRadius = 7;
        badge.textColor = [UIColor whiteColor];
        badge.font = [UIFont boldSystemFontOfSize:10];
        badge.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:badge];
    }
    
    bottnSelectd0 = [[UIView alloc]initWithFrame:CGRectMake(0, 31,  160,  4)];
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1 = [[UIView alloc]initWithFrame:CGRectMake(160, 31,  160,  4)];
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    [self.view addSubview:bottnSelectd0];
    [self.view addSubview:bottnSelectd1];
    
    CGRect frame = self.tableView.frame;
    frame.origin.y = 35;
    frame.size.height = frame.size.height - 35;
    
    self.tableView.frame = frame;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [ws reloadData];
    }];
    /*CGRect tableViewFrame = self.view.bounds;
    back = [[UIButton alloc] initWithFrame:tableViewFrame];
    back.backgroundColor = RGBACOLOR(100, 100, 100, .7);
    [back addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    _topTableView = ViewFromXib(@"MyTableViewCell", 6);
    [back addSubview:_topTableView];
    [self.tabBarController.view addSubview:back];
    [self.tabBarController.view bringSubviewToFront:back];
    back.alpha = 0;*/
    [self.tableView.legendHeader beginRefreshing];
}
-(void)reloadMoreData{
    __weak AttentionViewController *weakMy = self;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *keyValue = [SYSTEMS_INFO_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID], [NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:SYSTEMS_INFO_API withType:SYSTEMS_INFO success:^(id responseObject){
        
        if (![responseObject isKindOfClass:[NSArray class]]) return;
        
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
    if(self.isArticle){
        [self requestDataArticle];
    }else{
        [self requestDataComment];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 5;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    if (self.isArticle) {//关注
        UITableViewCell *cell = cell =  ViewFromXib(@"attentionCell", 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *headImageBtn  = (UIButton *)[cell viewWithTag:201];
        UILabel *nickName       = (UILabel *)[cell viewWithTag:202];
        UILabel *camPanyLabel   = (UILabel *)[cell viewWithTag:203];
        UILabel *rankLabel   = (UILabel *)[cell viewWithTag:401];
        UIImageView *userType = (UIImageView*)[cell viewWithTag:501];
        [HYHelper mSetVImageView:userType v:dic[@"type"] head:headImageBtn];
        
        XHMyButton *cancleAttentionBtn  = (XHMyButton *)[cell viewWithTag:204];
        cancleAttentionBtn.arrayIndex   = indexPath.row;
        cancleAttentionBtn.tag          = [dic[@"tuid"] integerValue];
        [cancleAttentionBtn addTarget:self action:@selector(cancleAttention:) forControlEvents:UIControlEventTouchUpInside];
        
        //头像
        [headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        headImageBtn.info = @{@"uid":dic[@"tuid"]};
        headImageBtn.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
        nickName.text = WYISBLANK(dic[@"nickname"]);
        camPanyLabel.text = WYISBLANK(dic[@"company"]);
        [HYHelper mSetLevelLabel:rankLabel level:dic[@"rank"]];
        return cell;

    }else{//粉丝
        UITableViewCell *cell =   ViewFromXib(@"attentionCell", 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *headImageBtn  = (UIButton *)[cell viewWithTag:301];
        UILabel *nickName       = (UILabel *)[cell viewWithTag:302];
        UILabel *camPanyLabel   = (UILabel *)[cell viewWithTag:303];
        UILabel *rankLabel   = (UILabel *)[cell viewWithTag:401];
        UIImageView *userType = (UIImageView*)[cell viewWithTag:501];
        [HYHelper mSetVImageView:userType v:dic[@"type"] head:headImageBtn];
        XHMyButton *attentionBtn = (XHMyButton *)[cell viewWithTag:304];
        attentionBtn.arrayIndex = indexPath.row;
        attentionBtn.tag = [dic[@"fuid"] integerValue];
        [attentionBtn addTarget:self action:@selector(attention:) forControlEvents:UIControlEventTouchUpInside];
        
        //头像
        [headImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        headImageBtn.info = @{@"uid":dic[@"fuid"]};
        headImageBtn.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
        nickName.text = WYISBLANK(dic[@"nickname"]);
        camPanyLabel.text = WYISBLANK(dic[@"company"]);
        [HYHelper mSetLevelLabel:rankLabel level:dic[@"rank"]];
        [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [attentionBtn setBackgroundImage:[UIImage imageNamed:@"btn11"] forState:UIControlStateNormal];
        attentionBtn.enabled = [N2V(dic[@"same"], @"0")intValue]!=1;
        return cell;

    }
}

- (void)attention:(XHMyButton *)sender{
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"你确定要关注该用户码？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        NSArray *keyValue = [MY_ATTENTION_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,[NSString stringWithFormat:@"%ld",(long)sender.tag]] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:MY_ATTENTION_API
                                          withType:MY_ATTENTION
                                           success:^(id responseObject) {
                                               NSLog(@"%@",responseObject);
                                               sender.enabled = NO;
                                               [BMUtils showSuccess:@"关注成功"];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
    }]show];
}

- (void)cancleAttention:(XHMyButton *)sender{
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"你确定要取消关注该用户码？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        NSArray *keyValue = [MY_CANCLEATTENTION_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,[NSString stringWithFormat:@"%ld",(long)sender.tag]] forKeys:keyValue];
        
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:MY_CANCLEATTENTION_API
                                          withType:MY_CANCLEATTENTION
                                           success:^(id responseObject) {
                                               [BMUtils showSuccess:@"已取消关注"];
                                               NSArray  *uidArray = [self.dataSource valueForKeyPath:@"tuid"];
                                               NSInteger index  = [uidArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
                                               [self.dataSource removeObjectAtIndex:index];
                                               [self.tableView reloadData];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
    }]show];
}

-(void)requestDataArticle{
    __weak AttentionViewController *weakMy = self;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *keyValue = [MY_ATTENTIONLIST_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_ATTENTIONLIST_API
                                      withType:MY_ATTENTIONLIST
                                       success:^(id responseObject){
                                           if (!self.isArticle) return;
                                           [weakMy.dataSource removeAllObjects];
                                           [weakMy.dataSource addObjectsFromArray:responseObject];
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                       }failure:^(id error){
                                           [weakMy.tableView.legendHeader endRefreshing];
                                       }];
}

-(void)requestDataComment{
    __weak AttentionViewController *weakMy = self;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    
    NSArray *keyValue = [MY_FANS_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_FANS_API
                                      withType:MY_FANS
                                       success:^(id responseObject){
                                           if (self.isArticle) return;
                                           [weakMy.dataSource removeAllObjects];
                                           [weakMy.dataSource addObjectsFromArray:responseObject];
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                       }failure:^(id error){
                                           [weakMy.tableView.legendHeader endRefreshing];
                                       }];
}
-(void)leftBtnClick:(id)sender
{
    self.isArticle =YES;
    leftBtn.selected = YES;
    rightBtn.selected = NO;
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    page = 1;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self requestDataArticle];
    
}
-(void)rightBtnClick:(id)sender
{
    self.isArticle =NO;
    leftBtn.selected = NO;
    rightBtn.selected = YES;
    bottnSelectd0.backgroundColor = UIColorFromRGB(0xDBDADA);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0x00A6F4);
    page = 1;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self requestDataComment];
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    NSInteger qsum = delegate.tabbarView.gNum;
    if (qsum>0) {
        delegate.tabbarView.gNum = 0;
        [self resetNoti:@17];
    }
    [badge removeFromSuperview];
}

@end
