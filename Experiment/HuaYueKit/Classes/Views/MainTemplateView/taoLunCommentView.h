//
//  taoLunCommentView.h
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaoLunCommentDelegate <NSObject>

- (void)replayCommentAxtion:(id)sender;

@end

@interface taoLunCommentView : UIView

@property (nonatomic,assign)id<TaoLunCommentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
- (IBAction)answerBtn:(id)sender;

@end
