//
//  MZBaseVC.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/24.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZBaseAnswerVC.h"
#import "Masonry.h"
#import "XHProtocolViewController.h"
#import "XHProfileTableViewController.h"
#import "UIProgressView+AFNetworking.h"
#import "XHWenGaoShouViewController.h"
#import "BMUtils.h"
#import "MZAnswerChatVC.h"
#import "IQKeyboardManager.h"
#import "UMSocial.h"
#import "NSObject+Cate.h"
#import "XHMyUIView.h"
#import "MZCamera.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "UIAlertView+Block.h"
#import "UIView+Cate.h"
#import "MZShare.h"
#import "SVProgressHUD.h"


@interface MZBaseAnswerVC ()<UMSocialUIDelegate,SupportDelegate>
@property (strong, nonatomic) NSArray *invates;
@property (strong, nonatomic) UIView *loginView;
@property (strong, nonatomic) UIView *contiAnswerView;
@property (strong, nonatomic) UIView *contiAddQuestView;
@property (strong, nonatomic) UIView *answerView;
@property (strong, nonatomic) UIView *answerInvateView;
@property (strong, nonatomic) UIButton *andAnswerBtn;
@property (strong, nonatomic) UIButton *answerBtn;
@property (strong, nonatomic) UIButton *invateBtn;
@end

@implementation MZBaseAnswerVC
{
    ChatTType sendType;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    [self mSetup];
    
}

- (void)mSetup
{
    //1 登录 2 继续回答 3 继续追问 4 回答 5 追问
    self.loginView = ViewFromXib(@"CustomViews", 1);
    self.contiAnswerView = ViewFromXib(@"CustomViews", 2);
    self.contiAddQuestView = ViewFromXib(@"CustomViews", 3);
    self.answerView = ViewFromXib(@"CustomViews", 4);
    self.answerInvateView = ViewFromXib(@"CustomViews", 5);
    
    __weak MZBaseAnswerVC *weakM = self;
    [self.view addSubview:_answerView];
    [(UIButton*)VIEWWITHTAG(_answerView, 1001) addTarget:self action:@selector(mCanmaAct:) forControlEvents:UIControlEventTouchUpInside];
    [_answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakM.view);
    }];
    _answerView.hidden = YES;
    
    [self.view addSubview:_loginView];
    [(UIButton*)VIEWWITHTAG(_loginView, 1001) addTarget:self action:@selector(mToLoginAct:) forControlEvents:UIControlEventTouchUpInside];
    _loginView.hidden = YES;
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakM.view);
    }];
    
    [self.view addSubview:_contiAnswerView];
    [(UIButton*)VIEWWITHTAG(_contiAnswerView, 1001) addTarget:self action:@selector(mToAnswerAct:) forControlEvents:UIControlEventTouchUpInside];
    [_contiAnswerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakM.view);
    }];
    _contiAnswerView.hidden = YES;
    
    [self.view addSubview:_contiAddQuestView];
    UIButton *contiAddQuestBtn = (UIButton*)VIEWWITHTAG(_contiAddQuestView, 1001);
    [contiAddQuestBtn addTarget:self action:@selector(mToAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    [_contiAddQuestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakM.view);
    }];
     _contiAddQuestView.hidden = YES;
    
    
    
    [self.view addSubview:_answerInvateView];
    self.invateBtn = (UIButton*)VIEWWITHTAG(_answerInvateView, 1002);
    [ (UIButton*)VIEWWITHTAG(_answerInvateView, 1001) addTarget:self action:@selector(mCanmaAct:) forControlEvents:UIControlEventTouchUpInside];
    [_invateBtn  addTarget:self action:@selector(mInvatAct:) forControlEvents:UIControlEventTouchUpInside];
    [_answerInvateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakM.view);
    }];
    _answerInvateView.hidden = YES;
    
    self.answerBtn = (UIButton*)VIEWWITHTAG(_answerView, 1003);
    self.andAnswerBtn =  (UIButton*)VIEWWITHTAG(_answerInvateView, 1004);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardDidAppear:(NSNotification *)notification
{
   self.keyRect  = [self.contentTF.superview convertRect: [[notification userInfo][UIKeyboardFrameEndUserInfoKey]CGRectValue] fromView:nil];
    [self mUpdateG];
}

