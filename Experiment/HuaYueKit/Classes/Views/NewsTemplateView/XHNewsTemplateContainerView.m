//
//  XHNewsTemplateContainerView.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsTemplateContainerView.h"

#import "XHNewsContainerView.h"


@interface XHNewsTemplateContainerView ()



@end

@implementation XHNewsTemplateContainerView

#pragma mark - Propertys

//- (UIImageView *)backgroundImageView {
//    if (!_backgroundImageView) {
//        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _backgroundImageView.image = XH_STRETCH_IMAGE([UIImage imageNamed:@"NewsBackgroundImage"], UIEdgeInsetsMake(7, 7, 7, 7));
//    }
//    return _backgroundImageView;
//}

- (UIImageView *)topNewsImageView {
    if (!_topNewsImageView) {
        _topNewsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 20, 90)];
        _topNewsImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage"];
        _topNewsImageView.contentMode = UIViewContentModeCenter;
        [_topNewsImageView addSubview:self.topNewsTitleLabel];
    }
    return _topNewsImageView;
}
- (UILabel *)topNewsTitleLabel {
    if (!_topNewsTitleLabel) {
        _topNewsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_topNewsImageView.bounds) - 23, CGRectGetWidth(_topNewsImageView.bounds), 23)];
        _topNewsTitleLabel.backgroundColor = RGBCOLOR(83, 83, 83);
        _topNewsTitleLabel.textColor = [UIColor whiteColor];
        _topNewsTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _topNewsTitleLabel.text = @"    原生态森林越来越少，存在哪些隐患";
    }
    return _topNewsTitleLabel;
}

- (UIImageView *)sepatorImageViewWithWidth:(CGFloat)width {
    UIImageView *sepatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
    sepatorImageView.image = [UIImage imageNamed:@"line"];
    return sepatorImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIImageView *sepatorImageView = [self sepatorImageViewWithWidth:CGRectGetWidth(self.bounds)];
        CGRect sepatorImageViewFrame = sepatorImageView.frame;
        sepatorImageViewFrame.origin.y = CGRectGetMaxY(self.topNewsImageView.frame) + 10;
        sepatorImageView.frame = sepatorImageViewFrame;
        [self addSubview:sepatorImageView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepatorImageViewFrame), CGRectGetWidth(self.bounds), 50 * 1)];
        for (int i = 0; i < 1; i ++) {
            XHNewsContainerView *currentNewsView = [[XHNewsContainerView alloc] initWithFrame:CGRectMake(0, i * 50, CGRectGetWidth(_containerView.bounds), 50)];
            if (i < 2) {
                UIImageView *sepatorImageView = [self sepatorImageViewWithWidth:CGRectGetWidth(self.bounds)];
                CGRect sepatorImageViewFrame = sepatorImageView.frame;
                sepatorImageViewFrame.origin.y = CGRectGetMaxY(currentNewsView.frame);
                sepatorImageView.frame = sepatorImageViewFrame;
                [_containerView addSubview:sepatorImageView];
            }
            [_containerView addSubview:currentNewsView];
        }
    }
    return _containerView;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self addSubview:self.backgroundImageView];
        [self addSubview:self.topNewsImageView];
        [self addSubview:self.containerView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
