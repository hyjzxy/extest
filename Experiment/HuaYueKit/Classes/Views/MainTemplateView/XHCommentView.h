//
//  XHCommentView.h
//  HuaYue
//
//  Created by Appolls on 14-12-14.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHCommentView : UIView

@property (nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *altBtn;

- (void)setAltView:(NSArray *)list;

- (IBAction)answerBtn:(id)sender;
- (IBAction)clickCame:(id)sender;
- (IBAction)clickAlt:(id)sender;

@end
