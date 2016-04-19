//
//  XHSignViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHBaseViewController.h"

@interface XHSignViewController : XHBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *vCode;
@property (weak, nonatomic) IBOutlet UITextField *passWd;
@property (weak, nonatomic) IBOutlet UITextField *name;
//@property (weak, nonatomic) IBOutlet UIButton *male;

@property (weak, nonatomic) IBOutlet UITextField *someBody;
//@property (weak, nonatomic) IBOutlet UIButton *frmale;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
- (IBAction)signBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tiaoKuan;

@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *myScroll;
- (IBAction)vCodeBtn:(id)sender;
- (IBAction)tiaoKuanBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@end
