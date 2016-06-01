//
//  MZTextView.m
//  HuaYue
//  自定义聊天输入框
//   v1.0
//  Created by 崔俊红 on 15/5/8.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZChatTextView.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"

@interface MZChatTextView ()<UITextViewDelegate>
@property (strong, nonatomic) NSString *leftText;
@end

@implementation MZChatTextView

/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:59
 *
 *  @brief  leftView禁止点击
 *  @param point 撞击点
 *  @param event 事件
 *  @return 传递对象
 *  @since v1.0
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [_leftText boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    if(CGRectContainsPoint(CGRectMake(-5, 0, rect.size.width+5, 30), point)){
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:34
 *
 *  @brief  重写text
 *  @return mText
 *  @since v1.0
 */
- (NSString*)mText
{
    return [self.text stringByReplacingCharactersInRange:NSMakeRange(0, _leftText.length) withString:@""];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:49
 *
 *  @brief  设置LeftText文本
 *  @param leftTxt 文本
 *  @since v1.0
 */
- (void)mAddLable:(NSString*)leftTxt
{
//    [self clearText];
    NSString* string = self.text;
    [self clearText];
    self.leftText = leftTxt;
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc]init];
    [ma appendAttributedString:[[NSAttributedString alloc]initWithString:leftTxt attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:UIColorFromRGB(0x2EC9FB)}]];
    
    [ma appendAttributedString:[[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:[UIColor colorWithWhite:0.195 alpha:1.000]}]];
//    [ma appendAttributedString:self.attributedText];
    
    
    [ma appendAttributedString:[[NSAttributedString alloc]initWithString:@" " attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:[UIColor colorWithWhite:0.195 alpha:1.000]}]];
    
    
    self.attributedText = ma;
//    [self resetSize];
    [self becomeFirstResponder];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:15
 *
 *  @brief  清除Text
 *  @since v1.0
 */
- (void)clearText
{
    self.leftText = @"";
    self.attributedText = nil;
    self.text = @"";
    self.textColor = [UIColor colorWithWhite:0.195 alpha:1.000];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
    }];
}


/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:30
 *
 *  @brief  初始化
 *  @since v1.0
 */
- (void)didMoveToSuperview
{
    self.delegate = self;
    self.layer.borderColor = [[UIColor colorWithWhite:0.500 alpha:0.200]CGColor];
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.superview.layer.borderColor = [[UIColor colorWithWhite:0.500 alpha:0.200]CGColor];
    self.superview.layer.cornerRadius = 0;
    self.superview.layer.borderWidth = 0.5f;
    self.superview.layer.masksToBounds = YES;
    [self clearText];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-09 19:05:43
 *
 *  @brief  根据输入内容自动适应高度
 *  @since v1.0
 */
- (void)resetSize
{
    // Hack to detect Newlines
    NSString *str = self.text;
    if ([self.text hasSuffix:@"\n"]) {
        str = [self.text stringByAppendingString:@"-"];
    }
    CGFloat broadWith    = (self.contentInset.left + self.contentInset.right
                            + self.textContainerInset.left
                            + self.textContainerInset.right
                            + self.textContainer.lineFragmentPadding/*左边距*/
                            + self.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);
    
    // Calc height
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(self.bounds.size.width - broadWith, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributes context:nil];
    CGFloat h = broadHeight + rect.size.height;
    if(h<30){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@30);
        }];
    }else{
        if (h<120) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(h));
            }];
        }
    }
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self resetSize];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([textView.text isEqual: @""] || textView.text == nil){
        [self clearText];
    }
    return YES;
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
////    if (self.leftText && self.leftText.length>0) {
////        if (range.location<=self.leftText.length) {
////            return NO;
////        }
////    }
//    return YES;
//}
@end
