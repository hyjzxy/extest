//
//  MZChatView.h
//  HuaYue
//
//  Created by 崔俊红 on 15/5/25.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZChatTextView.h"

@protocol ChatDelegate <NSObject>

- (void)startInput;
- (void)sendMsg:(NSString*)text;

@end

@interface MZChatView : UIView
@property (weak, nonatomic) id<ChatDelegate> delegate;
@property (weak, nonatomic) IBOutlet MZChatTextView *chatTV;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (void)instKey;
@end
