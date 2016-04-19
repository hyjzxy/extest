//
//  XHZhuShouIDViewController.h
//  HuaYue
//
//  Created by lee on 15/1/19.
//
//

#import <UIKit/UIKit.h>

@interface XHZhuShouIDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *zhushouID;
@property (weak, nonatomic) IBOutlet UILabel *yiyaoqingrenshu;
@property (weak, nonatomic) IBOutlet UILabel *keyaoqingrenshu;
@property (weak, nonatomic) IBOutlet UILabel *zongyaoqingrenshu;
@property (weak, nonatomic) IBOutlet UILabel *yidabaiwangyou;
@property (weak, nonatomic) IBOutlet UILabel *updateDate;
- (IBAction)sendDuanxin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendWechat;
- (IBAction)sendWechat:(id)sender;

@end
