//
//  XHProfileTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHProfileTableViewController.h"
#import "XHShiMingRZViewController.h"
#import "XHStoreManager.h"

#import "XHMoreMyProfileDetailTableViewController.h"
#import "XHSignViewController.h"
#import "XHMoreMyFavoritesTableViewController.h"
#import "XHMoreMyBankCardTableViewController.h"
#import "XHPassWdViewController.h"
#import "XHMoreSettingTableViewController.h"
#import "XHKJIFenViewController.h"
#import "XHLoveViewController.h"
#import "XHZhuiWenViewController.h"
#import "XHMyAnserViewController.h"
#import "XHFansHelpViewController.h"
#import "XHRenwuChengJiuViewController.h"
#import "XHMyWuPinViewController.h"
#import "MobClick.h"
#import "XHZhuShouIDViewController.h"
#import "XHFeedBackViewController.h"
#import "DDActionSheet.h"
#import "XHMyselfViewController.h"
#import "systemViewController.h"
#import "AttentionViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CheckBtn.h"
#import "HYHelper.h"
#import "MZMyAfterQuestVC.h"
#import "UIViewController+Cate.h"
#import "MZApp.h"

@interface XHProfileTableViewController ()<loginOutDelegate,jifenDelegate>
{
    UIButton *left;
    UIButton *right;

    BOOL     isRefreshTable;
}
@property(nonatomic, strong)NSMutableArray *totalDic;
@property(nonatomic, strong)NSDictionary *myinforMationDic;

@property(nonatomic, strong)UIImageView *headImage;
@property(nonatomic, strong)UIImageView *sexImage;
@property(nonatomic, strong)UIView *scrollView;;
@end

@implementation XHProfileTableViewController

#pragma mark - DataSource

- (void)loadDataSource {
    self.dataSource = [[XHStoreManager shareStoreManager] getProfileConfigureArray];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupProfile];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar viewWithTag:9800].hidden = YES;
}

- (void)viewDidLoad {

    self.tableView.backgroundColor = [UIColor clearColor];
    CGRectSetY(self.tableView, -2.0f);
    self.totalDic = [[NSMutableArray alloc] init];
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.hidden = YES;
    settingBtn.frame = Rect(Main_Screen_Width-40, 3, 40, 40);
    settingBtn.tag = 9800;
    [settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(clickedBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:settingBtn];
    [[NSNotificationCenter defaultCenter]addObserverForName:@"PROFILEREFRESH" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableView reloadData];
    }];
}

-(void)setupProfile{
    [super viewDidLoad];
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            self.scrollView.hidden = YES;
            self.tableView.hidden = NO;
            self.tabBarController.title = @"个人中心";
            UIButton *feedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            feedbackBtn.frame = Rect(0, 0, 40, 40);
            [feedbackBtn setImage:[UIImage imageNamed:@"feedback"] forState:UIControlStateNormal];
            [feedbackBtn addTarget:self action:@selector(clickedLeftAction) forControlEvents:UIControlEventTouchUpInside];
            self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"意见反馈" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftAction)];
            [self.navigationController.navigationBar viewWithTag:9800].hidden = NO;
            [self configuraTableViewNormalSeparatorInset];
            [self loadDataSource];
            [self requestPersonalInformation];
        }else {
            self.tabBarController.title = @"登录";
            if (self.scrollView == nil) {
                NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"LoginSignView" owner:nil options:nil];
                self.scrollView = (UIView *)list[0];
                [self.view addSubview:self.scrollView];
            }
            self.scrollView.hidden = NO;
            self.tableView.hidden = YES;
            UITextField *name = (UITextField *)[self.scrollView viewWithTag:5001];
            UITextField *pass = (UITextField *)[self.scrollView viewWithTag:5002];
            CheckBtn *checkBut = (CheckBtn*)[self.scrollView viewWithTag:5555];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            name.text = [ud stringForKey:USERLGN];
            if ([ud boolForKey:@"Remember"]) {
                pass.text = [ud stringForKey:USERPWD];
                checkBut.selected = YES;
            }else {
                pass.text = @"";
                checkBut.selected =NO;
            }
            
            UIButton *loginBtn = (UIButton *)[self.scrollView viewWithTag:5000];
            UIButton *passWdBtn = (UIButton *)[self.scrollView viewWithTag:5003];
            UIButton *signBtn = (UIButton *)[self.scrollView viewWithTag:5004];
            
            [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
            [passWdBtn addTarget:self action:@selector(passWdBtn) forControlEvents:UIControlEventTouchUpInside];
            [signBtn addTarget:self action:@selector(signBtn) forControlEvents:UIControlEventTouchUpInside];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard:)];
            [self.scrollView addGestureRecognizer:tap];
            self.tabBarController.navigationItem.leftBarButtonItem = nil;
            [self.navigationController.navigationBar viewWithTag:9800].hidden = YES;
            [self loadDataSource];
        }
    }];
}

