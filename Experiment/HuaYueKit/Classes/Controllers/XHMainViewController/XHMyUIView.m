//
//  XHMyUIView.m
//  HuaYue
//
//  Created by lee on 15/1/18.
//
//

#import "XHMyUIView.h"
#import "NetManager.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "BMUtils.h"
#import "NSObject+Cate.h"
#import "HYHelper.h"
#import "UIView+Cate.h"

@interface XHMyUIView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sopportSum;
@property (weak, nonatomic) IBOutlet UITableView *supportTbv;
@property (weak, nonatomic) IBOutlet UIView *tbvView;
@property (weak, nonatomic) IBOutlet UIView *dialogView;
@property (strong, nonatomic) NSMutableArray *mDatas;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation XHMyUIView
{
    BOOL isSearch;
}

- (void)awakeFromNib
{
    _supportTbv.delegate = self;
    _supportTbv.dataSource  =self;
    _supportTbv.rowHeight = 51;
    self.mDatas = [NSMutableArray array];
    UITapGestureRecognizer *singleTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    singleTwo.delegate = self;
    [self addGestureRecognizer:singleTwo];
    UITableViewHeaderFooterView *foot = [[UITableViewHeaderFooterView alloc]init];
    foot.backgroundColor = [UIColor blackColor];
    [_supportTbv setTableFooterView:foot];
    if ([_supportTbv respondsToSelector:@selector(setLayoutMargins:)]) {
        _supportTbv.layoutMargins = UIEdgeInsetsZero;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint =[touch locationInView:self];
    CGPoint p = [isSearch?_tbvView:_dialogView convertPoint:touchPoint fromView:self];
    if ([isSearch?_tbvView:_dialogView pointInside:p withEvent:nil]) {
        return  YES;
    }else{
        [self mRemoved];
        return NO;
    }
}

- (void)mRemoved
{
    [self removeFromSuperview];
    dispatch_block_t callBlock = self.info[@"callBlock"];
    if (callBlock) {
        callBlock();
    }
}
/**
 *  @author 崔俊红, 15-05-02 15:05:59
 *
 *  @brief  支持
 *  @param sender UIButton
 *  @since v1.0
 */
- (IBAction)supportAct:(id)sender {
    [HYHelper mLoginID:^(id uid) {
        if (!uid) {
            [BMUtils showError:@"您还没有登录！"];
            return;
        }else{
            NSArray *keyValue = [ANSWER_ADD_SUPPORT_PARAM componentsSeparatedByString:@","];
            if ([self.info[@"auid"] compare:uid]==NSOrderedSame) {
                [BMUtils showError:@"很抱歉，自己不能支持自己！"];
                return;
            }
            NSMutableDictionary *dic =  [NSMutableDictionary dictionaryWithObjects:@[uid?uid:@"0",@([self.info[@"id"] intValue])] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:dic
                                               withUrl:ANSWER_ADD_SUPPORT_API
                                              withType:ANSWER_ADD_SUPPORT success:^(id responseObject){
                                                  [BMUtils showSuccess:@"支持成功"];
                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadAnswerList" object:nil];
                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
                                                  /*if (self.delegate && [self.delegate respondsToSelector:@selector(mSupportSuccWithUserInfo:)]) {
                                                      [self.delegate performSelector:@selector(mSupportSuccWithUserInfo:) withObject:@{@"auid":self.info[@"auid"]}];
                                                  }*/
                                                  [self removeFromSuperview];
                                              }failure:^(id error){
                                                  [BMUtils showError:error];
                                              }];
        }
    }];
}

/**
 *  @author 崔俊红, 15-05-02 15:05:18
 *
 *  @brief  查看支持
 *  @param sender UIButton
 *  @since v1.0
 */
- (IBAction)searchAct:(id)sender {
    isSearch = YES;
    _dialogView.hidden = YES;
    _tbvView.hidden = NO;
    _closeBtn.hidden = NO;
}

- (IBAction)closeSearchAct:(id)sender {
    [self mRemoved];
}

- (void)mLoadData
{
    [HYHelper mLoginID:^(id userId) {
        id uid = userId?userId:@"0";
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[uid,self.info[@"id"]] forKeys:[ANSWER_SUPPORT_LIST_PARAM componentsSeparatedByString:@","]];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:ANSWER_SUPPORT_LIST_API
                                          withType:ANSWER_SUPPORT_LIST
                                           success:^(id responseObject){
                                               [_mDatas removeAllObjects];
                                               if ([responseObject count] > 0) {
                                                   [_mDatas addObjectsFromArray:responseObject];
                                                   _sopportSum.text = [NSString stringWithFormat:@"共%lu个支持者",(unsigned long)_mDatas.count];
                                                   [_supportTbv reloadData];
                                               }
                                           }failure:^(id error){}];
    }];
}

