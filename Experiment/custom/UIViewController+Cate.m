//
//  UIViewController+Cate.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/22.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "UIViewController+Cate.h"
#import "HYHelper.h"
#import "NetManager.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIViewController (Cate)

- (NSString*)mUid
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UID];
}

- (void)resetNoti:(NSNumber*)type
{
    id uid = [self mUid];
    [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithObjects:@[uid,type] forKeys:[MY_UPDATTIME_PARAM componentsSeparatedByString:@","]] withUrl:MY_UPDATTIME_API withType:MY_UPDATTIME success:nil failure:nil];
    [self updateSysNoto];
}

- (void)updateSysNoto
{
    
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    DailyBoothViewController *rootVC = delegate.tabbarView;
    NSInteger findSumT = rootVC.dNum + rootVC.wNum + rootVC.pNum + rootVC.tNum;
    rootVC.findCountLabel.hidden = !(findSumT>0);
    rootVC.findCountLabel.text = @(findSumT).stringValue;
    if (findSumT > 0 && findSumT != rootVC.findSum) {
        AudioServicesPlaySystemSound(1007);
        rootVC.findSum = findSumT;
    }
    
    NSInteger meSumT = rootVC.aNum + rootVC.fNum + rootVC.mNum + rootVC.qNum + rootVC.gNum + rootVC.afternum;
    rootVC.meCountLabel.hidden = !(meSumT>0);
    rootVC.meCountLabel.text = @(meSumT).stringValue;
    if (meSumT > 0 && meSumT != rootVC.meSum) {
        AudioServicesPlaySystemSound(1007);
        rootVC.meSum = meSumT;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"PROFILEREFRESH" object:nil];
    }
}

@end
