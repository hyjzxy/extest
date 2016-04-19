//
//  XHDemoTableViewController.m
//  XHRefreshControlExample
//
//  Created by 曾 宪华 on 14-6-8.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHDemoTableViewController.h"
#import "XHShouTipsView.h"
#import "NSDate+TimeAgo.h"
#import "XHShouTipsTableViewCell.h"
#import "AppDelegate.h"
#import "UIButton+WebCache.h"
#import "UMSocial.h"
#import "XHFoundationCommon.h"
#import "ChartCell.h"
#import "ChartCellFrame.h"
#import "UIImageView+WebCache.h"
#import "XHCustomLoadMoreButtonDemoTableViewController.h"
#import "UIProgressView+AFNetworking.h"
#import "MZShare.h"
#import "HYHelper.h"

@interface XHDemoTableViewController ()<UITextFieldDelegate,ChartCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    int page;
//    XHCommentView *comentView;
    NSInteger index;
    NSMutableArray *selectedArray;
    NSMutableArray *unselectedArray;
    int first;
    UIView *loginView;
    UIView *goOnAnswerView;
    UIView *goOnZhuiWen;
    BOOL zhuiwen;
    UITextField *contentlabel;
}

@property(nonatomic, strong)UIView *moreTipView;
@end

@implementation XHDemoTableViewController
- (instancetype)initWithQid:(NSDictionary *)dic{
//    self = [super init];
    if (self = [super init]) {
        self.dic = dic;
    }
    return self;
}
-(void)dealloc{
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 别把这行代码放到别处，然后导致了错误，那就不好了嘛！
//    [self startPullDownRefreshing];
}
- (void)loadView{
    [super loadView];
    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height - 50;
    self.tableView.frame = frame;
    
    if (!_inputHide) {
        NSArray *list = [[NSBundle mainBundle] loadNibNamed:@"MainView" owner:nil options:nil];
        loginView = list[10];
        goOnAnswerView = list[3];
        goOnZhuiWen = list[12];
        goOnZhuiWen.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
        UIButton *zhuiwenBtn = (UIButton *)[goOnZhuiWen viewWithTag:3456];
        [zhuiwenBtn addTarget:self action:@selector(goOnZhuiWen:) forControlEvents:UIControlEventTouchUpInside];
        goOnAnswerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
        UIButton *answerBtn = (UIButton *)[goOnAnswerView viewWithTag:777];
        contentlabel = (UITextField *)[goOnAnswerView viewWithTag:888];
        [answerBtn addTarget:self action:@selector(sendContent) forControlEvents:UIControlEventTouchUpInside];
        UIButton *camrBtn = (UIButton *)[goOnAnswerView viewWithTag:999];
        [camrBtn addTarget:self action:@selector(clickCamr) forControlEvents:UIControlEventTouchUpInside];
        UIButton *loginBtn = (UIButton *)[loginView viewWithTag:1234];
        loginView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50 - [XHFoundationCommon getAdapterNavHeight], 320, 50);
        loginBtn.hidden = YES;
        contentlabel.delegate = self;
        [self.view addSubview:loginView];
        [self.view addSubview:goOnZhuiWen];
        [self.view addSubview:goOnAnswerView];
        
        if([HYHelper mLoginID:nil]){
            loginBtn.hidden = NO;
        }else{
            id uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
            if ([self.dic[@"auid"] integerValue] != [uid integerValue]) {
                goOnAnswerView.hidden = YES;
               [self.view bringSubviewToFront:goOnZhuiWen];
            }else {
                goOnZhuiWen.hidden = YES;
                [self.view bringSubviewToFront:goOnAnswerView];
            }
        }
    }
}

