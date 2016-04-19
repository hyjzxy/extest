//
//  MZTip.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/19.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZTip.h"

@interface MZTip ()
@end
@implementation MZTip

+ (instancetype)shared
{
    static MZTip *__sharedInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInst = [[MZTip alloc]init];
    });
    return __sharedInst;
}

- (void)showWithTitle:(NSString*)title msg:(NSString*)msg
{
    if (msg) {
         [self makeWithTitle:title msg:msg];
    }
}

- (void)makeWithTitle:(NSString*)title msg:(NSString*)msg
{
    UILabel *titleLabel = nil;
    UILabel *msgLabel = nil;
    UIView *tipView = [[UIView alloc]init];
    CGFloat width = [UIScreen mainScreen].bounds.size.width -60.0f;
    UIColor *titleColor = RGBCOLOR(249.0f, 90.0f, 75.0f);
    UIFont *titleFont = [UIFont systemFontOfSize:20 weight:15];
    UIFont *msgFont = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *mParag = [[NSMutableParagraphStyle alloc]init];
    mParag.firstLineHeadIndent = 20.0f;
    mParag.headIndent = 20;
    mParag.tailIndent = width - mParag.headIndent;
    mParag.alignment = NSTextAlignmentCenter;
    mParag.lineBreakMode = NSLineBreakByCharWrapping;
    
    UIView *main = [UIApplication sharedApplication].keyWindow;
    tipView.frame = Rect(0, 0, width, 35.0f);
    [main addSubview:tipView];
    
    // 标题图标
    NSTextAttachment *tipTextAtt = [[NSTextAttachment alloc]init];
    tipTextAtt.image = [UIImage imageNamed:@"tip-info"];
    tipTextAtt.bounds = Rect(0, -8, 30, 30);
    NSMutableAttributedString *titleAtts = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:tipTextAtt]];

    [titleAtts appendAttributedString:[[NSAttributedString alloc]initWithString:[@"  " stringByAppendingString:title] attributes:@{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:titleColor}]];
    titleLabel = [[UILabel alloc]initWithFrame:Rect(0, 0, width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.attributedText = titleAtts;
    [tipView addSubview:titleLabel];
    
    // 分割线
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tip-sep"]];
    line.frame = Rect(0 , 0, width-20, 1);
    [tipView addSubview:line];
    
    // 消息内容
    NSDictionary *attr = @{NSFontAttributeName:msgFont,NSParagraphStyleAttributeName:mParag};
    CGRect msgRect = [msg boundingRectWithSize:Size(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    msgLabel = [[UILabel alloc]initWithFrame:Rect(0, 0, width, msgRect.size.height)];
    msgLabel.numberOfLines = 0;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
    msgLabel.attributedText = [[NSAttributedString alloc]initWithString:msg attributes:attr];
    [tipView addSubview:msgLabel];
    
    // 计算大小 布局
    titleLabel.frame = CGRectOffset(titleLabel.frame, 0, 0);
    line.frame = CGRectOffset(line.frame, 10, VMaxY(titleLabel)+5);
    msgLabel.frame = CGRectOffset(msgLabel.frame, 0, VMaxY(line)+10);
    CGRectSetSize(tipView, Size(width, VMaxY(msgLabel)+10));
    // 背景
    UIImageView *bgImgView = [[UIImageView alloc]init];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    bgImgView.frame = tipView.bounds;
    bgImgView.image = [UIImage imageNamed:@"tip-bg"];
    [tipView insertSubview:bgImgView atIndex:0];
    tipView.alpha = 1.0f;
    tipView.center = main.center;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            tipView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [tipView removeFromSuperview];
        }];
    });
}
@end
