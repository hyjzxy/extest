//
//  HKSegView.m
//  HuaYue
//
//  Created by Gideon on 16/5/1.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "HKSegView.h"

@implementation HKSegView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeRoundCorner];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor clearColor];
        if (!self.selectColor) {
            self.selectColor = UIColorFromRGB(0x20ACF4);
        }
        if (!self.normalColor) {
            self.normalColor = [UIColor whiteColor];
        }
        
        if (!self.selectBackgroundColor) {
            self.selectBackgroundColor = [UIColor whiteColor];
        }
        if (!self.normalBackgroundColor) {
            self.normalBackgroundColor = UIColorFromRGB(0x20ACF4);
        }
        self.selectTag = 0;
        if (!self.font)
        {
            self.font = [UIFont systemFontOfSize:15];
        }
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    for (UIView* view in self.subviews) {
        if (view.tag >= 99)
        {
            [view removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        
        button.frame = CGRectMake(self.width/self.titleArray.count*i, 0, self.width/self.titleArray.count, self.height);
        [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setBackgroundColor:self.normalBackgroundColor];
        
        button.titleLabel.font = self.font;
        //        if (!IS_IPHONE_6P) {
        //            button.titleLabel.font = XZFont(15);
        //        }
        
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
            self.selectTag = 100+i;
            [button setBackgroundColor:self.selectBackgroundColor];
        }
        [self addSubview:button];
    }
}

- (void)buttonAction:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (self.selectTag == button.tag)
    {
        return;
    }
    
    UIButton* oldButton = (UIButton*)[self viewWithTag:self.selectTag];
    oldButton.selected = NO;
    oldButton.backgroundColor = self.normalBackgroundColor;
    
    button.selected = YES;
    button.backgroundColor = self.selectBackgroundColor;
    self.selectTag = button.tag;
    
    [self.delegate segViewSelectIndex:self.selectTag-100 SegView:self];
}

- (void)setSelectTag:(NSInteger)selectTag
{
    _selectTag = selectTag;
    _selectIndex = selectTag - 100;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex > self.titleArray.count) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton* button = (UIButton*)[self viewWithTag:(selectIndex+100)];
    [self buttonAction:button];
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    for (UIView* view in self.subviews)
    {
        if (view.tag >= 100)
        {
            UIButton* button = (UIButton*)view;
            [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        }
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    for (UIView* view in self.subviews)
    {
        if (view.tag >= 100)
        {
            UIButton* button = (UIButton*)view;
            [button setTitleColor:self.normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIView* view in self.subviews)
    {
        if (view.tag >= 100)
        {
            UIButton* button = (UIButton*)view;
            button.titleLabel.font = font;
        }
    }
}

- (void)setSelectBackgroundColor:(UIColor *)selectBackgroundColor
{
    _selectBackgroundColor = selectBackgroundColor;
    UIButton* button = (UIButton*)[self viewWithTag:self.selectTag];
    button.backgroundColor = self.selectBackgroundColor;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    for (UIView* view in self.subviews)
    {
        if (view.tag >= 100 && view.tag != self.selectTag)
        {
            UIButton* button = (UIButton*)view;
            button.backgroundColor = self.normalBackgroundColor;
        }
    }
}

@end
