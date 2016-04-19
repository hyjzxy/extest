//
//  MZToast.h
//  HuaYue
//
//  Created by 崔俊红 on 15/4/15.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MZToastDuration) {
    mzShort=2,mzLong = 5,mzLongLong=15
};

@interface MZToast : NSObject
+ (instancetype)shared;

- (void)makeWithText:(NSString*)title detail:(NSString*)detail  tipImage:(UIImage*)tImge duration:(NSTimeInterval)interval;
- (void)makeWithText:(NSString*)title detail:(NSString*)detail duration:(NSTimeInterval)interval;
- (void)makeWithText:(NSString*)title duration:(NSTimeInterval)interval;

@end
