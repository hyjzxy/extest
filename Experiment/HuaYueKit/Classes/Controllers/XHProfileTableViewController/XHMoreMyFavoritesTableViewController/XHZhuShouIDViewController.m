//
//  XHZhuShouIDViewController.m
//  HuaYue
//
//  Created by lee on 15/1/19.
//
//

#import <MessageUI/MFMessageComposeViewController.h>
#import "XHZhuShouIDViewController.h"
#import "NetManager.h"
#import "BMUtils.h"
#import "UMSocial.h"
#import "MZShare.h"
@interface XHZhuShouIDViewController ()<UMSocialUIDelegate,MFMessageComposeViewControllerDelegate>
@property(nonatomic, strong)NSMutableArray *dic;
@end

@implementation XHZhuShouIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    self.title = @"我的助手ID";
    [self loadZhushouID];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadZhushouID{
    NSArray *keyValue = [MY_ID_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    
    self.dic = [[NSMutableArray alloc] init];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_ID_API withType:MY_ID success:^(id responseObject){
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        
        self.zhushouID.text = [userDefault objectForKey:INVITATION];
        self.yiyaoqingrenshu.text = [NSString stringWithFormat:@"%d", [responseObject[@"wnum"] intValue]];
        self.keyaoqingrenshu.text = [NSString stringWithFormat:@"%d", [responseObject[@"snum"] intValue]];
        self.zongyaoqingrenshu.text = [NSString stringWithFormat:@"%d", [responseObject[@"total"] intValue]];
        self.yidabaiwangyou.text = [NSString stringWithFormat:@"%d％", [responseObject[@"value"] intValue]];
        self.updateDate.text = [NSString stringWithFormat:@"%d", [responseObject[@"days"] intValue]];
    }failure:^(id error){
        [BMUtils showError:error];
        
    }];
}

- (IBAction)sendWechat:(id)sender
{
    [self initShareSdk];
}

- (IBAction)sendDuanxin:(id)sender
{
    [self messageShare];
}

- (void)initShareSdk{
    NSString *str = [NSString stringWithFormat:@"实验助手，实验室从业人员的专属社区，邀请码%@，赶快来加入我们吧！", self.zhushouID.text];
    [[MZShare shared]shareInVC:self title:str image:[UIImage imageNamed:@"share-logo"] url:APPSTOREURL block:nil];
}


#pragma mark 短信的代理方法
//短信
- (void)messageShare
{
    NSString *str = [NSString stringWithFormat:@"实验助手，实验室从业人员的专属社区。邀请码%@，注册时别忘填写邀请人哦~app store搜索实验助手，或点此链接下载%@", self.zhushouID.text,APPSTOREURL];
    
    MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc]init];
    if([MFMessageComposeViewController canSendText]) {
        
        NSLog(@"短信分享 begin");
        
        [mcvc setBody:str];
        
        mcvc.messageComposeDelegate = self;
        
        [self presentViewController:mcvc animated:YES completion:nil];

        NSLog(@"短信分享 end");
    }
}

#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if(result == MessageComposeResultSent) {
        [BMUtils showSuccess:@"短信发送成功"];
    }else if(result == MessageComposeResultCancelled ||
             result == MessageComposeResultFailed) {
        
        }
}

@end
