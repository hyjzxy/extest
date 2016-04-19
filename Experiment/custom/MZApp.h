//
//  MZApp.h
//  HuaYue
//
//  Created by 崔俊红 on 15/7/6.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MZApp : NSObject
@property (assign, nonatomic) BOOL isTSAddQuest;
@property (assign, nonatomic) BOOL isTSFGWX;
@property (assign, nonatomic) BOOL isTSPPK;
@property (assign, nonatomic) BOOL isTSGS;
@property (assign, nonatomic) BOOL isTSKD;
@property (assign, nonatomic) BOOL isTSNC;
@property (assign, nonatomic) BOOL isTSSM;
@property (assign, nonatomic) BOOL isTW;
@property (assign, nonatomic) BOOL isTSearch;
@property (strong, nonatomic) NSString *deivceToken;
+ (instancetype)share;
@end
