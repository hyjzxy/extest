//
//  DDActionSheet.m
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import "DDActionSheet.h"
//#import "Defines.h"

@interface DDAlertButton : UIButton

@end

@implementation DDAlertButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setTitleColor:[UIColor darkGrayColor]
                    forState:UIControlStateNormal];
        [super setTitleColor:[UIColor blackColor]
                    forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    
}

@end
@implementation DDActionSheet

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    NSInteger index = [super addButtonWithTitle:title];
    if (IS_IOS_7) {
        return index;
    }
    
    UIButton *button = [DDAlertButton buttonWithType:UIButtonTypeCustom];
    [super addSubview:button];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitle:title
            forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 2.0;
    
    NSMutableArray *buttons = (NSMutableArray*)[self valueForKeyPath:@"_buttons"];
    UIButton *originButton = [buttons objectAtIndex:index];
    id target = originButton.allTargets.anyObject;
    NSArray *actions = [originButton actionsForTarget:target
                                      forControlEvent:originButton.allControlEvents];
    [button addTarget:target
               action:NSSelectorFromString(actions.lastObject)
     forControlEvents:originButton.allControlEvents];
    button.tag = originButton.tag;
    [buttons replaceObjectAtIndex:index
                       withObject:button];
    return index;
}

- (void)addSubview:(UIView *)view
{
    if (!IS_IOS_7 && [view isKindOfClass:[UIButton class]])
        return;

    [super addSubview:view];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (IS_IOS_7)
        return;
    
    UILabel *lable = (UILabel*)[self valueForKey:@"_titleLabel"];
    lable.textColor = [UIColor darkGrayColor];
    lable.shadowColor = [UIColor whiteColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithWhite:0.9
                       alpha:0.8] setFill];
    CGContextFillRect(context, rect);
}

@end
