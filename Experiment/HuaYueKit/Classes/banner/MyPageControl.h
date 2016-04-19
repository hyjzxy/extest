//
//  MyPageControl.h
//  RongYi
//
//  Created by 潘鸿吉 on 13-5-27.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}

- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end
