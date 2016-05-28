//
//  xiangqingye.m
//  HuaYue
//
//  Created by douwei-mac on 15/1/25.
//
//

#import "xiangqingye.h"
#import "ApatrinViewController.h"
#import "XHTaoLunViewController.h"
#import "UMSocial.h"
#import "Masonry.h"
#import "MZShare.h"
#import "UIImageView+WebCache.h"
#import "UIAlertView+Block.h"
#import "HYHelper.h"

@interface xiangqingye ()<UMSocialUIDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableDictionary *mData;
@end

@implementation xiangqingye

- (instancetype)initWithData:(NSDictionary*)data title:(NSString *)title type:(int)t{
    if (self = [super init]) {
        self.data = data;
        self.wID = [data[@"id"]intValue];
        self.type = t;
        self.title = title;
    }
    return self;
}
- (instancetype)initWithData:(NSDictionary*)data title:(NSString *)title{
    if (self = [super init]) {
        self.data = data;
        self.wID = [data[@"id"]intValue];
        self.type = 1;
        self.title = title;
    }
    return self;
}


- (instancetype)initWithWID:(int)wID title:(NSString *)title  type:(int)t{
    if (self = [super init]) {
        _wID = wID;
        self.type = t;
        self.title = title;
    }
    return self;
}

- (instancetype)initWithWID:(int)wID title:(NSString *)title{
    if (self = [super init]) {
        _wID = wID;
        self.type = 1;
        self.title = title;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"图层-1-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick:)];
    self.webView = [[UIWebView alloc]init];
    _webView.delegate=self;
    _webView.backgroundColor=[UIColor clearColor];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.directionalLockEnabled = YES;
    [self.view addSubview: _webView];
    __weak xiangqingye *ws = self;
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
        make.centerY.equalTo(ws.view);
    }];
    [self navigationbaritme];
    __block id userId = @0;
    [HYHelper mLoginID:^(id uid) {
        userId = uid?uid:@0;
    }];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    NSArray *keyValue = [FIND_ARTICLE_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",_wID],@(_type),userId,nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_ARTICLE_API withType:FIND_ARTICLE success:^(id responseObject) {
        self.mData=responseObject;
        [self loadWebView];
    } failure:^(id errorString) {
        NSLog(@"%@",errorString);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadWebView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    [super viewWillDisappear:animated];
}


-(void)loadWebView
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?APP_VERSION=1.0",_mData[@"url"]]]]];
        [self.navigationController setToolbarHidden:NO];
        UIToolbar *toolBar = self.navigationController.toolbar;
        self.shareFoodView.frame = CGRectMake(0, 1, VWidth(toolBar), VHeight(toolBar));
        [self.navigationController.toolbar addSubview:self.shareFoodView];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)baoMingBtn:(id)sender {
    
//    ApplyInfoViewController *fc = [[ApplyInfoViewController alloc] initWithNibName:@"ApplyInfoViewController" bundle:nil];
//    fc.catId                    = self.catId;
//    [self.navigationController pushViewController:fc animated:YES];
    
//    [self.navigationController pushViewController:[[ApatrinViewController alloc] init] animated:YES];
}

- (IBAction)taoLunBtn:(id)sender {
     [self.navigationController setToolbarHidden:YES];
    XHTaoLunViewController *control = [[XHTaoLunViewController alloc] initWithWID:self.wID];
    [self.navigationController pushViewController:control animated:YES];
}

- (IBAction)shareBtnClick:(id)sender
{
    [self shareBtnC];
}

- (void)shareClick:(id)sender
{
    [HYHelper mLoginID:^(id uid) {
        if(uid){
            [[UIAlertView mBuildWithTitle:@"提示" msg:@"你确定要分享到实验圈吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
                NSMutableDictionary *params = nil;
                if (_isSuper) {
                    params = [NSMutableDictionary dictionaryWithObjects:@[uid,@(self.wID)] forKeys:@[@"uid",@"id"]];
                }else {
                    params = [NSMutableDictionary dictionaryWithObjects:@[uid,@(self.wID),@(_type)] forKeys:@[@"uid",@"id",@"type"]];
                }
                [[NetManager sharedManager] myRequestParam:params withUrl:kINTERFACE_ADDRESS(@"Found/sharetocircle.html") withType:FIND_ARTICLE success:^(id responseObject) {
                    [BMUtils showSuccess:@"操作成功"];
                } failure:^(id errorString) {
                    [BMUtils showError:errorString];
                }];
            }] show];
        }else {
            [BMUtils showSuccess:@"您还没有登录!"];
        }
    }];
}

-(void)shareBtnC
{
    if (_mData==nil || _mData.count>0) {
        if ([_mData[@"allow_share"]boolValue]) {
            WS(ws);
            [[[UIImageView alloc]init]sd_setImageWithURL:IMG_URL(_mData[@"thumb"]) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    NSString* shareUrl = [NSString stringWithFormat:@"%@?rn=1",_mData[@"url"]];
                    [[MZShare shared]shareInVC:self title:_mData[@"title"]image:image url:shareUrl block:^(NSInteger flag) {
                        [HYHelper mLoginID:^(id uid) {
                            if(uid){
                                [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"id":@(ws.wID),@"type":@(flag)}] withUrl:kINTERFACE_ADDRESS(@"Found/sharecount.html") withType:FIND_ARTICLE success:^(id responseObject) {
                                } failure:^(id errorString) {
                                    [BMUtils showError:errorString];
                                }];
                            }else {
                                [BMUtils showSuccess:@"您还没有登录!"];
                            }
                        }];
                    }];
                }];
            }];
        }else {
            [BMUtils showError:@"该内容无法分享"];
        }
    }
}

-(void)leftNavItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)navigationbaritme
{
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"图层-1-副本"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(shareBtnClick:)];
}
- (IBAction)diaoChaWenJuan:(id)sender {
    
}
@end
