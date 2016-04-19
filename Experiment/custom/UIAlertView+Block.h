//
//  UIAlertView+Block.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^alert_block_t)(void);

@interface UIAlertView (Block)
@property (strong, nonatomic) alert_block_t okBlock;
@property (strong, nonatomic) alert_block_t cancelBlock;
+ (instancetype)mBuildWithTitle:(NSString*)title msg:(NSString*)message okTitle:(NSString*)okTitle noTitle:(NSString*)noTitle cancleBlock:(alert_block_t)cancleBlock okBlock:(alert_block_t)okBlock;
@end
