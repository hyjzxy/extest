//
//  XHChangeNickNameViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHChangeNickNameViewController.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"

@interface XHChangeNickNameViewController ()
@property(nonatomic, strong)UITextField *nickNameField;
@end

@implementation XHChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改昵称";
    [self setUpRightBtnWithTitle:@"保存"];
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    self.tableView.tableHeaderView = tsView;
    tsView.info = @{@"CALL":^(){
        self.tableView.tableHeaderView = nil;
    }};
    [tsView mTSWithType:kTSNC];
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
    self.nickNameField = (UITextField *)[cell viewWithTag:501];

    self.nickNameField.layer.cornerRadius = 4;
    
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
    DLog(@"点我了");
    [self serviceConnect];
}
- (void)serviceConnect{
    DLog(@"%@", self.nickNameField.text);
    if (self.nickNameField.text.length == 0 || [self.nickNameField.text isEqualToString:@""]) {
        [BMUtils showError:@"昵称不能为空"];
        return;
    }
    NSArray *keyValue = [MY_MODIFYNAME_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],self.nickNameField.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_MODIFYNAME_API withType:MY_MODIFYNAME success:^(id responseObject){
        //将登录信息保存本地
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
        [userDefault setValue:self.nickNameField.text forKey:USERNAME];
//        [userDefault setValue:@"1" forKey:HUAYUE_ISLOGIN];
        [userDefault synchronize];
        [BMUtils showSuccess:@"修改成功"];
        //        [scrollView removeFromSuperview];
        
        //        [self configuraTableViewNormalSeparatorInset];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

@end