//请求用户信息
- (void)requestPersonalInformation
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSArray *keyValue   = [MY_MEMEBERINFO_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,userId,@1] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_MEMEBERINFO_API
                                      withType:MY_MEMEBERINFO
                                       success:^(id responseObject)
     {
         self.myinforMationDic = [[NSDictionary alloc] initWithDictionary:responseObject];
         
         [self.tableView reloadData];
     }failure:^(id error){
         [BMUtils showError:error];
     }];
    
}

-(void)passWdBtn{
    
    
    XHPassWdViewController *pass = [[XHPassWdViewController alloc] initWithNibName:@"XHPassWdViewController" bundle:nil];
    [self pushNewViewController:pass];
    
}

-(void)signBtn{
    
    XHSignViewController *sign = [[XHSignViewController alloc] initWithNibName:@"XHSignViewController" bundle:nil];
    [self pushNewViewController:sign];
}
-(void)hiddenKeyBoard:(UIGestureRecognizer*)g{
    UITextField *name = (UITextField *)[self.scrollView viewWithTag:5001];
    UITextField *pass = (UITextField *)[self.scrollView viewWithTag:5002];
    
    [name resignFirstResponder];
    [pass resignFirstResponder];
}

-(void)login{
    
    UITextField *name = (UITextField *)[self.scrollView viewWithTag:5001];
    UITextField *pass = (UITextField *)[self.scrollView viewWithTag:5002];
    CheckBtn *checkBut = (CheckBtn*)[self.scrollView viewWithTag:5555];
    if(name.text == nil || [name.text isEqualToString:@""]){
        [BMUtils showError:@"用户名为空"];
        return;
    }
    
    if(pass.text == nil || [pass.text isEqualToString:@""]){
        [BMUtils showError:@"密码为空"];
        return;
    }
    
    NSArray *keyValue = [MY_LOGIN_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:WYISBLANK(name.text),WYISBLANK(pass.text),[MZApp share].deivceToken,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_LOGIN_API
                                      withType:MY_LOGIN
                                       success:^(id responseObject){
                                           //将登录信息保存本地
                                           NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                           [userDefault removeObjectForKey:USERLGN];
                                           [userDefault removeObjectForKey:USERPWD];
                                           [userDefault removeObjectForKey:@"Remember"];
                                           [userDefault setBool:NO forKey:@"IsAutoLogin"];
                                           if (checkBut.selected) {
                                               [userDefault setValue:dic[@"phone"] forKey:USERLGN];
                                               [userDefault setValue:dic[@"password"] forKey:USERPWD];
                                               [userDefault setBool:YES forKey:@"Remember"];
                                               [userDefault setBool:YES forKey:@"IsAutoLogin"];
                                           }
                                           [userDefault setValue:[responseObject objectForKey:@"id"] forKey:UID];
                                           [userDefault setValue:[responseObject objectForKey:@"nickname"] forKey:USERNAME];
                                           [userDefault setValue:[responseObject objectForKey:@"head"] forKey:USERHEAD];
                                           [userDefault setValue:[responseObject objectForKey:@"sex"] forKey:SEX];
                                           [userDefault setBool:[responseObject[@"realname_status"]boolValue]forKey:AUTH];
                                           [userDefault setValue:[responseObject objectForKey:@"integral"] forKey:INTEGRAL];
                                           [userDefault setValue:[responseObject objectForKey:@"invitation"] forKey:INVITATION];
                                           [userDefault synchronize];
                                           if (_otherDimiss) {
                                               [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                               return ;
                                           }
                                           if(_isDimiss){
                                               [self.navigationController popViewControllerAnimated:YES];
                                               return ;
                                           }
                                           self.scrollView.hidden = YES;
                                           self.tableView.hidden = NO;
                                           self.tabBarController.title = @"个人中心";
                                           [self configuraTableViewNormalSeparatorInset];
                                           self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"问题反馈" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftAction)];
                                           [self.navigationController.navigationBar viewWithTag:9800].hidden = NO;
                                           name.text = nil;
                                           pass.text = nil;
                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"wangyu" object:nil userInfo:nil];
                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                                           [MobClick endEvent:@"login"];
                                           [self requestPersonalInformation];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
    [name resignFirstResponder];
    [pass resignFirstResponder];
}

