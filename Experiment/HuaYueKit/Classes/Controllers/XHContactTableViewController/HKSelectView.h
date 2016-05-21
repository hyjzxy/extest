//
//  HKSelectView.h
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSelectDetailView.h"

@class HKSelectView;

@protocol HKSelectViewDelegate <NSObject>

- (void)selectView:(HKSelectView*)selectView selectIndex:(NSInteger)index subindex:(NSInteger)subindex;

@end

@interface HKSelectView : UIView

@property (nonatomic,strong) NSArray* titleArray;
//@property (nonatomic,strong) NSMutableArray* detailArray;
@property (nonatomic,strong) NSArray* stateArray;
@property (nonatomic,strong) NSArray* classifyArray;
@property (nonatomic,strong) NSArray* sonArray;
@property (assign,nonatomic) id<HKSelectViewDelegate> delegate;
@end