-(void)keyboardDidDisappear:(NSNotification *)notification
{
    self.keyRect = CGRectZero;
    [self mUpdateG];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)dealloc
{
    self.returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)mShowBottomView
{
    [_answerBtn removeTarget:self action:@selector(mSendAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    [_answerBtn removeTarget:self action:@selector(mSendAnswerAct:) forControlEvents:UIControlEventTouchUpInside];
    [_andAnswerBtn removeTarget:self action:@selector(mSendAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    [_andAnswerBtn removeTarget:self action:@selector(mSendAnswerAct:) forControlEvents:UIControlEventTouchUpInside];
     __weak MZBaseAnswerVC *weakM = self;
    [self.mBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakM.view);
        make.top.equalTo(weakM.view.mas_bottom);
    }];
    self.mBottomView.hidden = YES;
    self.mBottomView = nil;
    //1 登录 2 继续回答 3 继续追问 4 回答 5 追问
    // 检查是否登录
    __block NSInteger userId = 0;
    [HYHelper mLoginID:^(id uid) {
        if(uid) {
            userId = [uid integerValue];
            [SVProgressHUD showWithStatus:nil];
            [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}]
                                               withUrl:MY_REALINFO_API
                                              withType:MY_REALINFO
                                               success:^(id infoDic) {
                                                   BOOL status = [infoDic[@"realname_status"]boolValue];
                                                   NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                                   [ud setBool:status forKey:AUTH];
                                                   [ud synchronize];
                                                   if (status) {
                                                       [_invateBtn setBackgroundImage:[UIImage imageNamed:@"at"] forState:UIControlStateNormal];
                                                   }else{
                                                       [_invateBtn setBackgroundImage:[UIImage imageNamed:@"atSomebody@3x.png"] forState:UIControlStateNormal];
                                                   }
                                                   [SVProgressHUD dismiss];
                                               }failure:^(id error){
                                                   [SVProgressHUD dismiss];
                                               }];
        }
    }];
    NSInteger qUId = [self.mQuest[@"uid"]integerValue];
    self.contentTF = nil;
    if(!(userId!=0)){
        self.mBottomView = self.loginView;
    }else if(_isAddQuest){
        if (_isContiAddQuest) {
            self.mBottomView =self.contiAddQuestView;
        }else{
             sendType = kAddQuestChat;
            if(_chatType == kAddQuestChat){
                self.mBottomView = self.answerView;
                self.contentTF = (MZChatTextView*)VIEWWITHTAG(_answerView, 1002);
                [_answerBtn setTitle:@"回复" forState:UIControlStateNormal];
                [_answerBtn addTarget:self action:@selector(mSendAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                self.mBottomView = self.answerInvateView;
                self.contentTF = (MZChatTextView*)VIEWWITHTAG(_answerInvateView, 1003);
                [_andAnswerBtn setTitle:@"回复" forState:UIControlStateNormal];
                [_andAnswerBtn addTarget:self action:@selector(mSendAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
            }
//            [self mLeftGaoShou];
        }
    } else if(_chatType==kNoneChat && (qUId!=userId || self.chatFrom==kChatFromMyAnswer)){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"auid.intValue=%d",userId];
        NSArray *t = [_mDatas filteredArrayUsingPredicate:predicate];
        if(t.count>0){
            self.mBottomView = self.contiAnswerView;
        }else{
            sendType = kAnswerChat;
            self.mBottomView = self.answerInvateView;
            self.contentTF = (MZChatTextView*)VIEWWITHTAG(_answerInvateView, 1003);
            [_andAnswerBtn setTitle:@"回答" forState:UIControlStateNormal];
            [_andAnswerBtn addTarget:self action:@selector(mSendAnswerAct:) forControlEvents:UIControlEventTouchUpInside];
//            [self mLeftGaoShou];
        }
    }else if(_chatType==kAnswerChat ){
        if(qUId==userId || self.auid== userId){
             sendType = kAnswerChat;
             self.mBottomView = self.answerView;
            self.contentTF = (MZChatTextView*)VIEWWITHTAG(_answerView, 1002);
            [_answerBtn setTitle:@"回答" forState:UIControlStateNormal];
            [_answerBtn addTarget:self action:@selector(mSendAnswerAct:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    self.mBottomView.hidden = NO;
    [self.mBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakM.view);
        make.bottom.equalTo(weakM.view.mas_bottom);
    }];
    [self mUpdateG];
}

- (void)mLeftGaoShou
{
    if (_invates.count>0) {
        NSMutableString *ms = [NSMutableString  string];
        [_invates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx==0) {
                [ms appendFormat:@"@%@%@",obj[@"nickname"],_invates.count==1?(_isAddQuest?@"回复:":@":"):@""];
            }else{
                [ms appendFormat:@";@%@%@",obj[@"nickname"],idx==_invates.count-1?(_isAddQuest?@"回复:":@":"):@""];
            }
        }];
        [self.contentTF mAddLable:ms];
    }else{
        [self.contentTF mAddLable:@""];
    }
}
#pragma mark - 事件处理
/**
 *  @author 崔俊红, 15-04-24 17:04:36
 *  @brief  追问
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mAddQuestAct:(UIButton*)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if(!(userId.length>0)){
        [BMUtils showError:@"您还没有登录"];
        return;
    }
    self.isAddQuest = !_isAddQuest;
    self.isContiAddQuest = YES;
    if(self.isAddQuest){
        if (!self.isContiAddQuest) {
            self.auid = 0;
            self.aid = 0;
        }else{
            self.auid = [sender.info[@"auid"]integerValue];
            self.aid = [sender.info[@"id"]integerValue];
            self.nickName = sender.info[@"nickname"];
        }
    }else{
        self.auid = 0;
        self.aid = 0;
    }
    if(!_isAddQuest){
         [self.contentTF mAddLable:@""];
    }
    [self mShowBottomView];
}

/**
 *  @author 崔俊红, 15-05-01 11:05:35
 *
 *  @brief  登录
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mToLoginAct:(id)sender
{
    XHProfileTableViewController *loginVC = [[XHProfileTableViewController alloc] init];
    loginVC.isDimiss = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

/**
 *  @author 崔俊红, 15-04-25 21:04:19
 *
 *  @brief  继续回答页面跳转
 *  @param sender uibutton
 *  @since v2.0
 */
- (void)mToAnswerAct:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if(!(userId.length>0)){
        [BMUtils showError:@"您还没有登录"];
        return;
    }
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.isAddQuest = NO;
    chatVC.chatType = kAnswerChat;
    chatVC.mQuest = self.mQuest;
    chatVC.qid = self.qid;
    chatVC.auid = userId.integerValue;
    chatVC.nickName = @"我";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"auid.intValue=%d",[userId intValue]];
    NSArray *t = [_mDatas filteredArrayUsingPredicate:predicate];
    if(t.count>0){
        chatVC.aid = [t[0][@"id"]intValue];
    }
    [self.navigationController pushViewController:chatVC animated:YES];
}

/**
 *  @author 崔俊红, 15-04-25 21:04:48
 *
 *  @brief  继续追问页面跳转
 *  @param sender uibutton
 *  @since v2.0
 */
- (void)mToAddQuestAct:(id)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if(!(userId.length>0)){
        [BMUtils showError:@"您还没有登录"];
        return;
    }
    //TODO:
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.isAddQuest = YES;
    chatVC.chatType = kAddQuestChat;
    chatVC.mQuest = self.mQuest;
    chatVC.qid = self.qid;
    chatVC.nickName = self.nickName;
    chatVC.auid = self.auid;
    chatVC.aid =  self.aid;
    [self.navigationController pushViewController:chatVC animated:YES];
}

