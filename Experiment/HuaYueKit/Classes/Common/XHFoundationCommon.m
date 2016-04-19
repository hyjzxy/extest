//
//  XHFoundationCommon.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-28.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHFoundationCommon.h"

@implementation XHFoundationCommon

+ (CGFloat)getAdapterHeight {
    CGFloat adapterHeight = 114;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 94;
    }
    return adapterHeight;
}

+ (CGFloat)getAdapterNavHeight {
    CGFloat adapterHeight = 64;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] < 7.0) {
        adapterHeight = 44;
    }
    return adapterHeight;
}

@end
