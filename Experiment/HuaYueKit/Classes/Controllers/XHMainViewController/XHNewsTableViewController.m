//
//  XHNewsTableViewController.m
//  MessageDisplayExample
//
//  Created by 曾 宪华 on 14-5-29.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHNewsTableViewController.h"
#import "XHShouTipsView.h"
#import "XHNewsTemplateTableViewCell.h"
#import "XHCommentView.h"
#import "XHFoundationCommon.h"
#import "XHCustomLoadMoreButtonDemoTableViewController.h"
#import "MainTopView.h"
#import "MAinaaaaaaaTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SBJsonParser.h"
#import "XHMyButton.h"
#import "XHMyUIView.h"
#import "UMSocial.h"
#import "XHMyselfViewController.h"
#import "XHWenGaoShouViewController.h"
#import "HYHelper.h"
#import "MZShare.h"
/*
1、别人的提问我进来如果回答过显示“继续回答“，
     如果没回答过显示”回答“，
     点了追问如果追问为”0“显示追问，如果>0显示”继续追问“
2、如果自己提问的只有点了追问下面才出来追问或继续追问的框或按钮
 */
@interface XHNewsTableViewController ()<UMSocialUIDelegate, UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,wenGaoShouDelegate>
{
    XHCommentView *comentView;
    NSInteger index;
    int first;
    UIView *loginView;
    UIView *goOnAnswerView;
    UIView *goOnZhuiWen;
    BOOL zhuiwen;
    NSInteger supportSelectIndex;
    NSMutableArray *explanArr;
}
@property(nonatomic ,strong) XHMyButton*supportBtn;
@property(nonatomic, strong) XHMyButton *zhuiwenBtn;
@property(nonatomic, strong) UIButton *zwBtn;
@property(nonatomic, assign) BOOL isAsk;
@property(nonatomic, strong) XHMyButton *headBtn;

@property(nonatomic, strong)XHMyUIView *suppportView1;
@property(nonatomic, strong)UIView *suppportView2;
@property(nonatomic, strong)UIView *suppportView3;
@property(nonatomic, strong)UITableView *supportTableView;
@property(nonatomic, strong)NSMutableArray *supportArray;
@property(nonatomic, strong)UIView *moreTipView;

@property (nonatomic, strong) NSArray *gaoShouList;

@property (nonatomic, assign) NSInteger zhuiwenIndex;

@property (nonatomic, strong) UILabel *supportLabel;

@property(nonatomic, strong) NSDictionary *myinforMationDic;

@end

@implementation XHNewsTableViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    explanArr = [NSMutableArray new];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@的提问",self.dic[@"nickname"]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"barbuttonicon_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(clickMoreBtn)];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 239, .9);
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewRowAnimationAutomatic;
    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height - 50;
    self.tableView.frame = frame;
    
    NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil];
    comentView = (XHCommentView *)list[2];
    loginView = list[10];
    goOnAnswerView = list[11];
    goOnZhuiWen = list[12];
    goOnAnswerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
    goOnZhuiWen.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
    UIButton *loginBtn = (UIButton *)[loginView viewWithTag:1234];
    UIButton *answerBtn = (UIButton *)[goOnAnswerView viewWithTag:2345];
    UIButton *zhuiwenBtn = (UIButton *)[goOnZhuiWen viewWithTag:3456];
    [answerBtn addTarget:self action:@selector(goOnAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [zhuiwenBtn addTarget:self action:@selector(goOnZhuiWen:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn addTarget:self action:@selector(loginTo:) forControlEvents:UIControlEventTouchUpInside];
    loginView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
    self.zwBtn = (UIButton *)[comentView viewWithTag:1003];
    UITextField *field = (UITextField *)[comentView viewWithTag:1009];
    field.delegate = self;
    [self.zwBtn addTarget:self action:@selector(btnClick:WithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
    comentView.delegate = self;
    comentView.altBtn.enabled = NO;
    comentView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
    
    [self.view addSubview:comentView];
    [self.view addSubview:loginView];
    [self.view addSubview:goOnZhuiWen];
    [self.view addSubview:goOnAnswerView];
    
    if(![HYHelper mLoginID:nil]){
        loginView.hidden = NO;
        [self.view bringSubviewToFront:loginView];
    }else{
        [self.view bringSubviewToFront:comentView];
    }
    //添加上拉加载更多
    __weak XHNewsTableViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf requestDataComment];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
    self.isAsk=YES;
    
    [self requestPersonalInformation];
}

//请求用户信息
- (void)requestPersonalInformation
{
    NSString    *userId     = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if (userId == nil) {
        return;
    }
    
    NSArray *keyValue   = [MY_MEMEBERINFO_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,userId,@(1)] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_MEMEBERINFO_API
                                      withType:MY_MEMEBERINFO
                                       success:^(id responseObject)
     {
         self.myinforMationDic = [[NSDictionary alloc] initWithDictionary:responseObject];
         if ([[self.myinforMationDic objectForKey:@"realname_status"] integerValue] == 1) {
             comentView.altBtn.enabled = YES;
         }
         
     }failure:^(id error){
         [BMUtils showError:error];
     }];
}

#pragma mark - 点击继续回答
-(void)goOnAnswer:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dic];
    [params setValue:[[NSUserDefaults standardUserDefaults]objectForKey:UID] forKey:@"auid"];
    XHCustomLoadMoreButtonDemoTableViewController *chat = [[XHCustomLoadMoreButtonDemoTableViewController alloc] initWithQid:params];
    chat.mChatType = ChatType_Answer;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark - 点击继续追问
- (void)goOnZhuiWen:(UIButton *)sender
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dataSource[self.zhuiwenIndex]];
    [params setValue:[[NSUserDefaults standardUserDefaults]objectForKey:UID] forKey:@"auid"];
    XHCustomLoadMoreButtonDemoTableViewController *chat = [[XHCustomLoadMoreButtonDemoTableViewController alloc] initWithQid:params];
    chat.mChatType = ChatType_Ask;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)loginTo:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    if ([self.gotoLoginDelegate respondsToSelector:@selector(gotoLogin)]) {
        [self.gotoLoginDelegate gotoLogin];
    }
}

