//
//  XHNewsTemplateTableViewCell.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsTemplateTableViewCell.h"
#import "MyLabel.h"

@implementation XHNewsTemplateTableViewCell

#pragma mark - Properrtys

- (XHNewsTemplateContainerView *)newsTemplateContainerView {
    if (!_newsTemplateContainerView) {
        _newsTemplateContainerView = [[XHNewsTemplateContainerView alloc] initWithFrame:CGRectMake(kXHNewsTemplateContainerViewSpacing, kXHNewsTemplateContainerViewSpacing+40, CGRectGetWidth([[UIScreen mainScreen] bounds]) - kXHNewsTemplateContainerViewSpacing * 2, kXHNewsTemplateContainerViewHeight)];
        _newsTemplateContainerView.backgroundColor = [UIColor whiteColor];
        _newsTemplateContainerView.layer.cornerRadius = 2;
    }
    return _newsTemplateContainerView;
}

#pragma mark - Life Cycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        MyLabel *label = [[MyLabel alloc] initWithFrame:CGRectMake(100, 20, 120, 20) withText:@"11月2号 早上9:09" withPosition:NSTextAlignmentCenter withFontSize:12 withColor:[UIColor whiteColor] withBackColor:RGBCOLOR(211, 211, 211)];
        [self.contentView addSubview:label];
        [self.contentView addSubview:self.newsTemplateContainerView];
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
