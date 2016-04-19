//
//  MZImageView.h
//  HuaYue
//
//  Created by 崔俊红 on 15/5/6.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZImageView : UIImageView
@property (strong, nonatomic) NSURL *mImgURL;
- (instancetype)initWithImageURL:(NSURL*)url;
@end