- (void)sendContent{
    [self replayComment:@""];
}
- (void)replayComment:(NSString *)image{
    if((contentlabel.text == nil || [contentlabel.text isEqualToString:@""]) && image.length == 0){
        [BMUtils showError:@"回答不能为空"];
        return;
    }
    __weak XHDemoTableViewController *weakMy = self;
    NSArray *keyValue = [ANSWER_ADD_PARAM componentsSeparatedByString:@","];
    
    NSString *url = ANSWER_ADD_API;
    NSString *type = ANSWER_ADD;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (self.mChatType == ChatType_Ask) {
        url = ANSWER_ADDQUES_API;
        type = ANSWER_ADDQUES;
        keyValue = [ANSWER_ADDQUES_PARAM componentsSeparatedByString:@","];
        
        dic = [[NSMutableDictionary alloc] initWithObjects:@[[self getUserId],self.dic[@"qid"],self.dic[@"id"],contentlabel.text,image,self.dic[@"id"],self.dic[@"id"]] forKeys:keyValue];
    }else
    {
        if ([[self.dic allKeys] containsObject:@"value"])
        {
            dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],self.dic[@"value"],@"0",contentlabel.text,image,nil] forKeys:keyValue];
        }else{
            dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[self getUserId],self.dic[@"id"],@"0",contentlabel.text,image,nil] forKeys:keyValue];
        }
    }
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:url
                                      withType:type
                                       success:^(id responseObject){
                                           [weakMy reloadData];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
    
    [contentlabel resignFirstResponder];
    contentlabel.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"回答";
    
    self.tableView.backgroundColor = RGBACOLOR(239, 239, 239, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[ChartCell class] forCellReuseIdentifier:@"ChartCell"];
    
    page = 1;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;

    //添加上拉加载更多
    __weak XHDemoTableViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
          [blockSelf reloadData];
    }];
    if (_mChatType == ChatType_Answer) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];

        if ([self.dic[@"uid"] integerValue] == [[userDefault objectForKey:UID] integerValue] && [self.dic[@"issolveed"] integerValue] == 0) {
            UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame = CGRectMake(0, 7, 64, 30);
            [rightBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-5"] forState:UIControlStateNormal];
            [rightBtn addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightBtn setTitle:@"采纳答案" forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = rightBarButton;
        }
    }
    
    [self.tableView.legendHeader beginRefreshing];
    if (!goOnAnswerView.hidden) {
        [self.view bringSubviewToFront:goOnAnswerView];
    }
    if (!goOnZhuiWen.hidden) {
        [self.view bringSubviewToFront:goOnZhuiWen];
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
    [picker dismissViewControllerAnimated:YES completion:nil];
    //NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    NSData *imageData = [HYHelper imageCompressWithImage:image];
    NSURL *uploadURL = [NSURL URLWithString:UploadPathAPI];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uploadURL];
    request.HTTPMethod  = @"POST";
     NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", imageData.length] forHTTPHeaderField:@"Content-Length"];
    
    UIProgressView *pv = [[UIProgressView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 5)];
    [self.view addSubview:pv];
     NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         id d = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
         dispatch_async(dispatch_get_main_queue(), ^{
             [pv removeFromSuperview];
         });
     }];
    [pv setProgressWithUploadProgressOfTask:uploadTask animated:YES];
    [uploadTask resume];
    /*
    [[NetManager sharedManager] uploadImage:image success:^(id responseObject) {
        if (responseObject != nil && [[responseObject objectForKey:@"code"] integerValue] == 88) {
            [self replayComment:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"url"]]];
        }
    } failure:^(id errorString) {
        NSLog(@"%@",errorString);
    }];*/
}


-(void)rightNavItemClick{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefault objectForKey:UID];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:uid forKey:@"uid"];
    [param setObject:_aid forKey:@"aid"];

    [[NetManager sharedManager] myRequestParam:param withUrl:ANSWER_ADOPT_API withType:ANSWER_ADOPT success:^(id responseObject) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回答已采纳" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        
    } failure:^(id errorString) {

    }];
}

