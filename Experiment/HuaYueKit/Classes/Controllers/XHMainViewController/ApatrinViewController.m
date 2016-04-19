//
//  ApatrinViewController.m
//  HuaYue
//
//  Created by lee on 15/1/18.
//
//

#import "ApatrinViewController.h"
#import "IQKeyboardManager.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "HYHelper.h"

#define TakeUserInfoDat @"TakeUserInfo.dat"


@interface ApatrinViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ApatrinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货人资料";
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    self.scrollView.contentSize = CGSizeMake(320, 400);
    NSDictionary *takeUserInfo = [NSDictionary dictionaryWithContentsOfFile:NSDocFilePath(TakeUserInfoDat)];
    if (takeUserInfo.allKeys.count > 0) {
        
        self.lianxirenLabel.text    = takeUserInfo[@"name"];
        self.mobilePhoneLabel.text  = takeUserInfo[@"phone"];
        self.emailLabel.text        = takeUserInfo[@"email"];
        self.addressLable.text      = takeUserInfo[@"address"];
        self.campanyLabel.text      = takeUserInfo[@"company"];
    }
    
    UIView *tsView = [[UIView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 30)];
    [self.view addSubview:tsView];
    [tsView mTSWithType:kTSKD];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)senderBtn:(id)sender {
    [[IQKeyboardManager sharedManager]resignFirstResponder];
    if (self.lianxirenLabel.text.length <= 0 ||
        self.campanyLabel.text.length <= 0 ||
        self.mobilePhoneLabel.text.length <= 0 ||
        self.emailLabel.text.length <= 0 ||
        self.addressLable.text.length <= 0) {
        [BMUtils showError:@"请您完善所有信息！"];
        return;
    }
    
    if (![HYHelper mTestWithReg:REG_TEL withStr:self.mobilePhoneLabel.text]) {
        return [BMUtils showError:@"请输入合法手机号码！"];
    }
    if (![HYHelper mTestWithReg:REG_EMAIL withStr:self.emailLabel.text]) {
        return [BMUtils showError:@"请输入合法邮箱地址！"];
    }
    NSArray *keyValue = [PRODUC_CH_PARAM componentsSeparatedByString:@","];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:
                                [NSArray arrayWithObjects:
                                 uid,
                                 self._IDStr,
                                 self.lianxirenLabel.text,
                                 self.mobilePhoneLabel.text,
                                 self.addressLable.text,
                                 self.emailLabel.text,self.campanyLabel.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:PRODUC_CH_API
                                      withType:PRODUC_CH
                                       success:^(id responseObject) {
                                           [dic writeToFile:NSDocFilePath(TakeUserInfoDat) atomically:YES];
                                           [BMUtils showSuccess:@"提交成功"];
                                           [self.navigationController popViewControllerAnimated:YES];
                                           // 刷新商城信息
                                           [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshGoods" object:nil];
                                       } failure:^(id errorString) {
                                           [BMUtils showError:errorString];
                                       }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