#pragma mark - 数据处理

#pragma mark - 事件处理
- (void)mAttentionAct:(UIButton*)sender
{
    [HYHelper mLoginID:^(id userId) {
        if (!userId) {
            [BMUtils showError:@"您还没有登录！"];
            return;
        }else{
            NSString *toUid = [NSString stringWithFormat:@"%@",sender.info[@"uid"]];
            if ([userId isEqualToString:toUid]) {
                [BMUtils showError:@"很抱歉，自己不能关注自己！"];
                return;
            }
            NSArray *keyValue = [MY_ATTENTION_PARAM componentsSeparatedByString:@","];
            NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[userId,toUid] forKeys:keyValue];
            [[NetManager sharedManager] myRequestParam:param
                                               withUrl:MY_ATTENTION_API
                                              withType:MY_ATTENTION
                                               success:^(id responseObject) {
                                                   [BMUtils showSuccess:@"关注成功"];
                                                   [self mLoadData];
                                               }failure:^(id error){
                                                   [BMUtils showError:error];
                                               }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _mDatas?_mDatas.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SupportCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = ViewFromXib(@"TiWenView", 5);
    }
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = _mDatas[indexPath.row];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:6001];
    UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:6002];
    UILabel *campLabel = (UILabel *)[cell viewWithTag:6003];
    UILabel *fansLabel = (UILabel *)[cell viewWithTag:6004];
    UILabel *rank = (UILabel *)[cell viewWithTag:6006];
    UIButton *gzButton = (UIButton *)[cell viewWithTag:6005];
    UIImageView *vImge = (UIImageView *)[cell viewWithTag:6007];
    UIView *bg = [cell viewWithTag:999];
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
 
    nickNameLabel.text = WYISBLANK(dic[@"nickname"]);
    campLabel.text = WYISBLANK(dic[@"company"]);
    fansLabel.text = WYISBLANK(dic[@"supportnum"]);
    [HYHelper mSetLevelLabel:rank level:dic[@"rank"]];
    [HYHelper mSetVImageView:vImge v:N2V(dic[@"type"], @"") head:headImage];
    gzButton.info = dic;
    [gzButton addTarget:self action:@selector(mAttentionAct:) forControlEvents:UIControlEventTouchUpInside];
    WS(ws);
    headImage.info = @{@"uid":dic[@"uid"]};
    headImage.tapBlock = ^(UIImageView* headIV){
        [HYHelper pushPersonCenterOnVC:[ws viewController] uid:[headIV.info[@"uid"]intValue]];
    };
    __block BOOL same  = [dic[@"same"]boolValue];
    [HYHelper mLoginID:^(id uid) {
        if (uid && [uid intValue]==[dic[@"uid"]intValue]) {
            same = YES;
        }
    }];
    gzButton.enabled = !same;
    bg.backgroundColor = same?UIColorFromRGB(0xF6F6F6):UIColorFromRGB(0xACCC73);
    gzButton.backgroundColor = same?[UIColor clearColor]:UIColorFromRGB(0xE0F2B7);
    fansLabel.textColor = same?UIColorFromRGB(0xA2A2A2):[UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
