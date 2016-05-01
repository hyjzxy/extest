//
//  HKSegView.h
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKSegView;

@protocol HKSegViewDelegete <NSObject>

- (void)segViewSelectIndex:(NSInteger)index SegView:(HKSegView*)segView;

@end

@interface HKSegView : UIView

@property(nonatomic,strong)NSArray* titleArray;
@property(nonatomic,strong)UIColor* normalColor;
@property(nonatomic,strong)UIColor* selectColor;
@property(nonatomic,strong)UIColor* normalBackgroundColor;
@property(nonatomic,strong)UIColor* selectBackgroundColor;
@property(nonatomic,strong)UIFont* font;
@property(assign,nonatomic) NSInteger selectTag;
@property(nonatomic,assign)NSInteger selectIndex;//默认选中
@property(nonatomic,assign)id<HKSegViewDelegete> delegate;

@end
