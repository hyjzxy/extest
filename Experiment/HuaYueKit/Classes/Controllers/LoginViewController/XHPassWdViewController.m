//
//  XHPassWdViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHPassWdViewController.h"
#import "IQKeyboardManager.h"
#import "SVProgressHUD.h"

@interface XHPassWdViewController ()

@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, assign) int          number;

@end

@implementation XHPassWdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    self.title = @"找回密码";
    self.codeBtn.layer.cornerRadius = 4;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(realLoad) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirm:(id)sender {
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    if (![self.phoneNumber.text length]) {
        [BMUtils showError:@"电话号码为空"];
        return;
    }
    if (![self.vCode.text length]) {
        [BMUtils showError:@"验证码为空"];
        return;
    }
    if (![self.passwd.text length]) {
        [BMUtils showError:@"密码为空"];
        return;
    }
    [self findPwdConnection];
}

- (IBAction)sendcode:(id)sender {
    
    if (![self.phoneNumber.text length]) {
        [BMUtils showError:@"手机号为空"];
        return;
    }
    [SVProgressHUD  showWithMaskType:SVProgressHUDMaskTypeClear];
    [self sendercodeConnection];
}
- (void)sendercodeConnection{
    NSArray *keyValue = [MY_GETCODE_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.phoneNumber.text,nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_GETCODEFORFINDPW_API withType:MY_GETCODE success:^(id responseObject){
        self.number = 60;
        _codeBtn.enabled = NO;
        [_codeBtn setTitle:@"重新获取(60\")" forState:UIControlStateDisabled];
        [self.timer setFireDate:[NSDate distantPast]];
        [BMUtils showSuccess:@"验证码已发送"];
    }failure:^(id error){
        _codeBtn.enabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        [BMUtils showError:error];
    }];
    
}

- (void)findPwdConnection{
    NSArray *keyValue = [MY_FINDPW_PARAM componentsSeparatedByString:@","];
    //    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.phoneNumber.text, self.vCode.text, self.passwd.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_FINDPW_API withType:MY_FINDPW success:^(id responseObject){
        [BMUtils showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

#pragma mark - timer

-(void)realLoad {
    _number = _number - 1;
    [_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d\")",_number] forState:UIControlStateDisabled];
    if (_number == 0){
        _codeBtn.enabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

@end
