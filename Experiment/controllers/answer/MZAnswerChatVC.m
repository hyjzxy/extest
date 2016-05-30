//
//  MZAnswerChatVC.m
//  HuaYue
//
//  Created by 崔俊红 on 15/4/26.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZAnswerChatVC.h"
#import "Masonry.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "BMUtils.h"
#import "NSObject+Cate.h"
#import "MZImageView.h"
#import "IQKeyboardManager.h"
#import "UIView+Cate.h"
#import "HYHelper.h"
#import "MZShareItemTableViewCell.h"

@interface MZAnswerChatVC ()
@property (weak, nonatomic) IBOutlet UITableView *chatTbv;
@property (strong, nonatomic) NSString *uID;
@end

@implementation MZAnswerChatVC
{
    __block NSInteger lastNums;
    BOOL last ;
}

- (void)mGradientBg
{
    //#EAEBEC #F4F5F7
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = Rect(0, 0, VWidth(self.view), VHeight(self.view));
    if (self.isAddQuest) {
        //gradientLayer.colors = @[(id)(UIColorFromRGB(0xEAEBEC).CGColor),(id)(UIColorFromRGB(0xEAEBEC).CGColor)];
        gradientLayer.colors = @[(id)(UIColorFromRGB(0xACE2DC).CGColor),(id)(UIColorFromRGB(0xDEC799).CGColor)];
    }else{
        gradientLayer.colors = @[(id)(UIColorFromRGB(0xACE2DC).CGColor),(id)(UIColorFromRGB(0xDEC799).CGColor)];
    }
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.isAddQuest) {
        UIView *tsView = [[UIView alloc]init];
        [tsView mTSWithType:kTSAddQuest];
        [self.view addSubview:tsView];
        WS(ws);
        [tsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(ws.view);
            make.height.mas_equalTo(@30);
        }];
        [self.chatTbv setContentInset:UIEdgeInsetsMake(30, 0, 60, 0)];
        tsView.info = @{@"CALL":^(id i){
            [ws.chatTbv setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
        }};
    }else{
        [_chatTbv setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
    }
    self.isChat = YES;
    self.view.backgroundColor = UIColorFromRGB(0xF0F2F5 );
    [self mGradientBg];
    lastNums = -1;
    self.uID = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSString *title = [NSString stringWithFormat:@"%@的%@",self.chatType==kAnswerChat?([self.uID integerValue]==self.auid?@"我":self.nickName):self.nickName,self.chatType==kAddQuestChat?@"回答的追问讨论":@"回答"];
    self.title = title;
    
    [_chatTbv addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(mDownLoad)];
    [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"id":@(self.qid)}]
                                       withUrl:GetQuestionByID_API
                                      withType:GetQuestionByID
                                       success:^(id responseObject){
                                           self.mQuest = responseObject;
                                           NSInteger cnum = [self.mQuest[@"issolveed"]integerValue];
                                           NSMutableArray *itemBars = [NSMutableArray array];
                                           if([self.uID integerValue]!=self.auid){
                                                [itemBars addObject:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"report-bar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(reportAnswerAct:)]];
                                           }
                                           if (cnum==0 && [self.uID integerValue]==[self.mQuest[@"uid"]integerValue]) {
                                               [itemBars addObject:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"accept-bar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(mAdoptAct:)]];
                                           }
                                           self.navigationItem.rightBarButtonItems = itemBars;
                                           self.mDatas = [NSMutableArray arrayWithObjects:@{
                                                                @"auid":self.mQuest[@"uid"],
                                                                @"nickname":self.mQuest[@"nickname"],
                                                                @"askname":self.mQuest[@"nickname"],
                                                                @"askid":self.mQuest[@"uid"],
                                                                @"content":self.mQuest[@"content"],
                                                                @"head":self.mQuest[@"head"],
                                                                @"inputtime":self.mQuest[@"inputtime"]                                                                                            }, nil];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
    [_chatTbv.legendHeader beginRefreshing];
    
    
}

- (void)mUpdateG
{
    __weak MZBaseAnswerVC *ws = self;
    [self.chatTbv setTranslatesAutoresizingMaskIntoConstraints:YES];
    if (self.contentTF) {
        if (!CGRectIsEmpty(self.keyRect)) {
            [self.contentTF.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.view.mas_bottom).with.offset(-ws.keyRect.size.height);
            }];
            CGRectSetWidth(self.chatTbv, VWidth(self.view));
            CGRectSetHeight(self.chatTbv, VHeight(self.view)-ws.keyRect.size.height);
        }else{
            [self.contentTF.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.view.mas_bottom);
            }];
            CGRectSetWidth(self.chatTbv, VWidth(self.view));
            CGRectSetHeight(self.chatTbv, VHeight(self.view));
        }
    }else{
        CGRectSetWidth(self.chatTbv, VWidth(self.view));
        CGRectSetHeight(self.chatTbv, VHeight(self.view));
    }
    if (self.mDatas.count<1) {
        return;
    }
    [self.chatTbv  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mDatas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - 数据处理
/**
 *  @author 崔俊红, 15-04-24 17:04:26
 *  @brief  上拉刷新数据
 *  @since v1.0
 */
- (void)mUpLoad
{
    [self.view endEditing:YES];
    [self mLoadRmoteData];
}

/**
 *  @author 崔俊红, 15-04-24 17:04:37
 *  @brief  下拉刷新数据
 *  @since v1.0
 */
- (void)mDownLoad
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAnswerList" object:nil];
    [self.view endEditing:YES];
    self.pid = @0;
    [self mLoadRmoteData];
}

