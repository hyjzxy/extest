//
//  XHShouTipsTableViewCell.m
//  HuaYue
//
//  Created by Appolls on 14-12-12.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHShouTipsTableViewCell.h"

@implementation XHShouTipsTableViewCell


#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        
        self.headerImg = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        [self.headerImg setImage:[UIImage imageNamed:@"defaultImg"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.headerImg];
        
        UIImage *image = [UIImage imageNamed:@"commit_other"];
        
        self.text = [[UIButton alloc] initWithFrame:CGRectMake(45, 20, 205, 64)];
        [self.text setBackgroundImage:image forState:UIControlStateNormal];
        [self.text setBackgroundImage:[image stretchableImageWithLeftCapWidth:20 topCapHeight:30] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.text];
        
        self.textT = [[MyLabel alloc] initWithFrame:CGRectMake(60, 25, 182.5, 55) withText:@"屈臣氏有没有好的深层清洁的面膜，推荐一下？" withPosition:NSTextAlignmentLeft withFontSize:13 withColor:[UIColor grayColor] withBackColor:nil];
        
        self.textT.numberOfLines = 0;

        [self.contentView addSubview:self.textT];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
