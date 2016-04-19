//
//  UIView+Cate.h
//  HuaYue
//
//  Created by 崔俊红 on 15/4/20.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^mzm_block_t) (id m);

typedef NS_ENUM(NSInteger, TSType) {
    kTSAddQuest = 0,
    kTSFGWX,
    kTSPPK,
    kTSGS,
    kTSKD,
    kTSNC,
    kTSSM,
    kTW,
    kTSearch
};

@interface UIView (Cate)
@property (strong, nonatomic) mzm_block_t tapBlock;

- (void)mTSWithType:(TSType)tsType;
- (UIViewController*)viewController;
- (void) addGestureRecognizerToView;
@end