- (void) clickMoreBtn{
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"jubao" owner:self options:nil][0];
    [self.view addSubview:view];
    self.moreTipView = view;
    UIButton *shareBtn = (UIButton *)[view viewWithTag:250];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *jubaoBtn = (UIButton *)[view viewWithTag:251];
    [jubaoBtn addTarget:self action:@selector(jubaoAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *canCleBtn = (UIButton *)[view viewWithTag:252];
    [canCleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareAction{
    [[MZShare shared]shareInVC:self title:@"实验助手"image:[UIImage imageNamed:@"share-logo"] url:APPSTOREURL block:nil];
}

- (void)cancleAction{
    [self.moreTipView removeFromSuperview];
}

- (void)jubaoAction
{
    NSString    *userId     = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSArray *keyValue = [QUESTIONS_JUBAO_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,self.strQID?:self.dic[@"id"]] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:QUESTIONS_JUBAO_API
                                      withType:QUESTIONS_JUBAO
                                       success:^(id responseObject)
     {
         [BMUtils showSuccess:@"举报成功"];
     }failure:^(id error){
         [BMUtils showError:error];
     }];
    
    [self.moreTipView removeFromSuperview];
}

- (void)btnClick:(XHMyButton *)sender WithIndexPath:(NSIndexPath *)indexPath{
    switch (sender.tag - 1001) {
        case 0:{
            [self setupSupportViewWithIndex:sender.arrayIndex];
        }
            break;
        case 1:{
            
            if(![HYHelper mLoginID:nil]){
                [BMUtils showError:@"登陆后才能操作"];
                return;
            }
            
            zhuiwen = YES;
            
            NSDictionary *dic = [self.dataSource objectAtIndex:sender.arrayIndex];
            NSInteger num = [[dic objectForKey:@"anum"] integerValue];
            self.zhuiwenIndex = sender.arrayIndex;

            if (num > 0) {
                goOnZhuiWen.hidden = NO;
                
                BOOL has = NO;
                for (XHMyButton *btn in explanArr) {
                    if (btn.arrayIndex == sender.arrayIndex) {
                        has = YES;
                        [explanArr removeObject:btn];
                    }
                }
                
                if (!has) {
                    [explanArr addObject:sender];
                }
                
                [self.view bringSubviewToFront:goOnZhuiWen];
            }else
            {
                [self.view bringSubviewToFront:comentView];
            }
            
            if(zhuiwen)
            {
                self.isAsk = NO;
                self.zwBtn.hidden = NO;
            }else{
                self.isAsk = YES;
                self.zwBtn.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
            break;
        case 2:{
            DLog(@"gaoshou");
//            [self enterMessage];
        }
            break;
 
        default:
            break;
    }
}

- (void)setupSupportViewWithIndex:(int)arrayIndex{
    supportSelectIndex = -1;
    
    self.supportArray = [[NSMutableArray alloc] init];
    NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"TiWenView" owner:nil options:nil];
    XHMyUIView *view = (XHMyUIView *)list[4];
    view.dataSourceArrayIndex = arrayIndex;
    
    self.suppportView1 = view;
    self.suppportView2 = (UIView *)[view viewWithTag:901];
    self.suppportView3 = (UIView *)[view viewWithTag:904];
    self.supportLabel = (UILabel *)[view viewWithTag:100];
    self.supportTableView = (UITableView *)[view viewWithTag:808];
    self.supportTableView.delegate = self;
    self.supportTableView.dataSource = self;
    UIButton *supportBtn = (UIButton *)[view viewWithTag:902];
    [supportBtn addTarget:self action:@selector(supportViewBtnDidClicked:WithIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *looksupportBtn = (UIButton *)[view viewWithTag:903];
    [looksupportBtn addTarget:self action:@selector(supportViewBtnDidClicked:WithIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancleBtn1 = (UIButton *)[view viewWithTag:4000];
    [cancleBtn1 addTarget:self action:@selector(supportViewBtnDidClicked:WithIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancleBtn2 = (UIButton *)[view viewWithTag:4001];
    [cancleBtn2 addTarget:self action:@selector(supportViewBtnDidClicked:WithIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
}

- (void)loadSupportDataSource{
    NSArray *keyValue = [ANSWER_SUPPORT_LIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    
    NSString    *userId    = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if (userId.length <= 0) {
        [BMUtils showError:@"登陆后才能操作"];
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:userId,self.dataSource[self.suppportView1.dataSourceArrayIndex][@"id"],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:ANSWER_SUPPORT_LIST_API withType:ANSWER_SUPPORT_LIST success:^(id responseObject){
        //将登录信息保存本地
        NSLog(@"class%@", [responseObject class]);
        [self.supportArray removeAllObjects];
        if ([responseObject count] > 0) {
            [self.supportArray addObjectsFromArray:responseObject];
            self.supportLabel.text = [NSString stringWithFormat:@"共%lu个支持者",(unsigned long)[self.supportArray count]];
            [self.supportTableView reloadData];
        }
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}

- (void)supportViewBtnDidClicked:(UIButton *)sender WithIndex:(int)arrayIndex{
    if (sender.tag == 902) {
         if(![HYHelper mLoginID:nil]){
             [BMUtils showError:@"登陆后才能操作"];
             return;
         }
        [self supportConnectionWithIndexPath:self.suppportView1.dataSourceArrayIndex];
        [self.suppportView1 removeFromSuperview];
        [self.tableView.legendHeader beginRefreshing];
    }else if (sender.tag == 4000){
        [self.suppportView1 removeFromSuperview];
        [self.tableView.legendHeader beginRefreshing];
    }else if (sender.tag == 903){
        [self.suppportView2 removeFromSuperview];
        [self loadSupportDataSource];
        self.suppportView3.hidden = NO;
    }else if (sender.tag == 4001){
        [self.suppportView1 removeFromSuperview];
    }
}
- (void)reloadData
{
    self.pageNum = 1;
    [self requestDataComment];
}

-(void)requestDataComment{
    
    __weak XHNewsTableViewController *weakMy = self;
    
    NSArray *keyValue = [ANSWER_INFO_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (self.strQID.length > 0) {
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)self.pageNum],[NSNumber numberWithInt:20],self.strQID,nil] forKeys:keyValue];
    }else if ([[self.dic allKeys] containsObject:@"value"]){
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)self.pageNum],[NSNumber numberWithInt:20],self.dic[@"value"],nil] forKeys:keyValue];
    }else{
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)self.pageNum],[NSNumber numberWithInt:20],self.dic[@"id"],nil] forKeys:keyValue];
    }
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:ANSWER_INFO_API
                                      withType:ANSWER_INFO
                                       success:^(id responseObject){
                                           if (self.pageNum == 1) {
                                               [weakMy.dataSource removeAllObjects];
                                           }
                                            [weakMy.dataSource addObjectsFromArray:responseObject];
                                           self.pageNum ++;
                                           
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                           [weakMy.tableView.legendFooter endRefreshing];
                                       }failure:^(id error){
                                           
                                           [weakMy.tableView reloadData];
                                           [weakMy.tableView.legendHeader endRefreshing];
                                           [weakMy.tableView.legendFooter endRefreshing];
                                           
                                       }];
}
#pragma mark - 键盘通知

-(void)supportConnectionWithIndexPath:(NSInteger )arrayIndex{
    __weak XHNewsTableViewController *weakMy = self;
    NSArray *keyValue = [ANSWER_ADD_SUPPORT_PARAM componentsSeparatedByString:@","];
    NSLog(@"indexPath<<<<<<<<%ld", (long)arrayIndex);
    NSString    *userId    = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if (userId.length <= 0) {
        [BMUtils showError:@"登陆后才能操作"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:userId?:@"",@([self.dataSource[arrayIndex][@"id"] intValue]),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:ANSWER_ADD_SUPPORT_API withType:ANSWER_ADD_SUPPORT success:^(id responseObject){
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];

    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}


- (void)replayCommentAxtion:(NSString *)disId
{
    if (self.isAsk) {//回答
        [self replayComment:disId image:@""];
    }else{//追问
        [self askComment:disId image:@""];
    }
}

#pragma mark - 点击拍照
- (void)clickCamr
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [action showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 1:
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
    }
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    [[NetManager sharedManager] uploadImage:image success:^(id responseObject) {
        if (responseObject != nil && [[responseObject objectForKey:@"code"] integerValue] == 88) {
            if (self.isAsk) {
                [self replayComment:@"" image:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"url"]]];
            }else
            {
                [self askComment:@"" image:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"url"]]];
            }
        }
    } failure:^(id errorString) {
        NSLog(@"%@",errorString);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 点击@
- (void)clickAlt
{
    XHWenGaoShouViewController *control = [[XHWenGaoShouViewController alloc] init];
    control.mydelegate = self;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)didSelectedWithGaoShou:(NSMutableArray *)dArray
{
    if (dArray.count > 0) {
        self.gaoShouList = dArray;
        [self setTextFieldLeftView];
    }
}

- (void)setTextFieldLeftView
{
    [comentView setAltView:self.gaoShouList];
}

- (void)askComment:(NSString *)disId image:(NSString *)imageUrl{
    if(![HYHelper mLoginID:nil]){
        [self.alertView show];
        return;
    }
    
    if((comentView.textFiled.text == nil || [comentView.textFiled.text isEqualToString:@""]) && imageUrl.length == 0){
        [BMUtils showError:@"回答不能为空"];
        return;
    }
    
    __weak XHNewsTableViewController *weakMy = self;
    NSArray *keyValue = [ANSWER_ADDQUES_PARAM componentsSeparatedByString:@","];
    DLog(@"self.dic<<<<<<<<<<<%@", self.dataSource[index]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([[self.dic allKeys] containsObject:@"value"]){
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],self.dic[@"value"],self.dataSource[index][@"id"], comentView.textFiled.text,imageUrl,self.dataSource[index][@"id"],nil] forKeys:keyValue];
    }else{
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId], self.dic[@"id"], self.dataSource[index][@"id"],comentView.textFiled.text,imageUrl,self.dataSource[index][@"id"],nil] forKeys:keyValue];
    }
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:ANSWER_ADDQUES_API withType:ANSWER_ADDQUES success:^(id responseObject){
        [self.view bringSubviewToFront:goOnZhuiWen];
        zhuiwen = YES;
        [weakMy reloadData];
    }failure:^(id error){
       [BMUtils showError:error];
    }];
    
    [comentView.textFiled resignFirstResponder];
    comentView.textFiled.text = @"";
    

}
- (void)replayComment:(NSString *)disId image:(NSString *)imageUrl{
    if((comentView.textFiled.text == nil || [comentView.textFiled.text isEqualToString:@""]) && imageUrl == 0){
        [BMUtils showError:@"回答不能为空"];
        return;
    }
    
    __weak XHNewsTableViewController *weakMy = self;
    
    NSArray *keyValue = [ANSWER_ADD_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([[self.dic allKeys] containsObject:@"value"]){
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],self.dic[@"value"],@"0",comentView.textFiled.text,imageUrl,nil] forKeys:keyValue];
    }else{
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],self.dic[@"id"],@"0",comentView.textFiled.text,imageUrl,nil] forKeys:keyValue];
    }
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:ANSWER_ADD_API withType:ANSWER_ADD success:^(id responseObject){
        
        [weakMy reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
    [comentView.textFiled resignFirstResponder];
    comentView.textFiled.text = @"";

}
/*
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self bottomViewMoveWithKeyBordHeight:self.view.frame.size.height - 50 withDuraton:animationDuration];
}

- (void)bottomViewMoveWithKeyBordHeight:(CGFloat)height withDuraton:(NSTimeInterval)animationDuration
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    comentView.frame = CGRectMake(0, height , comentView.frame.size.width, comentView.frame.size.height);
    [UIView commitAnimations];
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    
    for (NSDictionary *dic in self.dataSource) {
        if ([dic[@"auid"] intValue] == [[userDefault objectForKey:UID] intValue]) {
            if (!zhuiwen) {
                if(![HYHelper mLoginID:nil]){
                    [self.view bringSubviewToFront:loginView];
                }else{
                    [self.view bringSubviewToFront:goOnAnswerView];
                }
            }
        }
    }
    
    if (tableView.tag == 808) {
        return 1;
    }
    return self.dataSource.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 808) {
        return 0;
    }
    
    if (section ==0 ) {
        return 85;
    }else{
        return 90;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UITableViewCell*   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        for(UIView *view in cell.contentView.subviews){
            [view removeFromSuperview];
        }
        MainTopView *view = (MainTopView *)ViewFromXib(@"MainView", 0);
        view.title.text = self.dic[@"content"];
        view.label.text = [self.dic objectForKey:@"lable"];
        view.time.text =  N2V(self.dic[@"inputtime"], @"");
        view.person.text = [NSString stringWithFormat:@"%@人回答",WYISBLANK([self.dic objectForKey:@"anum"])];
        NSString    *superlist  = WYISBLANK([self.dic objectForKey:@"superlist"]);
        view.gaoshou.text = superlist.length > 0?[NSString stringWithFormat:@"邀请%@回答",superlist]:@"";
        
        [cell.contentView addSubview:view];
               NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
         if ([self.dic[@"uid"] intValue] == [[userDefault objectForKey:UID] intValue])
         {
             comentView.hidden=YES;
             loginView.hidden=YES;
             goOnAnswerView.hidden=YES;
             goOnZhuiWen.hidden=YES;
         }
        return cell;
        
    }else{
         NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil];
        MAinaaaaaaaTableViewCell *cell = (MAinaaaaaaaTableViewCell *)list[1];
        
        self.supportBtn = ( XHMyButton*)[cell viewWithTag:1001];
        self.supportBtn.arrayIndex = section - 1;
        [self.supportBtn addTarget:self action:@selector(btnClick:WithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        XHMyButton *inforBtn = (XHMyButton *)[cell viewWithTag:7000];
        [inforBtn addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
        inforBtn.arrayIndex = section - 1;
        XHMyButton *zhuiwenBtn = (XHMyButton *)[cell viewWithTag:1002];
        zhuiwenBtn.arrayIndex = section - 1;
        
        XHMyButton *answerBtn = (XHMyButton *)[cell viewWithTag:1111];
        [answerBtn addTarget:self action:@selector(clickListAnswer:) forControlEvents:UIControlEventTouchUpInside];
        answerBtn.arrayIndex = section - 1;

        self.zhuiwenBtn = zhuiwenBtn;
        [self.zhuiwenBtn addTarget:self action:@selector(btnClick:WithIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *dic = [self.dataSource objectAtIndex:section-1];
        [cell.myHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        cell.name.text = dic[@"nickname"];
        cell.time.text = N2V(dic[@"inputtime"], @"");
        cell.commentNum.text = dic[@"anum"];
        NSString *content = dic[@"content"];
        NSString *image = dic[@"image"];
        if (content.length > 0) {
            cell.content.text = dic[@"content"];
        }
        if (image.length > 0) {
            cell.content.text = @"[图片]";
        }
        cell.zhichi.text = [NSString stringWithFormat:@"支持：%@",dic[@"snum"]];
        cell.zhuiwen.text = [NSString stringWithFormat:@"追问：%@",dic[@"anum"]];
        
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        if ([self.dataSource[section-1][@"auid"] intValue] == [[userDefault objectForKey:UID] intValue]) {
            cell.commentView.backgroundColor=[UIColor colorWithRed:195/255.0 green:234/255.0 blue:244/255.0 alpha:255/255.0];
        }else{
            cell.commentView.backgroundColor=[UIColor whiteColor];
        }
        NSInteger isadopt = [[dic objectForKey:@"isadopt"] integerValue];
        if (isadopt == 0) {
            cell.tipImageView.hidden = YES;
        }else
        {
            cell.tipImageView.hidden = NO;
        }
        return cell;
    }
}

- (void)clickListAnswer:(XHMyButton *)btn
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [self.dataSource objectAtIndex:btn.arrayIndex];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
    [params addEntriesFromDictionary:self.dic];
    XHCustomLoadMoreButtonDemoTableViewController *chat = [[XHCustomLoadMoreButtonDemoTableViewController alloc] initWithQid:params];

    chat.mChatType = ChatType_Answer;
    chat.aid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    id uid = [userDefault objectForKey:UID];
    if ([[dic objectForKey:@"auid"] integerValue] == [uid integerValue]) {
        chat.inputHide = NO;
    }else
    {
        if ([uid integerValue]==[self.dic[@"uid"] integerValue]) {
            chat.inputHide = NO;
        }else{
             chat.inputHide = YES;
        }
    }
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)gointoInformationWith:(XHMyButton *)sender Index:(int)index{
    [HYHelper pushPersonCenterOnVC:self uid:[self.dataSource[sender.arrayIndex][@"auid"] intValue]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 808) {
        return self.supportArray.count;
    }
    
    for (XHMyButton *btn in explanArr) {
        if ([btn isKindOfClass:[XHMyButton class]]) {
            if (section == btn.arrayIndex + 1) {
                NSDictionary *dic = [self.dataSource objectAtIndex:btn.arrayIndex];
                NSInteger num = [[dic objectForKey:@"anum"] integerValue];
                if (num > 0) {
                    NSString *str = [dic objectForKey:@"afterdata"];
                    NSArray *list = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                    if (num <= 3) {
                        return list.count;
                    }else
                    {
                        return 4;
                    }
                }
            }
        }
    }
    return 0;
}

- (void)clickGz:(id)sender events:(UIEvent *)event
{
    UITouch *touch  = [[event allTouches] anyObject];
    CGPoint point   = [touch locationInView:self.supportTableView];
    NSIndexPath *indexPath  = [self.supportTableView indexPathForRowAtPoint:point];
    
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic = self.supportArray[indexPath.row];
    
    NSString    *userId    = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSString    *toUid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"uid"]];
    
    if ([userId isEqualToString:toUid]) {
        return;
    }
    
    NSArray     *keyValue   = [MY_ATTENTION_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjects:@[userId,toUid] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:param
                                       withUrl:MY_ATTENTION_API
                                      withType:MY_ATTENTION
                                       success:^(id responseObject) {
                                           [BMUtils showSuccess:@"关注成功"];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 808) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"supportcell"];
        if (cell == nil) {
            NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"TiWenView" owner:nil options:nil];
            cell = (UITableViewCell *)list[5];
        }
        
        NSDictionary *dic = [[NSDictionary alloc] init];
        dic = self.supportArray[indexPath.row];
        UIImageView *headImage = (UIImageView *)[cell viewWithTag:6001];
        UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:6002];
        UILabel *campLabel = (UILabel *)[cell viewWithTag:6003];
        UILabel *fansLabel = (UILabel *)[cell viewWithTag:6004];
        UIButton *gzButton = (UIButton *)[cell viewWithTag:6005];
        
        [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
        nickNameLabel.text = WYISBLANK(dic[@"nickname"]);
        campLabel.text = WYISBLANK(dic[@"company"]);
        fansLabel.text = WYISBLANK(dic[@"nickname"]);
        
        [gzButton addTarget:self action:@selector(clickGz:events:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil];

    if (indexPath.row == 3) {
        return (UITableViewCell *)list[8];
    }
    
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.section - 1];
    
    UITableViewCell *cell = (UITableViewCell *)list[7];
    UILabel *nickNameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *contentLabel = (UILabel *)[cell viewWithTag:102];
    
    NSString *str = [dic objectForKey:@"afterdata"];
    NSArray *dataList = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *dict = [dataList objectAtIndex:indexPath.row];
    nickNameLabel.text = [dict objectForKey:@"nickname"];
    contentLabel.text = [dict objectForKey:@"content"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XHCustomLoadMoreButtonDemoTableViewController *demoWeChatMessageTableViewController = [[XHCustomLoadMoreButtonDemoTableViewController alloc] initWithQid:self.dataSource[indexPath.section - 1]];
    
    [self.navigationController pushViewController:demoWeChatMessageTableViewController animated:YES];
}

#pragma mark - UITableView Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(![HYHelper mLoginID:nil]){
        [self.alertView show];
        return NO;
    }else{
        return YES;
    }
}

@end
