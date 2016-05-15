//
//  MZShareItemTableViewCell.m
//  HuaYue
//
//  Created by chulaihai on 2/26/16.
//  Copyright © 2016 麦子收割队. All rights reserved.
//

#import "MZShareItemTableViewCell.h"
#import "MBProgressHUD.h"

@implementation MZShareItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer
{
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu=[UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyItemClicked:)];
        UIMenuItem *copyItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(copyItemClicked:)];
//        copyItem2.tag = 1000
//        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClicked:)];
      //  UIMenuItem *resendItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(resendItemClicked:)];
        [menu setMenuItems:[NSArray arrayWithObjects:copyItem,copyItem2,nil]];
         UIView *contentV = (UIView*)VIEWWITHTAG(self, 104);
        
        [menu setTargetRect:contentV.bounds inView:contentV];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark 处理action事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(copyItemClicked:)){
        return YES;
    }else if (action==@selector(resendItemClicked:)){
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}
#pragma mark  实现成为第一响应者方法
-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark method

-(void)copyItemClicked:(id)sender{
    
    UIMenuController* item = sender;
    NSLog(@"%@",item.menuItems);
    [UIPasteboard generalPasteboard].string = self.content;
    // 通知代理
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:HUD];
    HUD.label.text = @"复制成功";
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
      // HUD.yOffset = -100.0f;
       // HUD.xOffset = 0.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //        [HUD release];
        //HUD = nil;
    }];
    
}
-(void)deleteClick:(id)sender{
}




@end
