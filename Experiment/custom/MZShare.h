//
//  MZShare.h
//  HuaYue
//
//  Created by 崔俊红 on 15/5/26.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^share_block)(NSInteger);

@interface MZShare : NSObject
+ (instancetype)shared;
- (void)shareInVC:(UIViewController*)vc title:(NSString*)title image:(UIImage *)image url:(NSString*)url block:(share_block)block;
@end
