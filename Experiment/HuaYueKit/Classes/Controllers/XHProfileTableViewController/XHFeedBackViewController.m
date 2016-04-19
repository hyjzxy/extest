//
//  XHFeedBackViewController.m
//  HuaYue
//
//  Created by lee on 15/1/21.
//
//

#import "XHFeedBackViewController.h"
#import "NetManager.h"
#import "BMUtils.h"
@interface XHFeedBackViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation XHFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    self.title = @"意见反馈";
    self.scroll.contentSize = CGSizeMake(320, 500);
    self.content.delegate   =  self.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendFeedBack:(id)sender {
    [self clickedLeftAction];
}

-(void)clickedLeftAction{
    NSArray *keyValue = [FEEDBACK_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],self.content.text,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:FEEDBACK_API withType:FEEDBACK success:^(id responseObject){
        [BMUtils showSuccess:@"反馈成功"];
        self.content.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}

@end
