//
//  MZTextView.h
//  HuaYue
//
//  Created by 崔俊红 on 15/5/8.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZChatTextView : UITextView
- (NSString*)mText;
- (void)clearText;
- (void)mAddLable:(NSString*)leftTxt;
@end
