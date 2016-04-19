//
//  MZCTabView.h
//  HuaYue
//
//  Created by 崔俊红 on 15/6/2.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZCTabView : UIView
@property (strong, nonatomic) NSMutableArray *btns;
- (instancetype)initWithTitles:(NSArray*)titles blocks:(NSArray*)blocks;
@end
