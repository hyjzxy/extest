//
//  XHBannerViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-12.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBannerViewController.h"
#import "XHFoundationCommon.h"
#import "XHTaoLunViewController.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "ApatrinViewController.h"
#import "ApplyInfoViewController.h"
#import "Masonry.h"
#import "MZShare.h"
#import "HYHelper.h"

@interface XHBannerViewController ()<UMSocialUIDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)NSDictionary *dataDic;
@property(nonatomic, strong)UIAlertView *myAlertView;
@property(nonatomic, strong)UIWebView *contentWeb;
@end

@implementation XHBannerViewController

- (instancetype)initWithWID:(int)wID title:(NSString *)title withType:(int)type{
    if (self = [super init]) {
        _wID = wID;
        _type = type;
        self.title = title;
    }
    return self;
}
- (void)loadView{
    [super loadView];
    self.myAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要登入后才能查看，请先登入" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    self.myAlertView.delegate = self;
    [self performSelector:@selector(delay) withObject:nil afterDelay:0.02f];
    
}
- (void)delay
{
    [self loadDetailData];;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentWeb = [[UIWebView alloc]init];
    _contentWeb.scrollView.showsHorizontalScrollIndicator = NO;
    _contentWeb.scrollView.directionalLockEnabled = YES;
    CGRectExtTop(self.contentWeb, 50.0f);
    [self.view addSubview:self.contentWeb];
    WS(ws);
    [_contentWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
        make.centerX.equalTo(ws.view.mas_centerX);
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureBarbuttonItemStyle:XHBarbuttonItemStyleCamera action:^(){
        
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"图层-1-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(shareClick:)];
    
    NSArray *listMainView = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil];
    
    UIView *view = (UIView *)listMainView[4];
    UIButton *taoLun = (UIButton *)[view viewWithTag:5000];
    UIButton *apartIn = (UIButton *)[view viewWithTag:5001];
    [apartIn addTarget:self action:@selector(taoLun:) forControlEvents:UIControlEventTouchUpInside];
    [taoLun addTarget:self action:@selector(taoLun:) forControlEvents:UIControlEventTouchUpInside];
    view.frame = CGRectMake(0, 0, 320, 50);
    [self.navigationController.toolbar addSubview:view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillDisappear:animated];
}
- (void)shareClick:(UIButton *)sender{
    [self initShareSdk];
}

- (void)initShareSdk{
    if (_dataDic==nil || _dataDic.count>0) {
        if ([_dataDic[@"allow_share"]boolValue]) {
            [[[UIImageView alloc]init]sd_setImageWithURL:IMG_URL(_dataDic[@"thumb"]) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [[MZShare shared]shareInVC:self title:_dataDic[@"title"]image:image url:_dataDic[@"url"] block:nil];
                }];
            }];
        }else {
            [BMUtils showError:@"该内容无法分享"];
        }
    }
}



-(void)loadDetailData{
    __block id userId = @0;
    [HYHelper mLoginID:^(id uid) {
        userId = uid?uid:@0;
    }];
    WS(ws);
    NSArray *keyValue = [FIND_ARTICLE_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@(_wID), @(_type),userId,nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_ARTICLE_API withType:FIND_ARTICLE success:^(id responseObject){
        ws.dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [ws.contentWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?APP_VERSION=1.0",ws.dataDic[@"url"]]]]];
        }];
    }failure:^(id error){
        [BMUtils showError:error];
    }];

}
-(void)taoLun:(UIButton *)sender{
     if(![HYHelper mLoginID:nil]){
        [self.myAlertView show];
        return;
    }
    if (sender.tag == 5000) {
        XHTaoLunViewController *control = [[XHTaoLunViewController alloc] initWithWID:self.wID];
        [self.navigationController pushViewController:control animated:YES];
    }else if (sender.tag == 5001){
        
        ApplyInfoViewController *fc = [[ApplyInfoViewController alloc] initWithNibName:@"ApplyInfoViewController" bundle:nil];
        fc.catId = self.catId;
        fc.wid = self.wID;
        [self.navigationController pushViewController:fc animated:YES];
    }else{
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
