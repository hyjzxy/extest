//
//  UIButton+CheckBox.m
//  点点赚™
//  分类为： CheckBox  RadioBox
//  复选框  单选按钮
//
//  Created by 崔俊红 on 14-7-2.
//  Copyright (c) 2014年 麦子收割队. All rights reserved.
//

#import "CheckBtn.h"

@implementation CheckBtn

- (BOOL)checked
{
    return self.selected;
}

- (void)setChecked:(BOOL)checked
{
    self.selected = checked;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.checked = !self.checked;
    [super touchesEnded:touches withEvent:event];
}

@end
