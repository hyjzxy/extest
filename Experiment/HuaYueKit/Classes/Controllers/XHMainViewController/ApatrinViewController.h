//
//  ApatrinViewController.h
//  HuaYue
//
//  Created by lee on 15/1/18.
//
//

#import <UIKit/UIKit.h>
#import "XHCollectionViewController.h"
@interface ApatrinViewController : UIViewController

- (IBAction)senderBtn:(id)sender;

@property(strong,nonatomic) NSString*_IDStr;


@property (weak, nonatomic) IBOutlet UITextField *lianxirenLabel;
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressLable;

@property (weak, nonatomic) IBOutlet UITextField *campanyLabel;
@end
