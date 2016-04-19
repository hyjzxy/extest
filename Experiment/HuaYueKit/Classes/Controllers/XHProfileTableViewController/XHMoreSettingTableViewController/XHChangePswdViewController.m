//
//  XHChangePswdViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHChangePswdViewController.h"

@interface XHChangePswdViewController ()
@property(nonatomic, weak) IBOutlet UITextField *oldPwd;
@property(nonatomic, weak) IBOutlet UITextField *changeWd1;
@property(nonatomic, weak) IBOutlet UITextField *changeWd2;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation XHChangePswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
//    [self setUpRightBtnWithTitle:@"保存"];
//    self.tableView.rowHeight = 44;
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.scroll.contentSize = CGSizeMake(320, 504);
    
    self.tableView.hidden   = YES;
    
    // Do any additional setup after loading the view.
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
- (IBAction)commitBtnAction:(id)sender {
    [self serviceConnect];
}

- (void)serviceConnect{
//    DLog(@"%@", self.nickNameField.text);
    if (self.oldPwd.text.length == 0 || [self.oldPwd.text isEqualToString:@""]) {
        [BMUtils showError:@"原密码不能为空"];
        return;
    }
    if (self.changeWd1.text.length == 0 || [self.changeWd1.text isEqualToString:@""]) {
        [BMUtils showError:@"新密码不能为空"];
        return;
    }
    if (self.changeWd2.text.length == 0 || [self.changeWd2.text isEqualToString:@""] || !([self.changeWd2.text isEqualToString:self.changeWd1.text])) {
        [BMUtils showError:@"两次输入的密码不一样"];
        return;
    }
    NSArray *keyValue = [MY_MODIFYPW_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],self.oldPwd.text,self.changeWd2.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_MODIFYPW_API withType:MY_MODIFYPW success:^(id responseObject){
        //将登录信息保存本地
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
//        [userDefault setValue:self.nickNameField.text forKey:USERNAME];
        //        [userDefault setValue:@"1" forKey:HUAYUE_ISLOGIN];
//        [userDefault synchronize];
        
        //        [scrollView removeFromSuperview];
        
        //        [self configuraTableViewNormalSeparatorInset];
        [BMUtils showSuccess:@"修改成功"];
        self.oldPwd.text = @"";
        self.changeWd1.text = @"";
        self.changeWd2.text = @"";
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

@end
