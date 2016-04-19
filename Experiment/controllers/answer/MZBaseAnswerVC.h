//
//  MZBaseVC.h
//  HuaYue
//
//  Created by 崔俊红 on 15/4/24.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHWenGaoShouViewController.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "MZChatTextView.h"
@interface MZBaseAnswerVC : UIViewController<UIActionSheetDelegate,wenGaoShouDelegate>
@property (assign, nonatomic) BOOL isChat;
@property (strong, nonatomic) MZChatTextView *contentTF;
@property (strong, nonatomic) UIView *mBottomView;
@property (assign, nonatomic) BOOL isMe;
@property (assign, nonatomic) CGRect keyRect;
@property (nonatomic, assign) ChatFrom chatFrom;
@property (assign, nonatomic) NSInteger ID;
@property (assign, nonatomic) NSInteger qid;
@property (assign, nonatomic) NSInteger aid;
@property (assign, nonatomic) NSInteger auid;
@property (assign, nonatomic) NSInteger sign; // sign（1 ：问题，2：回答）
@property (strong, nonatomic) NSString *nickName;
@property (assign, nonatomic) NSInteger askUId;
@property (strong, nonatomic) NSString *askNickName;
@property (strong, nonatomic) NSNumber *pid;
@property (strong, nonatomic) NSDictionary *mQuest;
@property (assign, nonatomic) ChatTType chatType;
@property (assign, nonatomic) BOOL isAddQuest;
@property (assign, nonatomic) BOOL isContiAddQuest;
@property (strong, nonatomic) NSMutableArray *mDatas;//列表信息
@property (strong, nonatomic) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (assign, nonatomic) BOOL isLoadFinished;

- (void)mSetup;
- (void)mShowBottomView;
- (void)mAddQuestAct:(id)sender;
- (void)mToLoginAct:(id)sender;
- (void)mSendSucc:(id)tuid;
- (void)mToAddQuestAct:(id)sender;
-(void)keyboardDidAppear:(NSNotification *)notification;
-(void)keyboardDidDisappear:(NSNotification *)notification;
- (void)mUpdateG;
@end
