//
//  MZAnswerListVC.m
//  HuaYue
//  提问列表信息
//  1、问题描述
//  2、回答列表信息
//
//  Created by 崔俊红 on 15/4/24.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZAnswerListVC.h"
#import "MJRefresh.h"
#import "NetManager.h"
#import "BMUtils.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Masonry.h"
#import "MZAnswerChatVC.h"
#import "NSObject+Cate.h"
#import "UIView+Cate.h"
#import "HYHelper.h"
#import "SVProgressHUD.h"

@interface MZAnswerListVC ()

@property (weak, nonatomic) IBOutlet UILabel *questDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *invateLabel;
@property (weak, nonatomic) IBOutlet UILabel *labeLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerPersonsBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerTimeBtn;
@property (weak, nonatomic) IBOutlet UITableView *answerTable;
@property (weak, nonatomic) IBOutlet UIButton *issolveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dataTip;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@end

@implementation MZAnswerListVC
{
    BOOL issolveed;
    BOOL notiPost;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _answerTable.estimatedRowHeight = 200.0f;
    _answerTable.rowHeight = UITableViewAutomaticDimension;
    self.isChat = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"barbuttonicon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickMoreBtn)];
    self.chatType = kNoneChat;
    [_answerTable setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
    self.mDatas = [NSMutableArray array];
    [_answerTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(mDownLoad)];
    [_answerTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(mUpLoad)];
    _answerTable.legendFooter.stateHidden = YES;
    [self mLoad];
    [self mShowBottomView];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiPost) name:@"ReloadAnswerList" object:nil];
}

- (void)notiPost
{
    notiPost = YES;
    [self mLoad];
}

- (void)mLoad
{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    id uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    self.pid = @0;
    [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"id":@(self.qid)}]
                                       withUrl:GetQuestionByID_API
                                      withType:GetQuestionByID
                                       success:^(id responseObject){
                                           [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                               self.mQuest = responseObject;
                                               issolveed = [self.mQuest[@"issolveed"]integerValue]==1;
                                               self.navigationItem.title = [NSString stringWithFormat:@"%@的提问",[self.mQuest[@"uid"]compare:uid]==NSOrderedSame?@"我":self.mQuest[@"nickname"]];
                                               self.isMe = [self.mQuest[@"uid"]compare:uid]==NSOrderedSame;
                                               [self mSetUI];
                                               if (notiPost) {
                                                   notiPost = NO;
                                                   [self mDownLoad];
                                               }else{
                                                   [_answerTable.legendHeader beginRefreshing];
                                               }
                                               [SVProgressHUD dismiss];
                                           }];
                                       }failure:^(id error){
                                           [SVProgressHUD dismiss];
                                           [BMUtils showError:error];
                                       }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)mUpdateG
{
    __weak MZAnswerListVC *ws = self;
    if (self.contentTF) {
        if (!CGRectIsEmpty(self.keyRect)) {
            [self.contentTF.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.view.mas_bottom).with.offset(-ws.keyRect.size.height);
            }];
        }else{
            [self.contentTF.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(ws.view.mas_bottom);
            }];
        }
    }else{
        [self.answerTable  mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws.view.mas_bottom).with.offset(-50);
        }];
    }
}
- (void)mSetUI
{
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]init];
    NSString* label = WYISBLANK([self.mQuest objectForKey:@"lable"]);
    _labeLabel.text = [label stringByReplacingOccurrencesOfString:@" " withString:@"/"];
    [_labeLabel makeRoundCornerWithRadius:2];
    [_labeLabel setColorWithText:_labeLabel.text];
    CGSize sizeEng = XZ_MULTILINE_TEXTSIZE(_labeLabel.text, [UIFont systemFontOfSize:11], CGSizeMake(SCREENWIDTH, 20), NSLineBreakByWordWrapping);
    [_labeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeEng.width+6));
    }];
