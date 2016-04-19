//
//  MZToast.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/15.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZToast.h"

@interface MZToast ()
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *detailText;
@property (strong, nonatomic) UIImage *tipImage;
@end

@implementation MZToast
{
    UIView *toastView;
    UILabel *titleLabel;
    UILabel *detailLabel;
    UILabel *line;
    CGFloat MAXW;
    CGFloat MAXH;
    UIEdgeInsets edgeInsets;
    NSTimeInterval _delay;
    BOOL isShow;
}

+ (instancetype)shared
{
    static MZToast *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
        [_sharedInstance setup];
    });
    return _sharedInstance;
}

/**
 *  @author 崔俊红, 15-04-15 19:04:18
 *
 *  @brief  初始化
 *  @since v2.0
 */
- (void)setup
{
    MAXH = [UIScreen mainScreen].bounds.size.height - 100.0f;
    MAXW = [UIScreen mainScreen].bounds.size.width - 60.0f;
    edgeInsets = UIEdgeInsetsMake(5, 10, 10, 10);
    toastView = [[UIView alloc]init];
    //toastView.backgroundColor = RGBACOLOR(53.0f, 172.0f, 226.0f,0.8f);
    toastView.backgroundColor = [UIColor colorWithRed:0.242 green:0.307 blue:0.369 alpha:1.000];
    toastView.layer.masksToBounds = YES;
    toastView.layer.cornerRadius  =8.0f;
    toastView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideToast)];
    [toastView addGestureRecognizer:tap];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    
    detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor =  [UIColor whiteColor];
    
    line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [toastView addSubview:line];
}

- (void)showToast
{
     isShow = NO;
    [toastView removeFromSuperview];
    line.frame = CGRectZero;
    titleLabel.text = nil;
    detailLabel.text = nil;
    UIImageView *tipView = nil;
    //if (!_tipImage) {
    //    _tipImage  = [UIImage imageNamed:@"logotip"];
   // }
    tipView = [[UIImageView alloc]initWithImage:_tipImage];
    tipView.layer.cornerRadius = 8.0f;
    tipView.layer.masksToBounds = YES;
    tipView.frame = CGRectMake(0, 0, 25, 25);
    tipView.contentMode = UIViewContentModeScaleAspectFit;
    [toastView addSubview:tipView];
    CGRect titleRect = CGRectZero;
    if (_titleText.length>0) {
        titleRect = [_titleText boundingRectWithSize:CGSizeMake(_tipImage?MAXW-55.0f:MAXW, MAXH) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleLabel.font} context:nil];
        titleLabel.text = _titleText;
        titleLabel.frame = titleRect;
        [toastView addSubview:titleLabel];
    }
    
    CGRect detailRect = CGRectZero;
    if (_detailText.length>0) {
        detailRect = [_detailText boundingRectWithSize:CGSizeMake(MAXW, MAXH) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleLabel.font} context:nil];
        detailLabel.text = _detailText;
        detailLabel.frame = detailRect;
        [toastView addSubview:detailLabel];
    }
    
    BOOL isTitle = NO;
    CGFloat cY = 0.0f;
    CGFloat x = edgeInsets.left;
    CGFloat y = edgeInsets.top;
    if (_tipImage) {
        cY = VHeight(tipView) * 0.5f;
        CGRectSetPoint(tipView, CGPointMake(x, y));
        x = VMaxX(tipView) + 10.0f;
        y = VMaxY(tipView);
    }
    // 计算宽度 高度
    isTitle = !CGRectIsEmpty(titleRect);
    if (isTitle) {
        x = x + VWidth(titleLabel)*0.5f;
        if (cY > titleRect.size.height * 0.5f) {
            titleLabel.center = CGPointMake(x, cY + edgeInsets.top);
        }else {
            cY = VHeight(titleLabel)*0.5f + edgeInsets.top;
            if (_tipImage) {
                tipView.center = CGPointMake(VWidth(tipView)*0.5f+edgeInsets.left, cY);
            }
            titleLabel.center = CGPointMake(x, cY);
             y = VMaxY(titleLabel);
        }
    }
    if (!CGRectIsEmpty(detailRect)) {
        CGRectSetPoint(detailLabel, CGPointMake(edgeInsets.left, y + 20.0f));
    }
    CGFloat maxX = 0.0f;
    CGFloat maxY = 0.0f;
    for (UIView *v in toastView.subviews) {
        maxX = MAX(maxX,VMaxX(v));
        maxY = MAX(maxY,VMaxY(v));
    }
    maxX = MAX(maxX, MAXW-50.0f);
    CGRectSetWidth(titleLabel, maxX);
    CGRectSetWidth(detailLabel, maxX);
    if (_detailText) {
        line.frame = CGRectMake(edgeInsets.left,  MinY(detailLabel) - 10, maxX - edgeInsets.left, 0.5f);
    }
    CGRectSetSize(toastView, CGSizeMake(maxX + edgeInsets.right, maxY+ edgeInsets.bottom));
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    toastView.center = win.center;
    toastView.alpha = 0.1;
    [win addSubview:toastView];
    isShow = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self hideToast];
    });
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        toastView.alpha = 1.0f;
    } completion:nil];
}

- (void)hideToast
{
    if (isShow) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            toastView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
            isShow = NO;
        }];
    }
}

- (void)makeWithText:(NSString*)title detail:(NSString*)detail  tipImage:(UIImage*)tImge duration:(NSTimeInterval)interval
{
    _tipImage = tImge;
    [self makeWithText:title detail:detail duration:interval];
}

- (void)makeWithText:(NSString*)title detail:(NSString*)detail duration:(NSTimeInterval)interval
{
    _detailText = detail;
    [self makeWithText:title duration:interval];
}

- (void)makeWithText:(NSString*)title duration:(NSTimeInterval)interval
{
    _titleText = title;
    _delay = interval;
    [self showToast];
}
@end
