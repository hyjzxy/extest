//
//  NSUserDefaults+Block.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Block)
+(void)saveData:(userdefaults_block_t)block;
@end
