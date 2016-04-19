//
//  XHSSLoadViewController.m
//  HuaYue
//
//  Created by lee on 15/1/13.
//
//

#import "XHSSLoadViewController.h"

@interface XHSSLoadViewController ()

@end

@implementation XHSSLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫下载";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
