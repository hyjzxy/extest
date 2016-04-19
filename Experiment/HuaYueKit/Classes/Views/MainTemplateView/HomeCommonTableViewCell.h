//
//  HomeCommonTableViewCell.h
//  HuaYue
//
//  Created by 赵广龙 on 15-1-27.
//
//

#import <UIKit/UIKit.h>
@class XHMyButton;
@interface HomeCommonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet XHMyButton *myHead;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