/**
 *  @author 崔俊红, 15-04-26 15:04:49
 *
 *  @brief  邀请高手
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mInvatAct:(id)sender
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:AUTH]){
        XHWenGaoShouViewController *gsVC = [[XHWenGaoShouViewController alloc]init];
        gsVC.mydelegate = self;
        gsVC.selectedDics = self.invates;
        [self.navigationController pushViewController:gsVC animated:YES];
    } else{
        [BMUtils showError:@"非认证用户不能邀请高手"];
    }
}

/**
 *  @author 崔俊红, 15-04-26 18:04:59
 *
 *  @brief 发送回答
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mSendAnswerAct:(id)sender
{
    [self.contentTF resignFirstResponder];
    NSString *content = [self.contentTF.mText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (content.length==0) {
        [BMUtils showError:@"回答内容不能为空"];
        return;
    }
    
    NSMutableArray *invateids = [NSMutableArray array];
    for (NSDictionary *dic in _invates) {
        [invateids addObject:dic[@"id"]];
    }
    //uid,id,type,content,image
    sendType = kAnswerChat;
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[userId,@(self.qid),@0,content,@"",@(invateids.count>0?1:2),[invateids componentsJoinedByString:@","]] forKeys:[ANSWER_ADD_PARAM componentsSeparatedByString:@","]];
    [self mSend:params isRes:YES];
}

/**
 *  @author 崔俊红, 15-04-26 18:04:32
 *
 *  @brief  追问
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mSendAddQuestAct:(id)sender
{
    [self.contentTF resignFirstResponder];
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:UID]integerValue];
    if (self.askUId<=0) {
        [BMUtils showError:@"请选择回复人"];
        return;
    }
    if (self.askUId == userId) {
        [BMUtils showError:@"不对追问自己"];
        return;
    }
    NSString *content = [self.contentTF.mText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (content.length==0) {
        [BMUtils showError:@"追问内容不能为空"];
        return;
    }
    sendType = kAddQuestChat;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[@(userId),@(self.qid),@(self.aid),content,@"",@(self.askUId),@(self.ID)] forKeys:[ANSWER_ADDQUES_PARAM componentsSeparatedByString:@","]];
    [self mSend:params isRes:YES];
}

- (void) clickMoreBtn{
    UIView *view = ViewFromXib(@"jubao", 0);
    view.tag = 10001;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    //[self.view addSubview:view];
    UIButton *shareBtn = (UIButton *)[view viewWithTag:250];
    [shareBtn addTarget:self action:@selector(shareAct:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *jubaoBtn = (UIButton *)[view viewWithTag:251];
    if([self isKindOfClass:[MZAnswerChatVC class]]){
        [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
        [jubaoBtn addTarget:self action:@selector(reportQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    }else if([self isKindOfClass:[MZAnswerListVC class]]){
//        shareQBtn.hidden = NO;
        id uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        if ([self.mQuest[@"uid"] integerValue]==[uid integerValue]) {
            [jubaoBtn setTitle:@"删除" forState:UIControlStateNormal];
            [jubaoBtn addTarget:self action:@selector(deleteAct:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [jubaoBtn setTitle:@"举报" forState:UIControlStateNormal];
            [jubaoBtn addTarget:self action:@selector(reportQuestAct:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    UIButton *canCleBtn = (UIButton *)[view viewWithTag:252];
    [canCleBtn addTarget:self action:@selector(cancleAct:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-10 13:05:42
 *
 *  @brief  分享
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)shareAct:(UIButton*)sender
{
    [sender.superview.superview removeFromSuperview];
    // 分享一个问题
    NSString* title = [NSString stringWithFormat:@"问题分享\n%@",_mQuest[@"content"]];
    [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithObjects:@[@(self.qid)] forKeys:@[@"qid"]]
                                       withUrl:QUESTION_SHARE_API
                                      withType:QUESTION_SHARE
                                       success:^(id responseObject){
                                           [[MZShare shared]shareInVC:self title:title image:[UIImage imageNamed:@"share-logo"] url:responseObject[@"url"] block:nil];
                                       }failure:^(id error){}];

}

/**
 *  @author 麦子收割队-崔俊红, 15-05-10 13:05:51
 *
 *  @brief  取消
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)cancleAct:(UIButton*)sender
{
    [sender.superview removeFromSuperview];
    //[VIEWWITHTAG(self.view, 10001)removeFromSuperview];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-10 13:05:12
 *
 *  @brief  举报
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)reportQuestAct:(UIButton*)sender
{
    [sender.superview.superview removeFromSuperview];
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"您确定举报该提问吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        NSArray *keyValue = [QUESTIONS_JUBAO_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,@(_qid)] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:QUESTIONS_JUBAO_API
                                          withType:QUESTIONS_JUBAO
                                           success:^(id responseObject)
         {
             [BMUtils showSuccess:@"举报成功"];
         }failure:^(id error){
             [BMUtils showSuccess:error];
         }];
        [VIEWWITHTAG(self.view, 10001) removeFromSuperview];
    }]show];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-10 13:05:12
 *
 *  @brief  举报
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)reportAnswerAct:(id)sender
{
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"您确定举报该回答吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSArray *keyValue = [ANSWER_JUBAO_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(_auid),@(_aid)] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:ANSWER_JUBAO_API
                                          withType:ANSWER_JUBAO_PARAM
                                           success:^(id responseObject)
         {
             [BMUtils showSuccess:@"举报成功"];
         }failure:^(id error){
             [BMUtils showError:error];
         }];
        [VIEWWITHTAG(self.view, 10001) removeFromSuperview];
    }]show];
}

/**
 *  @author 崔俊红, 15-05-02 15:05:09
 *
 *  @brief  支持
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)supportAct:(UIButton*)sender
{
    XHMyUIView *xhView = (XHMyUIView*)ViewFromXib(@"TiWenView", 4);
    [self.view addSubview:xhView];
    __weak MZBaseAnswerVC *sw = self;
    [xhView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(sw.view);
        make.top.equalTo(sw.view).with.offset(-64.0f);
    }];
    xhView.info = sender.info;
    xhView.delegate = self;
    [xhView performSelector:@selector(mLoadData)];
}

#pragma mark - SurportDelegate
- (void)mSupportSuccWithUserInfo:(NSDictionary *)info
{
  
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-10 13:05:54
 *
 *  @brief  删除问题
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)deleteAct:(id)sender
{
    UIView* view = (UIView*)sender;
    [view.superview.superview removeFromSuperview];
//    [VIEWWITHTAG(self.view, 10001) removeFromSuperview];
    if ([self.mQuest[@"issolveed"] boolValue]){
        [BMUtils showError:@"被采纳回答无法删除"];
        return;
    }
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"删除后将无法恢复,是否确定要删除?" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:UID],@"qid":@(self.qid)}]
                                           withUrl:QUESTIONS_DELETE_API
                                          withType:QUESTIONS_DELETE
                                           success:^(id responseObject){
                                               [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                           }];
    }]show];
}
/**
 *  @author 崔俊红, 15-04-26 18:04:42
 *
 *  @brief  由子类实现
 *  @since v1.0
 */
