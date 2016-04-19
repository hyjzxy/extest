//
//  UserSingleton.h
//  Les
//
//  Created by 朱亮亮 on 14-11-4.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYUserModel.h"

@interface UserSingleton : NSObject

/**
 *  单例
 *
 *  @return user对象
 */
+ (WYUserModel *) userDefault;

@end
