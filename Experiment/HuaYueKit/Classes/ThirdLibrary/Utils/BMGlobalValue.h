//
//  BMGlobalValue.h
//  XinCaiFu
//
//  Created by super man on 14-7-23.
//  Copyright (c) 2014年 bluemobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMGlobalValue : NSObject
@property(retain,nonatomic)NSMutableDictionary *dataDic;
+(BMGlobalValue*)sharedClient;
@end
