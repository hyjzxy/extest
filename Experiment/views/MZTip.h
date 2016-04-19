//
//  MZTip.h
//  HuaYue
//
//  Created by 崔俊红 on 15/4/19.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CTipType) {
    cTipInfo,cTipError
};
@interface MZTip : NSObject

+ (instancetype)shared;
- (void)showWithTitle:(NSString*)title msg:(NSString*)msg;
@end
