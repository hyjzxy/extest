//
//  HYTextView.h
//  HuaYue
//
//  Created by 崔俊红 on 15-4-1.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYTextView : UITextView<UITextViewDelegate>
@property (strong, nonatomic) dispatch_block_t beginEditBlock;
- (void)setPlacehold:(NSString *)placehold;
@end
