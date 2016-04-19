//
//  LoveTableViewCell.h
//  HuaYue
//
//  Created by Appolls on 14-12-25.
//
//

#import <UIKit/UIKit.h>

@class LoveTableViewCell;

@protocol LoveTableViewCellDelegate <NSObject>

-(void)buttonBtn:(LoveTableViewCell *)loveCell;

@end

@interface LoveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong,nonatomic)NSString *pId;
@property (strong,nonatomic)NSString *type;//区分类型
@property (strong,nonatomic)NSIndexPath *indexPath;


@property (assign, nonatomic) id<LoveTableViewCellDelegate>delegate;
- (IBAction)buttonBtn:(id)sender;

@end
