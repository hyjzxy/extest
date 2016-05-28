//
//  UILabel+BackColor.m
//  HuaYue
//
//  Created by Gideon on 16/5/28.
//  Copyright © 2016年 麦子收割队. All rights reserved.
//

#import "UILabel+BackColor.h"

@implementation UILabel(BackColor)

- (void)setColorWithText:(NSString*)text
{
    if ([text hasPrefix:@"食品"]){
        self.backgroundColor = UIColorFromRGB(0xB6D989);
    }else if([text hasPrefix:@"药品"]){
        self.backgroundColor = UIColorFromRGB(0x65C2ED);
    }else if([text hasPrefix:@"医疗"]){
        self.backgroundColor = UIColorFromRGB(0xF4CC52);
    }else if([text hasPrefix:@"仪器"]){
        self.backgroundColor = UIColorFromRGB(0xEA846E);
    }else if([text hasPrefix:@"职场"]){
        self.backgroundColor = UIColorFromRGB(0xB6ABE5);
    }else {
        self.backgroundColor = UIColorFromRGB(0xEC90B7);
    }
}
@end
