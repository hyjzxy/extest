//
//  MZImageView.m
//  HuaYue
//
//  Created by 崔俊红 on 15/5/6.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZImageView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@implementation MZImageView

- (instancetype)initWithImageURL:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.mImgURL = url;
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
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor colorWithWhite:0.509 alpha:1.000];
    [imageView setImageWithURL:_mImgURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIWindow *mainWin = [UIApplication sharedApplication].keyWindow;
    imageView.frame = mainWin.bounds;
    [mainWin addSubview:imageView];
    imageView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    imageView.alpha = 0.3f;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
        imageView.alpha = 1;
    } completion:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeImageWin:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
}

/**
 *  @author 崔俊红, 15-05-03 11:05:27
 *
 *  @brief  关闭图片
 *  @param sender UITap
 *  @since v1.0
 */
- (void)closeImageWin:(UITapGestureRecognizer*)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        sender.view.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        sender.view.alpha = 0.3f;
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}

@end