//
//  MZChatView.m
//  HuaYue
//
//  Created by 崔俊红 on 15/5/25.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZChatView.h"
#import "BMUtils.h"
#import "Masonry.h"

@implementation MZChatView

- (void)instKey
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification*)noti
{
    if (self.hidden == YES) return;
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat h = CGRectGetHeight(rect);
    WS(ws);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.superview).with.offset(-h);
        }];
    });
}

- (void)keyboardDidShow:(NSNotification*)noti
{
    if (_delegate && [_delegate respondsToSelector:@selector(startInput)]) {
        [_delegate startInput];
    }
}

- (void)keyboardWillHide:(NSNotification*)noti
{
    if (self.hidden == YES) return;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    WS(ws);
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.superview.mas_bottom);
    }];
    [UIView commitAnimations];
}


/**
 *  @author 麦子, 15-05-25 17:05:02
 *
 *  @brief  发送信息
 *
 *  @param sender UIButton
 *
 *  @since v1.0
 */
- (IBAction)sendAct:(id)sender {
    NSString *mMsg = _chatTV.mText;
    if (mMsg.length == 0) {
        [BMUtils showError:@"请输入发送消息"];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(sendMsg:)]) {
            [_delegate sendMsg:_chatTV.mText];
            [_chatTV clearText];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
