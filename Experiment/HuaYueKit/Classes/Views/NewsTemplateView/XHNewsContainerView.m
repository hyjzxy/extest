//
//  XHNewsContainerView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsContainerView.h"

@implementation XHNewsContainerView

#pragma mark - Propertys

- (UILabel *)newsSummeryLabel {
    if (!_newsSummeryLabel) {
        _newsSummeryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.bounds) - 80, 50)];
        _newsSummeryLabel.numberOfLines = 1;
        _newsSummeryLabel.font = [UIFont boldSystemFontOfSize:15];
        _newsSummeryLabel.textColor = [UIColor grayColor];
        _newsSummeryLabel.backgroundColor = [UIColor clearColor];
        _newsSummeryLabel.text = @"秋季如何补水?";
    }
    return _newsSummeryLabel;
}

- (UIImageView *)newsThumbailImageView {
    if (!_newsThumbailImageView) {
        _newsThumbailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 60, 10, 50, 30)];
        _newsThumbailImageView.image = [UIImage imageNamed:@"日报"];
    }
    return _newsThumbailImageView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.newsSummeryLabel];
        [self addSubview:self.newsThumbailImageView];
    }
    return self;
}

@end
