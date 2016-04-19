//
//  XHNewsTemplateContainerView.h
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kXHNewsTemplateContainerViewHeight 170
#define kXHNewsTemplateContainerViewSpacing 23
#define kTableViewFrameX 25
@interface XHNewsTemplateContainerView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *topNewsImageView;
@property (nonatomic, strong) UILabel *topNewsTitleLabel;
@property (nonatomic, strong) UIView *containerView;

@end