-(void)reloadMoreData{
    id uid = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    __weak XHDemoTableViewController *weakMy = self;

    NSInteger qid =  [self.dic[@"id"] integerValue];
    
    NSArray *keyValue = [ADD_QUES_LIST_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = nil;
    NSString *url = ADD_QUES_LIST_API;
    NSString *type = ADD_QUES_LIST;
    
    if (_mChatType == ChatType_Answer)
    {
        /*
        keyValue = [ANSWER_INFO_PARAM componentsSeparatedByString:@","];
        url = ANSWER_INFO_API;
        type = ANSWER_INFO;
        */
        url = MY_ANSWER_LIST_API;
        type = MY_ANSWER_LIST;
        keyValue = [MY_ANSWER_LIST_PARAM componentsSeparatedByString:@
                    ","];
        dic = [[NSMutableDictionary alloc] initWithObjects:@[self.dic[@"auid"],[NSString stringWithFormat:@"%d",page],@(20),@(qid)] forKeys:keyValue];
    }else
    {
        dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@(qid),[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    }
    [[NetManager sharedManager] myRequestParam:dic withUrl:url withType:type success:^(id responseObject){
        if (page == 1) {
            [weakMy.dataSource removeAllObjects];
            [weakMy.dataSource addObjectsFromArray:responseObject];
        }else {
            [weakMy.dataSource addObjectsFromArray:responseObject];
        }
        page++;
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }failure:^(id error){
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }];
}

- (void)reloadData
{
    page = 1;
    
    [self reloadMoreData];
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
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,self.dic[@"id"]] forKeys:keyValue];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XHRefreshControl Delegate

- (NSString *)lastUpdateTimeString {
    
    NSDate *nowDate = [NSDate date];
    
    NSString *destDateString = [nowDate timeAgo];
    
    return destDateString;
}

- (UIView *)customPullDownRefreshView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.tag = 100;
    progressView.frame = CGRectMake(0, CGRectGetHeight(backgroundView.bounds) / 2.0 - 3, 320, 3);
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        progressView.tintColor = [UIColor orangeColor];
    }
    [backgroundView addSubview:progressView];
    return backgroundView;
}

- (void)customPullDownRefreshView:(UIView *)customPullDownRefreshView withPullDownOffset:(CGFloat)pullDownOffset {
    UIProgressView *progessView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    [progessView setProgress:pullDownOffset / 40.0 animated:NO];
}

- (void)customPullDownRefreshViewWillStartRefresh:(UIView *)customPullDownRefreshView {
    UIProgressView *progressView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    [progressView setProgress:1.0];
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        [progressView setTintColor:[UIColor greenColor]];
    }
}

- (void)customPullDownRefreshViewWillEndRefresh:(UIView *)customPullDownRefreshView {
    UIProgressView *progressView = (UIProgressView *)[customPullDownRefreshView viewWithTag:100];
    if ([progressView respondsToSelector:@selector(setTintColor:)]) {
        [progressView setTintColor:[UIColor greenColor]];
    }
    [progressView setProgress:0.0 animated:NO];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChartCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc] init];
        ChartMessage *chartMessage = [[ChartMessage alloc] init];
        chartMessage.dict = self.dic;
        chartMessage.icon = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dic objectForKey:@"head"])];
        chartMessage.content = WYISBLANK(self.dic[@"content"]);
        cellFrame.chartMessage = chartMessage;
        
        NSString *auid = WYISBLANK(self.dic[@"uid"]);
        
        if ([auid isEqualToString:[self myUserId]]) {
            chartMessage.messageType = kMessageTo;
        }else
        {
            chartMessage.messageType = kMessageFrom;
        }
        
        chartMessage.time = N2V(self.dic [@"inputtime"], @"");
        
        cell.cellFrame = cellFrame;
        
    }else{
        NSDictionary *dicM = self.dataSource[indexPath.row - 1];
        NSString *auid = WYISBLANK(dicM[@"auid"]);

        NSString *contentStr = dicM[@"content"];
        if (dicM[@"type"] && self.mChatType == ChatType_Ask) {
            contentStr = [NSString stringWithFormat:@"追问: %@", contentStr];
        }
        
        NSString *image = [dicM objectForKey:@"image"];
        
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc] init];
        ChartMessage *chartMessage = [[ChartMessage alloc] init];
        chartMessage.dict = dicM;
        chartMessage.icon = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dicM objectForKey:@"head"])];
        chartMessage.content = contentStr;
        chartMessage.time =  N2V(dicM[@"inputtime"], @"");
        
        if ([auid isEqualToString:[self myUserId]]) {
            chartMessage.messageType = kMessageTo;
        }else
        {
            chartMessage.messageType = kMessageFrom;
        }
        
        chartMessage.contentType = MessageType_Content;
        
        if (image.length > 0) {
            chartMessage.contentType = MessageType_Image;
            chartMessage.imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,image];
        }
        
        cellFrame.chartMessage = chartMessage;
        
        cell.cellFrame = cellFrame;
    }
    
    return cell;
}

