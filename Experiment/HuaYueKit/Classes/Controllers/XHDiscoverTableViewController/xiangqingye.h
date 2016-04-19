//
//  xiangqingye.h
//  HuaYue
//
//  Created by douwei-mac on 15/1/25.
//
//

#import <UIKit/UIKit.h>
#import "NetManager.h"
#import "UIImageView+WebCache.h"
#import "XHBaseViewController.h"
@interface xiangqingye : XHBaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *framLabel;
@property (strong, nonatomic) IBOutlet UIView *webHeaderView;
@property (strong, nonatomic) IBOutlet UIButton *wenJuanBtn;
- (IBAction)diaoChaWenJuan:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *wenjuandiaochaView;
@property (strong, nonatomic) IBOutlet UIView *foodView;
@property (strong, nonatomic) IBOutlet UIView *shareFoodView;
@property(nonatomic, assign)int wID;
@property(nonatomic, assign)int type;
@property(nonatomic, assign)BOOL isSuper;
- (instancetype)initWithWID:(int)wID title:(NSString *)title;
- (instancetype)initWithData:(NSDictionary*)data title:(NSString *)title type:(int)t;
- (instancetype)initWithData:(NSDictionary*)data title:(NSString *)title;
- (instancetype)initWithWID:(int)wID title:(NSString *)title  type:(int)t;
- (IBAction)baoMingBtn:(id)sender;
- (IBAction)taoLunBtn:(id)sender;
- (IBAction)shareBtnClick:(id)sender;

@end
