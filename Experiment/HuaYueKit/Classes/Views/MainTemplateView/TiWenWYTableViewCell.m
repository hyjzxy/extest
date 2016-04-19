//
//  TiWenWYTableViewCell.m
//  HuaYue
//
//  Created by Appolls on 15-1-9.
//
//

#import "TiWenWYTableViewCell.h"

@implementation TiWenWYTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.myHead.layer.cornerRadius = 20;
    self.myHead.layer.masksToBounds = YES;
    self.myHead.layer.cornerRadius = 19;
    self.myHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
