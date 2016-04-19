//
//  ApplyInfoViewController.m
//  HuaYue
//
//  Created by tianzhenkuan on 15/2/1.
//
//

#import "ApplyInfoViewController.h"
#import "HYHelper.h"

#define ApplyInfoPath [NSHomeDirectory() stringByAppendingString:@"/Library/Preferences/ApplyInfo.dat"]

@interface ApplyInfoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;

@end

@implementation ApplyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title  = @"报名人资料";
    self.tableView.hidden   = YES;
    self.scrollView.contentSize = CGSizeMake(320, 416);
    
    NSArray *cachData   = [NSArray arrayWithContentsOfFile:ApplyInfoPath];
    if (cachData.count == 4) {
        self.userNameTextFiled.text = cachData[0];
        self.phoneTextField.text = cachData[1];
        self.emailTextField.text = cachData[2];
        self.companyTextField.text = cachData[3];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提交
- (IBAction)commitClick:(id)sender {
    if (self.userNameTextFiled.text.length <= 0 ||
        self.companyTextField.text.length <= 0 ||
        self.phoneTextField.text.length <= 0 ||
        self.emailTextField.text.length <= 0) {
        [self showAlertViewWithMsg:@"请您完善所有信息！"];
        return;
    }
    if(![HYHelper mTestWithReg:REG_TEL withStr:_phoneTextField.text]){
        [BMUtils showError:@"手机号码不合法"];
        return;
    }
    if(![HYHelper mTestWithReg:REG_EMAIL withStr:_emailTextField.text]){
        [BMUtils showError:@"电子邮箱不合法"];
        return;
    }
    NSArray     *keyValue   = [FIND_ENTER_PARAM componentsSeparatedByString:@","];
    NSString    *uid        = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSLog(@"INVITATION<<<<<<<<%@", uid);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[uid,self.catId?:@"",self.userNameTextFiled.text,self.phoneTextField.text,self.emailTextField.text,self.companyTextField.text,@(self.wid)] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:FIND_ENTER_API
                                      withType:FIND_ENTER
                                       success:^(id responseObject) {
                                           
                                           NSLog(@"%@",responseObject);
                                           
                                           NSArray  *data   = @[self.userNameTextFiled.text,self.phoneTextField.text,self.emailTextField.text,self.companyTextField.text];
                                           [data writeToFile:ApplyInfoPath atomically:YES];
                                           [BMUtils showSuccess:@"提交成功"];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];

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