- (void)mLoadRmoteData
{
    __weak MZAnswerChatVC *weakM = self;
    NSString *urlStr = nil;
    NSMutableDictionary *params = nil;
    NSString *urtType = nil;
    if (self.chatType == kAnswerChat) {
        //auid,qid 回答者ID和问题ID
        urlStr = MY_ANSWER_LIST_API;
        urtType = MY_ANSWER_LIST;
        params = [NSMutableDictionary dictionaryWithObjects:@[@(self.auid),self.pid,@0, @(self.qid),@(self.aid)] forKeys:[MY_ANSWER_LIST_PARAM componentsSeparatedByString:@","]];
    }else if(self.chatType == kAddQuestChat) {
        //aid 回答ID
        urlStr = ADD_QUES_LIST_API;
        urtType = ADD_QUES_LIST;
        params = [NSMutableDictionary dictionaryWithObjects:@[@(self.aid),self.pid,@0] forKeys:[ADD_QUES_LIST_PARAM componentsSeparatedByString:@","]];
    }
    //太给力了，你的回答完美解决了我的问题！
    [[NetManager sharedManager] myRequestParam:params
                                       withUrl:urlStr
                                      withType:urtType
                                       success:^(id responseObject){
                                           if ([self.pid isEqualToNumber:@0]) {
                                                 [self.mDatas removeObjectsInRange:NSMakeRange(1, self.mDatas.count-1)];
                                           }
                                           //self.pid = ((NSObject*)responseObject).info[@"maxid"];
                                           [weakM.mDatas addObjectsFromArray:responseObject];
                                           [weakM.chatTbv.legendHeader endRefreshing];
                                           [weakM.chatTbv reloadData];
                                           [weakM mShowBottomView];
                                       }failure:^(id error){
                                           [weakM.chatTbv.legendHeader endRefreshing];
                                           [weakM.chatTbv reloadData];
                                           [weakM mShowBottomView];
                                       }];
}
#pragma mark - 事件处理
/**
 *  @author 崔俊红, 15-04-28 22:04:49
 *
 *  @brief  采纳
 *  @param sender UIBarButtonItem
 *  @since v1.0
 */