//    _labeLabel.attributedText = [HYHelper mBuildLable:N2V(self.mQuest[@"lable"],@"") font:_labeLabel.font];
    [_answerTimeBtn setTitle:[NSString stringWithFormat:@" %@", self.mQuest[@"inputtime"]] forState:UIControlStateNormal];
    [_answerPersonsBtn setTitle:[NSString stringWithFormat:@" %@人回答", N2V(self.mQuest[@"anum"],@"0")] forState:UIControlStateNormal];
    NSString *superlist = self.mQuest[@"superlist"];
    if (superlist && superlist.length>0) {
        [HYHelper mSuperList:_invateLabel supers:superlist];
    }else{
        _invateLabel.text = @"";
    }
    self.issolveBtn.hidden = ![self.mQuest[@"issolveed"]boolValue];
    [self.readBtn setTitle:[NSString stringWithFormat:@" %@",N2V(self.mQuest[@"hits"],@"0")] forState:UIControlStateNormal];
    NSString *imgURL = [N2V(self.mQuest[@"image"], @"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (imgURL.length>0) {
        [_imgView setImageWithURL:IMG_URL(imgURL) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _imgView.tapBlock = ^(UIImageView*iv){
           [HYHelper mShowImage:IMG_URL(imgURL) m:_imgView];
        };
        [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@44);
        }];
    }else{
        [_imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@0);
        }];
    }
    UIFont *font = SYSTEMFONT(14);
    if (!isEmptyDicForKey(self.mQuest, @"reward")) {
        NSString *reward = [NSString stringWithFormat:@" %@ ",WYISBLANK(self.mQuest [@"reward"])];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"answer_M"];
        textAttach.bounds = CGRectMake(0, 0, font.pointSize, font.pointSize);
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:reward attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:UIColorFromRGB(0xE98047)}];
        [contentAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:0];
        [mAttr appendAttributedString:contentAtt];
    }
    [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:N2V(self.mQuest[@"content"], @"") attributes:@{NSFontAttributeName:font}]];
    _questDesLabel.attributedText = mAttr;
    if (self.isMe) {
        UIView *tsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VWidth(self.view), 40)];
        _answerTable.tableHeaderView = tsView;
        tsView.info = @{@"CALL":^(){
            _answerTable.tableHeaderView = nil;
        }};
        [tsView mTSWithType:kTW];
    }
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
    [self.view endEditing:YES];
    self.pid = @0;
    [self mLoadRmoteData];
}

- (void)mLoadRmoteData
{
    __weak MZAnswerListVC *weakM = self;
    NSArray *keys = [ANSWER_INFO_PARAM componentsSeparatedByString:@","];
     id uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[self.pid,@20,@(self.qid),uid?uid:@0] forKeys:keys];
    [[NetManager sharedManager] myRequestParam:params
                                       withUrl:ANSWER_INFO_API
                                      withType:ANSWER_INFO
                                       success:^(id responseObject){
                                           if (self.pid.intValue == 0) {
                                               [self.mDatas removeAllObjects];
                                           }
                                           self.pid = @(self.pid.intValue + 1);
                                           [weakM.mDatas addObjectsFromArray:responseObject];
                                           [weakM.answerTable reloadData];
                                           [weakM.answerTable.legendHeader endRefreshing];
                                           [weakM.answerTable.legendFooter endRefreshing];
                                           [weakM mShowBottomView];
                                           [self updateDataTip:self.mDatas.count>0?-1:0];
                                       }failure:^(id error){
                                           [self updateDataTip:self.mDatas.count>0?-1:0];
                                           [weakM.answerTable reloadData];
                                           [weakM.answerTable.legendHeader endRefreshing];
                                           [weakM.answerTable.legendFooter endRefreshing];
                                           [weakM mShowBottomView];
                                       }];
}

- (void)updateDataTip:(int)tip
{
    NSArray *tips  = @[@"还没有人回答~\n快点帮帮TA吧",@"对不起~\n查询出错了"];
    if (tip>=0) {
        _dataTip.hidden = NO;
        _dataTip.text = tips[tip];
    }else {
        _dataTip.hidden = YES;
    }
}
#pragma mark - 事件处理
- (void)mAddQuestAct:(id)sender
{
    if([N2V(((UIButton*)sender).info[@"anum"],@"0")intValue]<=0){
        self.nickName = ((UIButton*)sender).info[@"nickname"];
        self.aid =  [((UIButton*)sender).info[@"id"]integerValue];
        [self mToAddQuestAct:sender];
    } else{
        [super mAddQuestAct:sender];
        [self.answerTable reloadData];
    }
}

