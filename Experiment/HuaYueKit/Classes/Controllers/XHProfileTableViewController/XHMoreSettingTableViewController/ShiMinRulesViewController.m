//
//  ShiMinRulesViewController.m
//  HuaYue
//
//  Created by tianzhenkuan on 15/1/31.
//
//

#import "ShiMinRulesViewController.h"

@interface ShiMinRulesViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ShiMinRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    self.title = @"实名认证规则和说明";
    self.scrollView.contentSize = CGSizeMake(320, 550);
    _webView.hidden = YES;
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"实验助手实名认证说明" ofType:@"htm"];
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
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
