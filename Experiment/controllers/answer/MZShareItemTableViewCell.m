//
//  MZShareItemTableViewCell.m
//  HuaYue
//
//  Created by chulaihai on 2/26/16.
//  Copyright © 2016 麦子收割队. All rights reserved.
//

#import "MZShareItemTableViewCell.h"
#import "MBProgressHUD.h"
#import "NetManager.h"

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
        NSString* uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        if (self.indexPath.row > 0 && self.data[@"id"] != nil
             && [self.data[@"auid"] integerValue] == [uid integerValue]) {
            UIMenuItem *copyItem2 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteItemClick:)];
            [menu setMenuItems:[NSArray arrayWithObjects:copyItem,copyItem2,nil]];
        }else{
            [menu setMenuItems:[NSArray arrayWithObjects:copyItem,nil]];
        }
        
         UIView *contentV = (UIView*)VIEWWITHTAG(self, 104);
        
        [menu setTargetRect:contentV.bounds inView:contentV];
        [menu setMenuVisible:YES animated:YES];
    }
}

#pragma mark 处理action事件
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action ==@selector(copyItemClicked:)){
        return YES;
    }else if (action==@selector(deleteItemClick:)){
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
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
//    // 通知代理
//    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self];
//    [self addSubview:HUD];
//    HUD.label.text = @"复制成功";
//    HUD.mode = MBProgressHUDModeText;
//    
//    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
//      // HUD.yOffset = -100.0f;
//       // HUD.xOffset = 0.0f;
//    
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//        //        [HUD release];
//        //HUD = nil;
//    }];
    
}

-(void)deleteItemClick:(id)sender{
    if (((NSString*)self.data[@"aid"]).integerValue == 0){
        [[UIAlertView mBuildWithTitle:@"确认删除" msg:@"是不是确认删除所有回答内容?" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
            [self deleteMessage];
        }]show];
    }else{
        [self deleteMessage];
    }
    
}

- (void)deleteMessage{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    //    NSLog(@"datas:%@",self.data);
    NSNumber* aid = self.data[@"id"];
    
    //#define ANSWER_DELETE @"删除回答"
    //#define ANSWER_DELETE_API kINTERFACE_ADDRESS(@"Answer/answeredel.html")
    //#define ANSWER_DELETE_PARAM  @"uid,aid"
    NSString *urlStr = ANSWER_DELETE_API;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@(uid.integerValue),aid] forKeys:@[@"uid",@"aid"]];
    NSString *urtType = ANSWER_DELETE;
    NSLog(@"%@",params);
    [[NetManager sharedManager] myRequestParam:params withUrl:urlStr withType:urtType success:^(id responseObject) {
        if (self.deleteSuccess != nil ){
            self.deleteSuccess();
        }
        NSLog(@"responseObject:%@",responseObject);
    } failure:^(id errorString) {
        //        [MBProgressHUD sho]
        [SVProgressHUD showWithStatus:@"删除失败"];
        //        UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"删除失败" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //        [alterView show];
        //        NSLog(@"errorString:%@",errorString);
    }];
}


@end
