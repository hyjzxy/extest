//
//  HYBannerView.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-29.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseView.h"
@protocol HYBannerViewDataSource <NSObject>
@optional
- (NSArray*)bannerDatas;
@end

@protocol HYBannerViewDelegate <NSObject>
- (void)bannerView:(id)bannerView selectedData:(NSInteger)index;
- (void)buildImageView:(UIImageView*)imageView index:(NSInteger)index;
@end

@interface HYBannerView : HYBaseView
@property (weak, nonatomic) id<HYBannerViewDataSource> dataSource;
@property (weak, nonatomic) id<HYBannerViewDelegate> delegate;
- (void)reloadData;
@end


