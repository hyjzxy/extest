//
//  XHShiMingRZViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHShiMingRZViewController.h"
#import "ShiMinRulesViewController.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "HYHelper.h"
#import "Masonry.h"
#import "UIView+UIActivityIndicatorForSDWebImage.h"

@interface XHShiMingRZViewController ()<UIWebViewDelegate,UITextFieldDelegate>
{
    UITextField *currentFiled;
    
    NSString    *rzType;
}
@property(nonatomic, strong)NSArray *testArray;

@property (weak, nonatomic) IBOutlet UIScrollView *rzScroll;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;
@property (weak, nonatomic) IBOutlet UITextField *campanyField;
@property (weak, nonatomic) IBOutlet UITextField *zhiwuField;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *otherInfoField;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *guestBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectReadBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;

@end

@implementation XHShiMingRZViewController
//-(void)dealloc{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//#ifdef __IPHONE_5_0
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 5.0)
//    {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
//#endif
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _maskView.hidden = YES;
    [self loadRealInfo];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"实名认证";
    self.tableView.hidden   = YES;
    self.rzScroll.contentSize   = CGSizeMake(320, 550);
    self.rzScroll.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    [self.rzScroll setContentOffset:CGPointMake(0, -50)];
    UIView *tsView = [[UIView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 40.0f)];
    [tsView mTSWithType:kTSSM];
    self.rzScroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tsView];
    tsView.info = @{@"CALL":^(){
        self.rzScroll.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.rzScroll setContentOffset:CGPointMake(0, 0)];
    }};
//    @property (weak, nonatomic) IBOutlet UITextField *realNameField;
//    @property (weak, nonatomic) IBOutlet UITextField *campanyField;
//    @property (weak, nonatomic) IBOutlet UITextField *zhiwuField;
//    @property (weak, nonatomic) IBOutlet UITextField *mobilePhoneField;
//    @property (weak, nonatomic) IBOutlet UITextField *emailField;
//    @property (weak, nonatomic) IBOutlet UITextField *otherInfoField;
    self.realNameField.delegate = self;
    self.campanyField.delegate = self;
    self.zhiwuField.delegate = self;
    self.mobilePhoneField.delegate = self;
    self.emailField.delegate = self;
    self.otherInfoField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.realNameField){
        [self.campanyField becomeFirstResponder];
    }else if (textField == self.campanyField) {
        [self.zhiwuField becomeFirstResponder];
    }else if (textField == self.zhiwuField) {
        [self.mobilePhoneField becomeFirstResponder];
    }else if (textField == self.mobilePhoneField) {
        [self.emailField becomeFirstResponder];
    }else if (textField == self.emailField) {
        [self.otherInfoField becomeFirstResponder];
    }
    return YES;
}

- (void)loadRealInfo
{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}]
                               withUrl:MY_REALINFO_API
                              withType:MY_REALINFO
                               success:^(id infoDic) {
                                   _realNameField.text = N2V(infoDic[@"realname"], @"");
                                   _campanyField.text = N2V(infoDic[@"company"], @"");
                                   _zhiwuField.text = N2V(infoDic[@"position"], @"");
                                   _mobilePhoneField.text = N2V(infoDic[@"phone"], @"");
                                   _emailField.text = N2V(infoDic[@"email"], @"");
                                   _otherInfoField.text = N2V(infoDic[@"info"], @"");
                                   rzType = N2V(infoDic[@"type"], @"");
                                   _userBtn.selected = rzType.intValue == 0;
                                   _guestBtn.selected =  rzType.intValue == 1;
                                   if([[NSUserDefaults standardUserDefaults]boolForKey:AUTH]){
                                       [_submitBtn setTitle:@"修改" forState:UIControlStateNormal];
                                       _realNameField.enabled = NO;
                                       _campanyField.enabled = NO;
                                       _mobilePhoneField.enabled = NO;
                                       _emailField.enabled = NO;
                                       _zhiwuField.enabled = NO;
                                       _userBtn.userInteractionEnabled = NO;
                                       _guestBtn.userInteractionEnabled = NO;
                                       _maskView.hidden = NO;
                                   }
                               }failure:^(id error){}];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark # IBAction
- (IBAction)selectRzType:(id)sender
{//商户还是用户
    UIButton    *curBtn = (UIButton*)sender;
    if (curBtn.tag == self.userBtn.tag) {//用户
        rzType  = @"0";
        self.userBtn.selected   = YES;
        self.guestBtn.selected  = NO;
    }else if (curBtn.tag == self.guestBtn.tag) {//商户
        rzType  = @"1";
        self.userBtn.selected   = NO;
        self.guestBtn.selected  = YES;
    }
}

- (IBAction)completeUp:(id)sender
{//完成信息提交
    if (self.realNameField.text.length <= 0 ||
        self.campanyField.text.length <= 0 ||
        self.emailField.text.length <= 0 ||
        self.zhiwuField.text.length <= 0 ||
        self.otherInfoField.text.length <= 0 ||
        rzType.length <= 0) {
        [BMUtils showError:@"请您完善所有信息！"];
        return;
    }
    
    if (![HYHelper mTestWithReg:REG_TEL withStr:self.mobilePhoneField.text]) {
        [BMUtils showError:@"手机号码不符！"];
        return;
    }
    if (![HYHelper mTestWithReg:REG_EMAIL withStr:self.emailField.text]) {
        [BMUtils showError:@"邮箱不符！"];
        return;
    }
    if (!self.selectReadBtn.selected) {
        [BMUtils showError:@"请阅读《实验认证规则说明》"];
        return;
    }
    
    NSArray     *keyValue   = [MY_IDENTIFI_PARAM componentsSeparatedByString:@","];
    NSString    *uid        = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[uid,self.realNameField.text,self.campanyField.text,self.emailField.text,self.zhiwuField.text,rzType,self.otherInfoField.text,self.mobilePhoneField.text] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_IDENTIFI_API
                                      withType:MY_IDENTIFI
                                       success:^(id responseObject) {
                                           [BMUtils showSuccess:@"成功提交申请"];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
}

- (IBAction)goPrivacy:(id)sender
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.title = @"实验助手认证规则说明";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:vc.view.bounds];
    [vc.view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    [webView addActivityIndicatorWithStyle:UIActivityIndicatorViewStyleGray];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ws.shiyanzhushou.com/html/System/explain.html"]]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)toPotocol:(id)sender {
    UIViewController *vc = [[UIViewController alloc]init];
    vc.title = @"实验助手用户协议";
    UIWebView *webView = [[UIWebView alloc]initWithFrame:vc.view.bounds];
    [vc.view addSubview:webView];
    webView.delegate = self;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    [webView addActivityIndicatorWithStyle:UIActivityIndicatorViewStyleGray];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ws.shiyanzhushou.com/html/System/protocol.html"]]];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView removeActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView removeActivityIndicator];
}


- (IBAction)selectReadClick:(id)sender
{
    UIButton *btn    = (UIButton*)sender;
    
    self.selectReadBtn.selected = !btn.selected;

}

#pragma mark -
- (void)showAlertViewWithMsg:(NSString*)strMsg
{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:nil
                                                     message:strMsg
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil, nil];
    [alert show];
}

@end
