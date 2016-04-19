//
//  XHProtocolViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHProtocolViewController.h"
#import "Masonry.h"

@interface XHProtocolViewController ()

@end

@implementation XHProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用条款和隐私政策";
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, VWidth(self.view), VHeight(self.view))];
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    NSString *html = [[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:@"Potocal.html"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:html]]];
    [self.view addSubview:webView];
    WS(ws);
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
        make.centerX.equalTo(ws.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

@end
