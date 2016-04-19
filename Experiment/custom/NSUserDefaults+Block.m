//
//  NSUserDefaults+Block.m
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "NSUserDefaults+Block.h"

@implementation NSUserDefaults (Block)

/**
 *  @author 崔俊红, 15-04-12 14:04:17
 *
 *  @brief  <#Description#>
 *  @param userDefaultsBlock <#userDefaultsBlock description#>
 *  @since <#version number#>
 */
+ (void)saveData:(userdefaults_block_t)userDefaultsBlock
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    userDefaultsBlock(userDefaults);
    [userDefaults synchronize];
}

@end
