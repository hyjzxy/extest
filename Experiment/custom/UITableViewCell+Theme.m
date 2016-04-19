//
//  UITableViewCell+Theme.m
//  HuaYue
//
//  Created by 崔俊红 on 15/6/17.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "UITableViewCell+Theme.h"

@implementation UITableViewCell (Theme)

- (void)touchTheme:(id)n
{
    if (self.selectionStyle != UITableViewCellSelectionStyleBlue) {
        UIView *v = [[UIView alloc]initWithFrame:self.bounds];
        v.backgroundColor = UIColorFromRGB(0xECEDF1);
        self.selectedBackgroundView = v;
    }
}

@end
