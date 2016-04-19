//
//  NSObject+Block.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-29.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock: (dispatch_block_t)block afterDelay: (NSTimeInterval)delay;
- (void)performBlockOnMainThread: (dispatch_block_t)block;
- (void)performBlockInBackground: (dispatch_block_t)block;

@end
