//
//  XHContactTableViewCell.m
//  MessageDisplayExample
//
//  Created by dw_iOS on 14-5-22.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactTableViewCell.h"
#import "MyLabel.h"
@implementation XHContactTableViewCell


#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        self.label.backgroundColor = UIColorFromRGB(0x2EC9FB);
        self.label.textColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    _recommendIV = [UIImageView new];
    _recommendIV.image = [UIImage imageNamed:@"answer_ recommend"];
    [self.contentView addSubview:_recommendIV];
    [_recommendIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-30);
        make.width.equalTo(@76);
        make.height.equalTo(@60);
        
    }];
    [self.contentView bringSubviewToFront:_recommendIV];
    _recommendIV.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
