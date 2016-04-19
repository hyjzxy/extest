//
//  MZImageView.m
//  HuaYue
//
//  Created by 崔俊红 on 15/5/6.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "HYHelper.h"
#import "Masonry.h"

@interface MZImageView ()
@property (nonatomic, assign) NSInteger noti;
@property (nonatomic, strong) UILabel *notiView;
@end

@implementation MZImageView

- (instancetype)initWithImageURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.mImgURL = url;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)didMoveToSuperview
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

/**
 *  @author 崔俊红, 15-05-03 09:05:44
 *
 *  @brief  查看图片
 *  @param sender UITap
 *  @since v1.0
 */
- (void)showImage:(UITapGestureRecognizer*)tapGes
{
    if (_mImgURL!=nil || self.image != nil) {
       [HYHelper mShowImage:_mImgURL m:self];
    }
}
@end