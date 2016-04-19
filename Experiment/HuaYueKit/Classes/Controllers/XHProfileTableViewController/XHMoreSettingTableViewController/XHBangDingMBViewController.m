//
//  XHBangDingMBViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHBangDingMBViewController.h"

@interface XHBangDingMBViewController ()
@property(nonatomic, strong)UITextField *moblePhoneTexfield;
@end

@implementation XHBangDingMBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    [self setUpRightBtnWithTitle:@"保存"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"XHMoreMyFavoritesTableViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"settingView" owner:nil options:nil];
        cell = cellList[3];
        
    }
    self.moblePhoneTexfield = cell.contentView.subviews[0];
    return cell;
    
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
- (void)clickedBarButtonItemAction{
    [self serviceConnect];
}
- (void)serviceConnect{
    DLog(@"%@", self.moblePhoneTexfield.text);
    if (self.moblePhoneTexfield.text.length == 0 || [self.moblePhoneTexfield.text isEqualToString:@""]) {
        [BMUtils showError:@"手机号码不能为空"];
        return;
    }
    NSArray *keyValue = [MY_PHONE_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],self.moblePhoneTexfield.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_PHONE_API withType:MY_PHONE success:^(id responseObject){
        //将登录信息保存本地
//        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//        
//        [userDefault setValue:self.nickNameField.text forKey:USERNAME];
//        //        [userDefault setValue:@"1" forKey:HUAYUE_ISLOGIN];
//        [userDefault synchronize];
        
        //        [scrollView removeFromSuperview];
        
        //        [self configuraTableViewNormalSeparatorInset];
        
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

@end
