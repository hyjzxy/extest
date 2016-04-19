//
//  taoLunCommentView.m
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "taoLunCommentView.h"
#import "XHTaoLunViewController.h"
@implementation taoLunCommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)answerBtn:(id)sender {
    if([self.delegate respondsToSelector:@selector(replayCommentAxtion:)]){
        [((XHTaoLunViewController *)self.delegate) replayCommentAxtion:@""];
    }
}
@end