- (void)reloadTotleData{
}
- (void)getquestionnum{
    NSArray *keyValue = [HIS_TIWEN_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:HIS_TIWEN_API withType:HIS_TIWEN success:^(id responseObject){
        //将登录信息保存本地
        DLog(@"%@", responseObject[@"num"]);
        [self.totalDic setValue:responseObject[@"num"] forKey:@"getquestionnum"];
        DLog(@"getquestionnum%@", responseObject[@"num"]);
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

}
- (void)getanswernum{
    NSArray *keyValue = [HIS_ANS_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:HIS_ANS_API withType:HIS_ANS success:^(id responseObject){
        //将登录信息保存本地
        NSLog(@"class%@", [responseObject class]);
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

}
- (void)getadoptnum{
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
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

}
- (void)getattentionnum{
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
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

}

-(void)clickedLeftAction{
    XHFeedBackViewController *control = [[XHFeedBackViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

-(void)clickedBarButtonItemAction{
    XHMoreSettingTableViewController *control = [[XHMoreSettingTableViewController alloc] init];
    control.mydelegate = self;
    [self pushNewViewController:control];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    if(section == 0){
        static NSString *cellIdentifier = @"XHProfileTableViewController1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell) {
            
            NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
            cell = list[2];
        }
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:REALNAME_STASUS]);
        
        //头像
        UIImageView *headImage = (UIImageView *)[cell viewWithTag:199];
        headImage.layer.borderWidth = 3.0f;
        headImage.layer.borderColor = UIColorFromRGB(0x87D8F4).CGColor;
        headImage.layer.cornerRadius = VHeight(headImage)*0.5;
        headImage.layer.masksToBounds = YES;
        self.headImage = headImage;
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.myinforMationDic objectForKey:@"head"])]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        
        UITapGestureRecognizer *singleaction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage:)];
        singleaction.numberOfTapsRequired = 1;
        headImage.userInteractionEnabled = YES;
        [headImage addGestureRecognizer:singleaction];
        
        //性别
        UIImageView *sexImage = (UIImageView *)[cell viewWithTag:200];
//        NSString *sex=[userDefault objectForKey:SEX];
        if([WYISBLANK(self.myinforMationDic[@"sex"]) isEqual:@"1"]) {//男
            sexImage.image=[UIImage imageNamed:@"sex_woman.png"];
        } else {
            sexImage.image=[UIImage imageNamed:@"sex_man.png"];
        }
        
        UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:201];
        UILabel *jifenLabel = (UILabel *)[cell viewWithTag:202];
        UILabel *CamNameLabel = (UILabel *)[cell viewWithTag:204];
        UIButton *realNameBtn = (UIButton *)[cell viewWithTag:203];
        UIButton *jinFenBtn = (UIButton *)[cell viewWithTag:205];
        
        UILabel *qnumLabel = (UILabel *)[cell viewWithTag:206];
        UILabel *anumLabel = (UILabel *)[cell viewWithTag:207];
        UILabel *cnumLabel = (UILabel *)[cell viewWithTag:208];
        UILabel *fnumLabel = (UILabel *)[cell viewWithTag:209];
        qnumLabel.text = self.myinforMationDic[@"qnum"];//[userDefault objectForKey:QNUM]];
        anumLabel.text = self.myinforMationDic[@"anum"];//[userDefault objectForKey:ANUM]];
        cnumLabel.text = self.myinforMationDic[@"cnum"];//[userDefault objectForKey:CNUM]];
        fnumLabel.text = self.myinforMationDic[@"fnum"];//[userDefault objectForKey:FNUM]];
        jifenLabel.text = [NSString stringWithFormat:@"积分： %@分", WYISBLANK(self.myinforMationDic[@"integral"])];//[userDefault objectForKey:INTEGRAL]];
        [jinFenBtn addTarget:self action:@selector(jinfenClick:) forControlEvents:UIControlEventTouchUpInside];
        nickNameLabel.text =  [NSString stringWithFormat:@"昵称： %@ Lv.%@", WYISBLANK(self.myinforMationDic[@"nickname"]),WYISBLANK(self.myinforMationDic[@"rank"])];
        
        //认证
        if([WYISBLANK(self.myinforMationDic[@"realname_status"]) isEqual:@"1"]) {//认证成功
            
            CamNameLabel.text = WYISBLANK(self.myinforMationDic[@"company"]);//[userDefault objectForKey:CAMPNAME];
            [realNameBtn setTitle:@"已认证" forState:UIControlStateNormal];
            [realNameBtn setSelected:YES];
        }else {
            CamNameLabel.text = @"";
            [realNameBtn setTitle:@"未认证" forState:UIControlStateNormal];
            [realNameBtn setSelected:NO];
        }
        
        [realNameBtn addTarget:self action:@selector(clcikRenzhenBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        static NSString *cellIdentifier = @"XHProfileTableViewController";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        NSMutableDictionary *sectionDictionary = self.dataSource[section][row];
        NSString *title = [sectionDictionary valueForKey:@"title"];
        AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],[WYISBLANK(self.myinforMationDic[@"qnum"]) integerValue]];
                if (delegate.tabbarView.qNum > 0) {
                    cell.accessoryView = [self accessLabel:delegate.tabbarView.qNum];
                }
            }else if (indexPath.row == 1)
            {
                title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],[WYISBLANK(self.myinforMationDic[@"anum"]) integerValue]];
                if (delegate.tabbarView.aNum > 0) {
                    cell.accessoryView = [self accessLabel:delegate.tabbarView.aNum];
                }
            }else if (indexPath.row == 2)
            {
                //fansnum
                title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],[WYISBLANK(self.myinforMationDic[@"fansnum"]) integerValue]];
                if (delegate.tabbarView.fNum > 0) {
                    cell.accessoryView = [self accessLabel:delegate.tabbarView.fNum];
                }
            }else if (indexPath.row == 3)
            {
                NSUInteger sum = delegate.tabbarView.afternum;
                //title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],sum];
                if (sum > 0) {
                    cell.accessoryView = [self accessLabel:sum];
                }
            }else if (indexPath.row == 4)
            {
                //title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],[WYISBLANK(self.myinforMationDic[@"mnum"]) integerValue]];
                if (delegate.tabbarView.mNum > 0) {
                    cell.accessoryView = [self accessLabel:delegate.tabbarView.mNum];
                }
            }
        }else if (indexPath.section == 2)
        {
            if (indexPath.row == 0) {
                //title = [NSString stringWithFormat:@"%@(%zd)",[sectionDictionary valueForKey:@"title"],[WYISBLANK(self.myinforMationDic[@"gnum"]) integerValue]];
                if (delegate.tabbarView.gNum > 0) {
                    cell.accessoryView = [self accessLabel:delegate.tabbarView.gNum];
                }
            }
        }
        
        NSString *imageName = [sectionDictionary valueForKey:@"image"];
        cell.textLabel.text = title;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.imageView.image = [UIImage imageNamed:imageName];
        
        if (section == 2 && row == 1) {
            NSLog(@"%@",[self.myinforMationDic objectForKey:@"interest"]);
            cell.detailTextLabel.text = [self.myinforMationDic objectForKey:@"interest"];
        }else if(section == 2 && row == 3){
            cell.detailTextLabel.text = [self.myinforMationDic objectForKey:@"invitation"];
        }
        
        return cell;
    }
}