- (void)mAdoptAct:(id)sender
{
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"您是否采纳该回答吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[uid,@(self.aid)] forKeys:@[@"uid",@"aid"]];
        [[NetManager sharedManager] myRequestParam:params withUrl:ANSWER_ADOPT_API withType:ANSWER_ADOPT success:^(id responseObject) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAnswerList" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
            self.navigationItem.rightBarButtonItem = nil;
            [BMUtils showSuccess:@"回答已采纳"];
        } failure:^(id errorString) {
            [BMUtils showSuccess:errorString];
        }];
    }]show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSDictionary *data = self.mDatas[indexPath.row];
    BOOL isSignd = [data[@"sign"]integerValue] == 1;
    if (indexPath.row==0) {
        if ([data[@"auid"]integerValue]==[_uID integerValue]) {
            cell = ViewFromXib(@"CustomViews", 8);
            [self mConfigCell:cell data:data isMaster:YES isQuest:YES isAnswer:NO isSignd:YES];
            ((MZShareItemTableViewCell*)cell).indexPath = indexPath;
        }else{
            cell = ViewFromXib(@"CustomViews", 7);
            [self mConfigCell:cell data:data isMaster:NO isQuest:YES isAnswer:NO isSignd:YES];
            ((MZShareItemTableViewCell*)cell).indexPath = indexPath;
        }
    }else{
        
        if ([data[@"auid"]integerValue] == [_uID integerValue]) {
            cell = ViewFromXib(@"CustomViews", 8);
            [self mConfigCell:cell data:data isMaster:YES isQuest:NO isAnswer:indexPath.row==1 isSignd:isSignd];
            ((MZShareItemTableViewCell*)cell).indexPath = indexPath;
        }else{
            cell = ViewFromXib(@"CustomViews", 7);
            [self mConfigCell:cell data:data isMaster:NO isQuest:NO isAnswer:indexPath.row==1 isSignd:isSignd];
            ((MZShareItemTableViewCell*)cell).indexPath = indexPath;
        }

    }
    return cell;
}