#pragma mark - ChartDelegate
- (void)chartCell:(ChartCell *)chartCell tapContent:(NSString *)content
{
    if (chartCell.cellFrame.chartMessage.contentType == MessageType_Image) {
        [self lookMaxImage:chartCell.cellFrame.chartMessage.imgUrl];
    }
}

- (void)lookMaxImage:(NSString *)imgUrl
{
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = [UIScreen mainScreen].bounds;
    contentView.backgroundColor = [UIColor blackColor];
    contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaxImageView:)];
    [contentView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contentView.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    [contentView addSubview:imageView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:contentView];
}

- (void)tapMaxImageView:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}

- (NSString *)myUserId
{
    NSString    *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    
    return userId;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChartCellFrame *cellFrame = [[ChartCellFrame alloc] init];
        ChartMessage *chartMessage = [[ChartMessage alloc] init];
        chartMessage.dict = self.dic;
        chartMessage.icon = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.dic objectForKey:@"head"])];
        chartMessage.content = WYISBLANK(self.dic[@"content"]);
        cellFrame.chartMessage = chartMessage;
        
        NSString *auid = WYISBLANK(self.dic[@"uid"]);

        if ([auid isEqualToString:[self myUserId]]) {
            chartMessage.messageType = kMessageTo;
        }else
        {
            chartMessage.messageType = kMessageFrom;
        }
        
        chartMessage.time =  N2V(self.dic[@"inputtime"], @"");

        return [cellFrame cellHeight];
    }
    
    NSDictionary *dicM = self.dataSource[indexPath.row - 1];
    NSString *contentStr = dicM[@"content"];
    if (dicM[@"type"] && self.mChatType == ChatType_Ask) {
        contentStr = [NSString stringWithFormat:@"追问: %@", contentStr];
    }
    NSString *auid = WYISBLANK(dicM[@"auid"]);

    ChartCellFrame *cellFrame = [[ChartCellFrame alloc] init];
    ChartMessage *chartMessage = [[ChartMessage alloc] init];
    chartMessage.dict = dicM;
    chartMessage.icon = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dicM objectForKey:@"head"])];
    chartMessage.content = contentStr;
    chartMessage.time =  N2V(dicM[@"inputtime"], @"");
    
    NSString *image = [dicM objectForKey:@"image"];
    
    if ([auid isEqualToString:[self myUserId]]) {
        chartMessage.messageType = kMessageTo;
    }else
    {
        chartMessage.messageType = kMessageFrom;
    }
    
    chartMessage.contentType = MessageType_Content;
    
    if (image.length > 0) {
        chartMessage.contentType = MessageType_Image;
        chartMessage.imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,image];
    }
    
    cellFrame.chartMessage = chartMessage;
    
    return [cellFrame cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)goOnZhuiWen:(UIButton *)sender
{
    self.mChatType = ChatType_Ask;
    goOnZhuiWen.hidden = YES;
    goOnAnswerView.hidden = NO;
    if (!goOnAnswerView.hidden) {
        [self.view bringSubviewToFront:goOnAnswerView];
    }
    if (!goOnZhuiWen.hidden) {
        [self.view bringSubviewToFront:goOnZhuiWen];
    }
    [self.tableView reloadData];
}
@end
