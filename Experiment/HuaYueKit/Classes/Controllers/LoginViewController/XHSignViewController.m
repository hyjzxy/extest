//
//  XHSignViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHSignViewController.h"
#import "XHProtocolViewController.h"
#import "XHLoveViewController.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "MZApp.h"

@interface XHSignViewController ()

@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, assign) int          number;
@property (assign, nonatomic) NSInteger sex;

@end

@implementation XHSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    self.sex = 1;
    self.myScroll.contentSize   = CGSizeMake(320, 500);
    self.codeBtn.layer.cornerRadius = 4;
    UILabel *time = [[UILabel alloc]initWithFrame:_codeBtn.bounds];
    time.hidden = YES;
    time.backgroundColor = [UIColor clearColor];
    time.textColor = [UIColor blackColor];
    time.textAlignment = NSTextAlignmentCenter;
    time.font = SYSTEMFONT(14.0f);
    time.tag = 999;
    [_codeBtn addSubview:time];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(realLoad) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}

- (IBAction)sexAct:(UISegmentedControl*)sender {
    self.sex = sender.selectedSegmentIndex;
}

- (IBAction)maleFemaleBtn:(id)sender {
    
   /* UIButton *button = (UIButton *)sender;
    self.male.selected = button == self.male;
    self.frmale.selected = !self.male.selected;
    [self.male setBackgroundImage:self.male.selected ? [UIImage imageNamed:@"maleFemaleS"]:[UIImage imageNamed:@"maleFemale"] forState:UIControlStateNormal];
    [self.frmale setBackgroundImage:self.frmale.selected ? [UIImage imageNamed:@"maleFemaleS"]:[UIImage imageNamed:@"maleFemale"] forState:UIControlStateNormal];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)isNull:(NSString *)string{
    
    if(string == nil || [string isEqualToString:@""]){
        return NO;
    }
    
    return YES;
}

- (IBAction)signBtn:(id)sender {
    if([self isNull:self.phoneNumber.text] || [self isNull:self.passWd.text] || [self isNull:self.name.text] || [self isNull:self.vCode.text]){
        if(self.sex == 0){//
            self.sex = 1;
        }
        NSArray *keyValue = [MY_SIGN_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:WYISBLANK(self.phoneNumber.text),WYISBLANK(self.vCode.text),WYISBLANK(self.passWd.text),WYISBLANK(self.name.text),WYISBLANK(self.someBody.text),[MZApp share].deivceToken,@(self.sex),nil] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:MY_SIGN_API
                                          withType:MY_SIGN
                                           success:^(id responseObject){
                                               //将登录信息保存本地
                                               NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                                               [userDefault setBool:YES forKey:@"Remember"];
                                               [userDefault setBool:YES forKey:@"IsAutoLogin"];
                                               [userDefault setValue:dic[@"phone"] forKey:USERLGN];
                                               [userDefault setValue:dic[@"password"] forKey:USERPWD];
                                               [userDefault setValue:[responseObject objectForKey:@"nickname"] forKey:USERNAME];
                                               [userDefault setValue:[responseObject objectForKey:@"head"] forKey:USERHEAD];
                                               [userDefault setValue:[responseObject objectForKey:@"sex"] forKey:SEX];
                                               [userDefault setValue:[responseObject objectForKey:@"id"] forKey:UID];
                                               [userDefault setValue:[responseObject objectForKey:@"integral"] forKey:INTEGRAL];
                                               [userDefault setValue:[responseObject objectForKey:@"invitation"] forKey:INVITATION];
                                               
                                               [userDefault synchronize];
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"wangyu" object:nil userInfo:nil];
                                               [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                                               [MobClick endEvent:@"register"];
                                               XHLoveViewController *love = [[XHLoveViewController alloc] init];
                                               love.uId = [responseObject objectForKey:@"id"];
                                               love.isSign = YES;
                                               [self pushNewViewController:love];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
    }else{
        [BMUtils showError:@"请输入完整信息"];
    }
    
}
- (IBAction)vCodeBtn:(id)sender {
    
    if(self.phoneNumber.text == nil || [self.phoneNumber.text isEqualToString:@""]){
        [BMUtils showError:@"请输入手机号"];
        return;
    }
    NSArray *keyValue = [MY_GETCODE_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:WYISBLANK(self.phoneNumber.text),nil] forKeys:keyValue];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_GETCODE_API withType:MY_GETCODE success:^(id responseObject){
        [self startTimers];
        [BMUtils showSuccess:@"验证码发送成功"];
    }failure:^(id error){
        _codeBtn.enabled = YES;
        [_timer setFireDate:[NSDate distantPast]];
        [BMUtils showError:error];
    }];
    
    
    
    
}

- (IBAction)tiaoKuanBtn:(id)sender {
    
    XHProtocolViewController *protol = [[XHProtocolViewController alloc] init];
    [self pushNewViewController:protol];
    
}

#pragma mark - timer
-(void)startTimers {
    self.codeBtn.enabled = NO;
    self.number = 60;
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)realLoad {
    _number = _number - 1;
    [_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d\")",_number] forState:UIControlStateDisabled];
    if (_number == 0){
        _codeBtn.enabled = YES;
        [_timer setFireDate:[NSDate distantPast]];
    }
}

@end
