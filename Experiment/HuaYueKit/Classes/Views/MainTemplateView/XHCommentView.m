//
//  XHCommentView.m
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHCommentView.h"
#import "XHNewsTableViewController.h"

@implementation XHCommentView

- (void)setAltView:(NSArray *)list
{
    self.textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    self.textFiled.leftView = nil;
    
    UIView *leftView = [[UIView alloc] init];
    
    CGFloat offset_X = 0;
    for (int i = 0; i < list.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = self.textFiled.font;
        label.textColor = RGBCOLOR(70, 189, 227);
        
        NSDictionary *dict = [list objectAtIndex:i];
        NSString *content = [NSString stringWithFormat:@"@%@",[dict objectForKey:@"nickname"]];
        
        CGFloat w = ceil([self labelWidth:content font:label.font labelHeight:self.textFiled.frame.size.height]);
        CGRect rect = label.frame;
        rect.origin.x = offset_X;
        rect.origin.y = 0;
        rect.size.height = CGRectGetHeight(self.textFiled.frame);
        rect.size.width = w;
        
        label.frame = rect;
        
        offset_X = offset_X + w + 2;
        
        label.text = content;
        
        [leftView addSubview:label];
    }
    
    leftView.frame = CGRectMake(0, 0, offset_X, CGRectGetHeight(self.textFiled.frame));
    
    self.textFiled.leftView = leftView;
    
}

- (CGFloat)labelWidth:(NSString *)s font:(UIFont *)font labelHeight:(CGFloat)height
{
    CGSize size  = CGSizeMake(20000, height);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelsize.width;
}

- (IBAction)clickCame:(id)sender
{
    [((XHNewsTableViewController *)self.delegate) clickCamr];
}
- (IBAction)clickAlt:(id)sender
{
    [((XHNewsTableViewController *)self.delegate) clickAlt];
}
- (IBAction)answerBtn:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(replayCommentAxtion:)]){
        
        [((XHNewsTableViewController *)self.delegate) replayCommentAxtion:@""];
    }
}
@end
