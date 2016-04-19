//
//  UIResponder+Common.h
//  VMDai
//
//  Created by 朱亮亮 on 14-11-24.
//  Copyright (c) 2014年 Monica Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Common)

/**
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param object  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)routerEventWithName:(NSString *)eventName object:(id)object;

@end