-(void)mSendSucc:(id)tuid{}

/**
 *  @author 崔俊红, 15-04-26 15:04:04
 *
 *  @brief  提取多媒体
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)mCanmaAct:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) return;
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:UID]integerValue];
    if (sendType == kAddQuestChat) {
        if (self.askUId<=0) {
            [BMUtils showError:@"请选择回复人"];
            return;
        }
        if (self.askUId == userId) {
            [BMUtils showError:@"不对追问自己"];
            return;
        }
    }
    WS(ws);
    [[MZCamera shared]mOpenPickerInVC:self source:buttonIndex==0?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary block:^(NSData *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ws.answerView.hidden = !self.isChat;
        });
        if(_contentTF){_contentTF.text = @"";}
        if (ws.isChat) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//                NSString *userHead = [[NSUserDefaults standardUserDefaults]objectForKey:USERHEAD];
//                NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
//                NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
//                NSDictionary *dic = @{@"auid":userId,
//                                      @"inputtime":@"刚刚",
//                                      @"nickname":userName,
//                                      @"content":@"",
//                                      @"image":@"Local",
//                                      @"Local":[UIImage imageWithData:data],
//                                      @"head":userHead,
//                                      @"askname":ws.askNickName?ws.askNickName:@""};
//                [ws.mDatas addObject:dic];
//                [ws mSendSucc:dic[@"auid"]];
            }];
        }
        NSURL *uploadURL = [NSURL URLWithString:UploadPathAPI];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uploadURL];
        request.HTTPMethod  = @"POST";
        [request setValue:[@(kUploadAnswer)stringValue] forHTTPHeaderField:@"type"];
        [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        UIProgressView *pv = [[UIProgressView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 5)];
        [self.view addSubview:pv];
        NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id d = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (d != nil && [d[@"code"] integerValue] == 88) {
                    NSString *imageURL = [d objectForKey:@"url"];
                    NSMutableDictionary *params = nil;
                    if (sendType == kAnswerChat) {
                        params = [NSMutableDictionary dictionaryWithObjects:@[@(userId),@(ws.qid),@0,@"",imageURL,@2,@""] forKeys:[ANSWER_ADD_PARAM componentsSeparatedByString:@","]];
                    }else if(sendType == kAddQuestChat){
                        params = [NSMutableDictionary dictionaryWithObjects:@[@(userId),@(ws.qid),@(ws.aid),@"",imageURL,@(self.askUId),@(ws.aid)] forKeys:[ANSWER_ADDQUES_PARAM componentsSeparatedByString:@","]];
                    }
                    [self mSend:params isRes:!ws.isChat];
                }
                [pv removeFromSuperview];
            });
        }];
        [pv setProgressWithUploadProgressOfTask:uploadTask animated:YES];
        [uploadTask resume];
    }];
}

#pragma mark - Delegate
- (void)didSelectedWithGaoShou:(NSMutableArray *)dArray
{
    self.invates = dArray;
    [self mLeftGaoShou];
}

/**
 *  @author 麦子收割队-崔俊红, 15-05-07 12:05:01
 *
 *  @brief  发送消息
 *  @param params UIButton
 *  @since v1.0
 */
