//
//  HuiDaWyTableViewCell.h
//  HuaYue
//
//  Created by Appolls on 15-1-9.
//
//

#import <UIKit/UIKit.h>
//#import "XHMyButton.h"
@class XHMyButton;
@interface HuiDaWyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XHMyButton *myHead;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *huida;
@property (weak, nonatomic) IBOutlet UIButton *take;

@end