- (void)mConfigCell:(MZShareItemTableViewCell*)cell data:(NSDictionary*)data isMaster:(BOOL)isMaster isQuest:(BOOL)isQuest isAnswer:(BOOL)isAnswer isSignd:(BOOL)isSignd
{
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.data = data;
    __weak MZAnswerChatVC *weakM = self;
    __weak MZShareItemTableViewCell *weakCell = cell;
    cell.deleteSuccess = ^{
        NSInteger row = weakCell.indexPath.row;
        [weakM.mDatas removeObjectAtIndex:row];
        [weakM.chatTbv reloadData];
        
    };
//    cell.uid =self.u
    UILabel *timeLabel = (UILabel*)VIEWWITHTAG(cell, 101);
    UILabel *nickNameLabel = (UILabel*)VIEWWITHTAG(cell, 102);
    UIImageView *headView = (UIImageView*)VIEWWITHTAG(cell, 103);
    UIView *contentV = (UIView*)VIEWWITHTAG(cell, 104);
    UIImageView *gbView = (UIImageView*)VIEWWITHTAG(cell, 105);
    timeLabel.text = data[@"inputtime"];
    nickNameLabel.text = data[@"nickname"];
    [headView setImageWithURL:IMG_URL(data[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = VWidth(headView)*0.5;
    headView.info = @{@"uid":data[@"auid"]};
    if([N2V(data[@"system"], @"0") intValue]==0){
        headView.tapBlock = ^(UIImageView *iv){
            [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
        };
    }else {
        headView.tapBlock = nil;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addQuestPersonAct:)];
    tap.info = data;
    [contentV addGestureRecognizer:tap];
    contentV.userInteractionEnabled = !isQuest;
    contentV.info = data;
    NSString *content = N2V(data[@"content"], @"");
   
    if (isQuest) {
        content = [@"问：" stringByAppendingString:content];
    } else if(isAnswer){
        content = [@"回答：" stringByAppendingString:content];
    }
    
    cell.content = content;
    
    if ([data[@"image"]length]>0) {
        MZImageView *iv  = nil;
        if([data[@"image"]isEqualToString:@"Local"]){
             iv = [[MZImageView alloc]initWithImageURL:nil];
            iv.image = data[@"Local"];
        }else{
            iv = [[MZImageView alloc]initWithImageURL:IMG_URL(data[@"image"])];
            [iv setImageWithURL:IMG_URL(data[@"image"]) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = 5.0f;
        if (isAnswer||(self.isAddQuest && !isQuest)) {
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.lineBreakMode = NSLineBreakByCharWrapping;
            label.numberOfLines = 0;
            label.attributedText = [self answerJoinWithNickName:N2V(data[@"askname"],@"") content:content join:!isAnswer];
            [contentV addSubview:label];
            [contentV addSubview:iv];
            [label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(contentV.mas_left);
                make.top.equalTo(contentV.mas_top);
                make.bottom.equalTo(contentV.mas_bottom);
            }];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.left.equalTo(label.mas_right);
                make.right.equalTo(contentV);
                make.top.and.bottom.equalTo(contentV);
            }];
        }else{
            [contentV addSubview:iv];
            [iv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(50, 50));
                make.edges.equalTo(contentV);
            }];
        }
    }else{
        for (UIView* v  in contentV.subviews) {
            [v removeFromSuperview];
        }
        UILabel *label = [[UILabel alloc]init];
        label.font = SYSTEMFONT(14.0f);
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor darkGrayColor];
        if (self.chatType==kAddQuestChat && !isQuest) {
            label.attributedText = [self answerJoinWithNickName:N2V(data[@"askname"],@"") content:content join:!isAnswer];
        }else{
            label.text =  content;
        }
        [contentV addSubview:label];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contentV);
        }];
    }

    //修改背景
    UIEdgeInsets edge = !isMaster?UIEdgeInsetsMake(10, 35, 30, 10):UIEdgeInsetsMake(10, 10, 30, 35);
    UIImage *bImge = nil;
    BOOL isAdopt = [N2V(data[@"system"], @"0")boolValue];
    if (isQuest||isAdopt) {
        bImge = [UIImage imageNamed:isMaster?@"me-quest":@"other-quest"];
    }else{
        if (self.chatType==kAddQuestChat) {
            if (isAnswer) {
                bImge = [UIImage imageNamed:isMaster?@"me-answer":@"other-answer"];
            }else{
                bImge = [UIImage imageNamed:isMaster?@"me-after":@"other-after"];
            }
        }else if(isSignd){
             bImge = [UIImage imageNamed:isMaster?@"me-quest":@"other-quest"];
        }else{
             bImge = [UIImage imageNamed:isMaster?@"me-answer":@"other-answer"];
        }
//        if (isMaster){
//            bImge = [UIImage imageNamed:@"me-answer"];
//        }
       
    }
    
    gbView.image = [bImge resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
}

- (NSAttributedString*)answerJoinWithNickName:(NSString*)nickName content:(NSString*)content join:(BOOL)join
{
    NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc]init];
    if (join) {
        [mAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"回复" attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:SYSTEMFONT(12.0f)}]];
        [mAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:nickName attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x2E2574),NSFontAttributeName:SYSTEMFONT(14.0f)}]];
        [mAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:[@"："  stringByAppendingString:content] attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:SYSTEMFONT(14.0f)}]];
    }else{
        [mAttrStr appendAttributedString:[[NSAttributedString alloc]initWithString:content attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x508CEB),NSFontAttributeName:SYSTEMFONT(14.0f)}]];
    }
    return mAttrStr;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void)mSendSucc:(NSDictionary*)dic
{
    [self.chatTbv reloadData];
    last = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAnswerList" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        if(last){
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self.chatTbv  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mDatas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
                last = NO;
            }];
        }
    }
}
@end