- (void)mSend:(NSMutableDictionary*)params isRes:(BOOL)isRes
{
    MZLoadingVIew* loadingView = [MZLoadingVIew new];
    loadingView.loadingText = @"正在发送中...";
    [loadingView show];
//    [SVProgressHUD show];
    NSString *userHead = [[NSUserDefaults standardUserDefaults]objectForKey:USERHEAD];
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"auid":userId,
                                                                               @"inputtime":@"刚刚",
                                                                               @"nickname":userName,
                                                                               @"content":params[@"content"],
                                                                               @"image":params[@"image"],
                                                                                @"head":userHead,
//                                                                                @"sign":self.askNickName?@"1":@"0",
                                                                                
                                                                @"askname":self.askNickName?self.askNickName:@""}] ;
    if (sendType == kAddQuestChat){
        [dic setObject:@"0" forKey:@"sign"];
    }else if (sendType == kAnswerChat){
        [dic setObject:@"1" forKey:@"sign"];
    }
    
     [_contentTF clearText];
    self.askUId = 0;
    if (sendType == kAnswerChat) {
        params[@"aid"] = @(self.aid);
        [[NetManager sharedManager] myRequestParam:params
                                           withUrl:ANSWER_ADD_API
                                          withType:ANSWER_ADD
                                           success:^(id responseObject){
//                                               [SVProgressHUD dismiss];
                                               if (responseObject[@"id"] != nil){
                                                  [dic setObject:responseObject[@"id"] forKey:@"id"];
                                               }
                                               self.aid = [responseObject[@"parentid"] integerValue];
                                               [loadingView dissMiss];
                                               //添加记录
                                               [_contentTF clearText];
                                               [self.mDatas addObject:dic];
                                               [self mSendSucc:dic[@"auid"]];

                                           }failure:^(id error){
                                           [SVProgressHUD dismiss];
                                           }];
    }else if(sendType == kAddQuestChat) {
        [[NetManager sharedManager] myRequestParam:params
                                           withUrl:ANSWER_ADDQUES_API
                                          withType:ANSWER_ADDQUES
                                           success:^(id responseObject){
//                                               [SVProgressHUD dismiss];
                                               if (responseObject[@"id"] != nil){
                                                   [dic setObject:responseObject[@"id"] forKey:@"id"];
                                               }
                                               
                                               [loadingView dissMiss];
                                               //添加记录
                                               [_contentTF clearText];
                                               [self.mDatas addObject:dic];
                                               [self mSendSucc:dic[@"auid"]];
                                           }failure:^(id error){
                                           [SVProgressHUD dismiss];
                                           }];
    }
}

/**
 *  @author 崔俊红, 15-05-03 14:05:59
 *
 *  @brief  追问人
 *  @param sender UITap
 *  @since v1.9
 */
- (void)addQuestPersonAct:(UITapGestureRecognizer*)sender
{
    if ([sender.info[@"auid"]integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:UID]integerValue]){
        [BMUtils showError:@"不能追问自己"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    self.askUId = [sender.info[@"auid"]integerValue];
    self.askNickName = sender.info[@"nickname"];
    if (self.isAddQuest) {
        self.ID = [sender.info[@"id"]integerValue];
        [self.contentTF mAddLable:[NSString stringWithFormat:@"回复%@:",self.askNickName]];
    }
}

@end
