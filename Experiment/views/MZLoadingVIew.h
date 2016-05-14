//
//  MZLoadingVIew.h
//  HuaYue
//
//  Created by Gideon on 16/5/14.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLoadingVIew : UIView

@property (nonatomic,strong) NSString* loadingText;

- (void)show;
- (void)dissMiss;

@end
