//
//  HYRadioGroupView.h
//  HuaYue
//
//  Created by 崔俊红 on 15-4-5.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYRadioGroupView : UIView
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title problem:(NSDictionary*)problem;
@end
