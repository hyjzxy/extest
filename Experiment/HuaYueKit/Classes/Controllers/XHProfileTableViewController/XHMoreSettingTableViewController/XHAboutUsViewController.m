//
//  XHAboutUsViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHAboutUsViewController.h"

@interface XHAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currRight;

@end

@implementation XHAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    self.title = @"关于软件";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _currRight.text = [NSString stringWithFormat:@"版本号：%@",version];
    // Do any additional setup after loading the view from its nib.
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

@end
