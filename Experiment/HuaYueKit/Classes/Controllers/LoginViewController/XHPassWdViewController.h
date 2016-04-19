//
//  XHPassWdViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHBaseViewController.h"

@interface XHPassWdViewController : XHBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passwd;
@property (weak, nonatomic) IBOutlet UITextField *vCode;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

- (IBAction)confirm:(id)sender;
- (IBAction)sendcode:(id)sender;
@end