- (UILabel *)accessLabel:(NSInteger)num
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    label.backgroundColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%zd",num];
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)clcikRenzhenBtn:(UIButton*)btn
{
    XHShiMingRZViewController *control = [[XHShiMingRZViewController alloc] init];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)changeHeadImage:(UIImageView *)headImage{
    DLog(@"换头像-------");
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    XHMyselfViewController *control = [[XHMyselfViewController alloc] initWithwithUID:[[userDefault objectForKey:UID] intValue]];
    [self.navigationController pushViewController:control animated:YES];
}
#pragma mark - UITableView Delegate
#pragma mark - UITableView DataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(![HYHelper mLoginID:nil]){
        return 40;
    }
    if (!indexPath.section && !indexPath.row) {
        return 135;
    } else {
        return 44;
    }
}
#pragma markr - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.01f;
            break;
        default: {
            return 4;
            break;
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    switch (section) {
        case 0:{
            
        }
            break;
        case 1:{
            switch (row) {
                case 0:{//提问数
                    XHMoreMyFavoritesTableViewController *myFavoritesTableViewController = [[XHMoreMyFavoritesTableViewController alloc] init];
                    //                    viewController = myFavoritesTableViewController;
                    viewController = myFavoritesTableViewController;
                    if (delegate.tabbarView.qNum>0) {
                        delegate.tabbarView.qNum = 0;
                        [self resetNoti:@11];
                    }
                }
                    break;
                case 1:{//回答数
                    XHMyAnserViewController *control = [[XHMyAnserViewController alloc] init];
                    viewController = control;
                    if (delegate.tabbarView.aNum>0) {
                        delegate.tabbarView.aNum = 0;
                        [self resetNoti:@12];
                    }
                }
                    break;
                case 2:{//救助数
                    XHFansHelpViewController *control = [[XHFansHelpViewController alloc] init];
                    viewController = control;
                    if (delegate.tabbarView.fNum>0) {
                        delegate.tabbarView.fNum = 0;
                        [self resetNoti:@13];
                    }
                }
                    break;
                case 3:{//我追问数 afternum 追问我数
                    MZMyAfterQuestVC *control = [[MZMyAfterQuestVC alloc]init];
                    viewController = control;
                }
                    break;
                case 4:{//系统消息数
                    systemViewController *control = [[systemViewController alloc] init];
                    viewController = control;
                    if (delegate.tabbarView.mNum>0) {
                        delegate.tabbarView.mNum = 0;
                        [self resetNoti:@16];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (row) {
                case 0:{ // 关注数
                    AttentionViewController *controller = [[AttentionViewController alloc] init];
                    viewController = controller;
                }
                    break;
                case 1:{
                    XHLoveViewController *controller = [[XHLoveViewController alloc] init];
                                        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                                        controller.uId = [userDefault objectForKey:UID];
                    viewController = controller;
                }
                    break;
               /* case 2:{
                    XHRenwuChengJiuViewController *controller = [[XHRenwuChengJiuViewController alloc] init];
                    viewController = controller;
                }
                    break;*/
                case 2:{
                    XHMyWuPinViewController *controller = [[XHMyWuPinViewController alloc] init];
                    viewController = controller;
                }
                    break;
                case 3:{
                    XHZhuShouIDViewController *controller = [[XHZhuShouIDViewController alloc] init];
                    viewController = controller;
                }
                    break;
                default:
                    break;
            }
        }
            break;

        default:
            break;
    }
    
    [self.tableView reloadData];
    
    if (viewController) {
        [self pushNewViewController:viewController];
    }
}

-(void)jinfenClick:(UIButton *)sender{
    XHKJIFenViewController *control = [[XHKJIFenViewController alloc] init];
    control.delegate = self;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)didClickLoginOut{
    [self setupProfile];
}

- (void)jifenClickZhuanjiFen
{
    self.tabBarController.selectedIndex = 1;
}
@end