/**
 *  @author 崔俊红, 15-04-28 22:04:49
 *
 *  @brief  采纳
 *  @param sender UIBarButtonItem
 *  @since v1.0
 */
- (void)mAdoptAct:(UIButton*)sender
{
    
    [[UIAlertView mBuildWithTitle:@"提示" msg:@"您是否采纳该回答吗？" okTitle:@"确定" noTitle:@"取消" cancleBlock:nil okBlock:^{
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
        NSIndexPath *indexPath =  sender.info[@"index"];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[uid,self.mDatas[indexPath.row][@"id"]] forKeys:@[@"uid",@"aid"]];
        [[NetManager sharedManager] myRequestParam:params withUrl:ANSWER_ADOPT_API withType:ANSWER_ADOPT success:^(id responseObject) {
            [BMUtils showSuccess:@"回答已采纳"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAnswerList" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
        } failure:^(id errorString) {
            [BMUtils showError:errorString];
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
    static NSString *cellId = @"AnswerCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil){
        cell = ViewFromXib(@"CustomViews", 0);
    }
    NSDictionary *data = self.mDatas[indexPath.row];
    UIImageView *headImage = (UIImageView*)VIEWWITHTAG(cell, 1001);
    UILabel *nameLabel = (UILabel*)VIEWWITHTAG(cell, 1002);
    UILabel *levelLabel = (UILabel*)VIEWWITHTAG(cell, 1003);
    UILabel *content = (UILabel*)VIEWWITHTAG(cell, 1004);
    UILabel *cert = (UILabel*)VIEWWITHTAG(cell, 2001);
    UIButton *timeBtn = (UIButton*)VIEWWITHTAG(cell, 1005);
    UIButton *supportBtn = (UIButton*)VIEWWITHTAG(cell, 1006);
    UIButton *addQuestBtn = (UIButton*)VIEWWITHTAG(cell, 1007);
    UIButton *answerSumBtn = (UIButton*)VIEWWITHTAG(cell, 1008);
    UIButton *readsBtn = (UIButton*)VIEWWITHTAG(cell, 3000);
    UIImageView *answered = (UIImageView*)VIEWWITHTAG(cell, 1009);
    [answered setImage:[UIImage imageNamed:[data[@"answernum"]integerValue]>0?@"huida":@"unhuida"]];
    UIButton *adoptBtn = (UIButton*)VIEWWITHTAG(cell, 1010);
    UIView *addQuestV = (UIView*)VIEWWITHTAG(cell.contentView, 1011);
    UIImageView *vIV = (UIImageView*)VIEWWITHTAG(cell.contentView, 1012);
    //UILabel *supperlist = (UILabel*)VIEWWITHTAG(cell, 1015);
    headImage.info = @{@"uid":data[@"auid"]};
    headImage.tapBlock = ^(UIImageView *iv){
        [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
    };
    [supportBtn addTarget:self action:@selector(supportAct:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:data];
    [mDic setObject:^(){[self mDownLoad];}  forKey:@"callBlock"];
    [supportBtn setInfo:mDic];
    [addQuestBtn addTarget:self action:@selector(mAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    for (UIView *v in addQuestV.subviews) {
        [v removeFromSuperview];
    }
    if ([data[@"anum"]integerValue]>0 && self.auid==[data[@"auid"]integerValue]) {
        NSInteger anum = [data[@"anum"]integerValue];
        [addQuestV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(anum>3?120:(30*(anum+1))));
        }];
        [self mAddQUestScroll:addQuestV indexPath:indexPath];
    }else{
        [addQuestV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    [headImage setImageWithURL:IMG_URL(data[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    nameLabel.text = data[@"nickname"];
    cert.text = N2V(data[@"info"], @"");
    [HYHelper mSetLevelLabel:levelLabel level:data[@"rank"]];
    [HYHelper mSetVImageView:vIV v:data[@"type"] head:headImage];
    content.text = @"";
    if ([N2V(data[@"image"],@"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
        content.attributedText = [HYHelper mBuildAnswerWithDic:data isImage:YES];
    }else{
        content.attributedText = [HYHelper mBuildAnswerWithDic:data isImage:NO];
        content.userInteractionEnabled = NO;
    }
    [timeBtn setTitle:data[@"inputtime"] forState:UIControlStateNormal];
    [addQuestBtn setTitle:[NSString stringWithFormat:@" 追问（%@）",N2V(data[@"anum"],@"0")] forState:UIControlStateNormal];
    [addQuestBtn setInfo:data];
    [answerSumBtn setTitle:[NSString stringWithFormat:@" %@",N2V(data[@"answernum"],@"0")] forState:UIControlStateNormal];
    [readsBtn setTitle:[NSString stringWithFormat:@" %@",N2V(data[@"hits"],@"0")] forState:UIControlStateNormal];
    [supportBtn setTitle:[NSString stringWithFormat:@" 支持（%@）",N2V(data[@"snum"],@"0")] forState:UIControlStateNormal];
    if ([data[@"isadopt"]boolValue]) {
        [adoptBtn setImage:[UIImage imageNamed:@"accepted"] forState:UIControlStateNormal];
    }else {
        if (!issolveed && self.isMe) {
            [adoptBtn setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
            // 采纳
            adoptBtn.info = @{@"index":indexPath};
            [adoptBtn addTarget:self action:@selector(mAdoptAct:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [adoptBtn setImage:nil forState:UIControlStateNormal];
        }
    }
    [HYHelper mLoginID:^(id uID) {
        if (uID && [uID intValue]==[data[@"auid"]intValue]) {
            headImage.superview.backgroundColor = UIColorFromRGB(0xF3FDFF);
        }else {
            headImage.superview.backgroundColor = [UIColor whiteColor];
        }
    }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![HYHelper mLoginID:nil]) {
        [BMUtils showError:@"你还没有登录"];
        return;
    }
    NSDictionary *data = self.mDatas[indexPath.row];
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.mQuest = self.mQuest;
    chatVC.nickName = data[@"nickname"];
    chatVC.auid = [data[@"auid"]integerValue];
    chatVC.aid = [data[@"id"]integerValue];
    chatVC.qid = self.qid;
    chatVC.chatType = kAnswerChat;
    if (self.chatFrom == kChatFromMyAddQuest) {
        chatVC.chatType = kAddQuestChat;
    }
    chatVC.chatFrom = self.chatFrom;
    [self.navigationController pushViewController:chatVC animated:YES];
}

/**
 *  @author 崔俊红, 15-05-05 17:05:43
 *
 *  @brief  消息发送成功
 *  @since v1.0
 */
- (void)mSendSucc:(id)tuid
{
    [self mDownLoad];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
}

/**
 *  @author 崔俊红, 15-05-01 13:05:34
 *
 *  @brief 追问
 *  @since v1.0
 */
- (void)mAddQUestScroll:(UIView*)sv indexPath:(NSIndexPath*)indexPath
{
    NSDictionary *data = self.mDatas[indexPath.row];
    // 获取追问数据
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:@[data[@"id"],self.pid,@3] forKeys:[GET_THREEFTER_PARAM componentsSeparatedByString:@","]];
    [[NetManager sharedManager] myRequestParam:params
                                       withUrl:GET_THREEFTER_API
                                      withType:GET_THREEFTER
                                       success:^(id responseObject){
                                           [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                                [self mInitAddQuestSV:sv data:responseObject];
                                           }];
                                       }failure:^(id error){
                                       
                                       }];
}

/**
 *  @author 崔俊红, 15-05-02 12:05:28
 *
 *  @brief  追问
 *  @param sv    UIScrollView
 *  @param datas 追问数据
 *  @since v1.0
 */
- (void)mInitAddQuestSV:(UIView*)sv data:(NSDictionary*)dic
{
    UIImageView *lastImage = nil;
    NSInteger count = [dic[@"count"]integerValue];
    NSArray *datas = dic[@"objs"];
    for (NSDictionary *data in datas) {
        UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        headImage.layer.masksToBounds = YES;
        headImage.layer.cornerRadius = VWidth(headImage)*0.5;
        [headImage setImageWithURL:IMG_URL(data[@"head"]) placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [sv addSubview:headImage];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sv).with.offset(10);
            if (lastImage) {
                make.top.equalTo(lastImage.mas_bottom).with.offset(10);
            }else{
                make.top.equalTo(sv).with.offset(10);
            }
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        UILabel *nickname = [[UILabel alloc]init];
        nickname.font = [UIFont systemFontOfSize:10.0f];
        nickname.textColor = UIColorFromRGB(0x6A6A6A);
        nickname.numberOfLines = 1;
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc]initWithAttributedString:[[NSMutableAttributedString alloc]initWithString:data[@"nickname"] attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x7899C8)}]];
        [mStr appendAttributedString:[[NSAttributedString alloc]initWithString:@" 回复 " attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x6A6A6A)}]];
        [mStr appendAttributedString:[[NSAttributedString alloc]initWithString:[data[@"askname"]stringByAppendingString:@":"] attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x7899C8)}]];
        nickname.attributedText = mStr;
        [sv addSubview:nickname];
        [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImage.mas_right).with.offset(10);
            make.centerY.equalTo(headImage.mas_centerY);
        }];

       if ([data[@"image"]length]>0) {
           UIImageView *img = [[UIImageView alloc]init];
           img.contentMode = UIViewContentModeScaleAspectFit;
           [img setImageWithURL:IMG_URL(data[@"image"]) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
           [sv addSubview:img];
           [img mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(nickname.mas_right).with.offset(5);
               make.right.lessThanOrEqualTo(sv.mas_right).with.offset(-10);
               make.centerY.equalTo(headImage.mas_centerY);
               make.size.mas_equalTo(CGSizeMake(20, 20));
           }];
       }else{
           UILabel *content = [[UILabel alloc]init];
           content.font = [UIFont systemFontOfSize:10.0f];
           content.textColor = UIColorFromRGB(0x6A6A6A);
           content.numberOfLines = 1;
           content.text = data[@"content"];
           [sv addSubview:content];
           [content mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(nickname.mas_right).with.offset(5);
               make.right.lessThanOrEqualTo(sv.mas_right).with.offset(-10);
               make.centerY.equalTo(headImage.mas_centerY);
           }];
       }
        lastImage = headImage;
    }
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.titleLabel.font = [UIFont systemFontOfSize:12];
    [more setTitleColor:UIColorFromRGB(0x2FBDE7) forState:UIControlStateNormal];
    [more setTitle:[NSString stringWithFormat:@"查看全部%zd条消息", count] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(mToAddQuestAct:) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:more];
    sv.userInteractionEnabled = YES;
    [sv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mToAddQuestAct:)]];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@25);
        make.left.right.equalTo(sv);
        make.bottom.equalTo(sv.mas_bottom);
    }];
    
    UILabel *lineBotTop = [[UILabel alloc]init];
    lineBotTop.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
    [sv addSubview:lineBotTop];
    [lineBotTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sv.mas_top).with.offset(1);
        make.left.right.equalTo(sv);
        make.height.mas_equalTo(@1);
    }];
    UILabel *lineBot = [[UILabel alloc]init];
    lineBot.backgroundColor = [UIColor colorWithWhite:0.898 alpha:1.000];
    [sv addSubview:lineBot];
    [lineBot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sv.mas_bottom).with.offset(-25);
        make.left.right.equalTo(sv);
        make.height.mas_equalTo(@1);
    }];
}

#pragma mark - SurportDelegate
- (void)mSupportSuccWithUserInfo:(NSDictionary *)info
{
    id auid = info[@"auid"];
    __block NSUInteger index = -1;
    [self.mDatas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"auid"]intValue]==[auid intValue]) {
            index = idx;
            *stop = YES;
            return ;
        }
    }];
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:self.mDatas[index]];
    tmp[@"snum"] = @([tmp[@"snum"]intValue]+1);
    self.mDatas[index] = tmp;
    [self.answerTable reloadData];
}
@end