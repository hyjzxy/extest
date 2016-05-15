//
//  XHTiWenViewController.m
//  HuaYue
// TT
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHTiWenViewController.h"
#import "DropDownListView.h"
#import "TiWenViewCustomer.h"
#import "SBJson.h"
#import "XHWenGaoShouViewController.h"
#import "DDActionSheet.h"
#import "HYTextView.h"
#import "UIProgressView+AFNetworking.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "MZImageView.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "Masonry.h"
#import "SVProgressHUD.h"


@interface XHTiWenViewController ()<UITextViewDelegate, tiwenDelegate, wenGaoShouDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *chooseArray;
    HYTextView *textView;
    UIView *contentView;
    NSString *catId;
    NSString *catText;
    UIView *otherView;
    UILabel *jifenLabel;
    UILabel *scoreLabel;
    MZImageView *picImageView;
    UIButton *rmImgBtn;
    UILabel *gaoShouLabel;
    int totleNum;
    int sReward;
    DropDownListView *dropDownView;
}
@property (nonatomic, strong)UIButton *wengaoshouBtn;
@property (nonatomic, strong)UIButton *picBtn;
@property (nonatomic, strong)UIAlertView *myAlert;
@property (nonatomic, strong) NSArray *superList;
@property (strong, nonatomic) NSString *imageURL;
@end

@implementation XHTiWenViewController
{
    IQKeyboardReturnKeyHandler *returnHandler;
    TiWenViewCustomer *tiwen;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该操作需要先登入，请登入后操作" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    self.title = @"提问";
    catId = @"";
    catText = @"";
    sReward = 0;
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, .9);
    
    
    chooseArray = [[NSMutableArray alloc] init];
    
    contentView =  ViewFromXib(@"TiWenView",2);
    rmImgBtn = (UIButton*)VIEWWITHTAG(contentView, 444);
    [rmImgBtn addTarget:self action:@selector(rmImgAct:) forControlEvents:UIControlEventTouchUpInside];
    rmImgBtn.hidden = YES;
    picImageView = (MZImageView*)VIEWWITHTAG(contentView, 601);
    gaoShouLabel = (UILabel*)VIEWWITHTAG(contentView, 602);
    scoreLabel = (UILabel*)VIEWWITHTAG(contentView, 603);
    textView = (HYTextView*)VIEWWITHTAG(contentView, 605);
    scoreLabel.text = @"";
    [self.view addSubview:contentView];
    WS(ws);
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(50.0f);
        make.left.equalTo(ws.view.mas_left).with.offset(10);
        make.right.equalTo(ws.view.mas_right).with.offset(-10);
    }];
    
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = .5f;
    textView.layer.cornerRadius = .0f;
    
   
    tiwen = (TiWenViewCustomer *)ViewFromXib(@"TiWenView",0);
    tiwen.delegate = self;
    tiwen.confirmBtn.layer.cornerRadius = 4;
    tiwen.confirmBtn.layer.borderWidth  = .5;
    tiwen.confirmBtn.layer.borderColor  = [UIColor blackColor].CGColor;
    self.wengaoshouBtn = (UIButton *)[tiwen viewWithTag:203];
    self.picBtn = (UIButton *)[tiwen viewWithTag:201];
    [self.picBtn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.wengaoshouBtn addTarget:self action:@selector(wengaoshou:) forControlEvents:UIControlEventTouchUpInside];
    CGRectSetY(tiwen, VMaxY(self.view)-110);
    [self.view addSubview:tiwen];
    [self getData];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidDisappear:) name:UIKeyboardDidHideNotification object:nil];
    [self resetScore];
}

- (void)resetScore
{
    [HYHelper mLoginID:^(id uid) {
        if (uid) {
            [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
            [[NetManager sharedManager] myRequestParam:[NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid}] withUrl:GET_INTEGRAL_API withType:GET_INTEGRAL success:^(id responseObject){
                [self updateState:[responseObject[@"integral"]integerValue]];
                [SVProgressHUD dismiss];
            }failure:^(id error){
                [BMUtils showError:error];
            }];
        }
    }];

}

- (void)updateState:(NSInteger)total
{
    tiwen.myJifen.text  = [NSString stringWithFormat:@"我的积分:%zd",total];
    jifenLabel = tiwen.myJifen;
    totleNum =(int)total;
    for (UIView *v in tiwen.subviews) {
        if (v.tag >1000 && [v isKindOfClass:[UIButton class]]) {
            NSInteger tmp = v.tag - 1000;
            ((UIButton*)v).enabled = tmp<=total;
        }
    }
}

-(void)keyboardDidAppear:(NSNotification *)notification
{
    CGRect rect  = [[notification userInfo][UIKeyboardFrameEndUserInfoKey]CGRectValue];
    tiwen.xuanShangisSelected = NO;
    tiwen.keyBoardFrame = [self.view convertRect:rect fromView:nil];
    [tiwen mShowToolBar];
    // 计算TextView 高度
    CGFloat height = VMinY(tiwen) - VMinY(contentView);
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
}

-(void)keyboardDidDisappear:(NSNotification *)notification
{
    tiwen.keyBoardFrame = CGRectZero;
    [tiwen mShowToolBar];
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@173);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.tag = 999;
    rightBarButton.frame = Rect(Main_Screen_Width-65, 10, 60, 25);
    [rightBarButton setBackgroundImage:[UIImage imageNamed:@"bar-btn"] forState:UIControlStateNormal];
    [rightBarButton setTitle:@"提交" forState:UIControlStateNormal];
    rightBarButton.titleLabel.font = SYSTEMFONT(14);
    [rightBarButton addTarget:self action:@selector(rightNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightBarButton];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 998;
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftNavItemClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = Rect(0, 0, 44, 44);
    [self.navigationController.navigationBar addSubview:leftBtn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[self.navigationController.navigationBar viewWithTag:998]removeFromSuperview];
    [[self.navigationController.navigationBar viewWithTag:999]removeFromSuperview];
}

- (void)dealloc
{
    returnHandler = nil;
}

-(void)addSubVIew:(NSArray *)array{
    
    [chooseArray removeAllObjects];
    [chooseArray addObjectsFromArray:array];
    
    dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 40) dataSource:self delegate:self withArray:chooseArray];
    dropDownView.mSuperView = self.view;
    [self.view addSubview:dropDownView];
}

-(void)getData{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"",nil] forKeys: [QUESTIONS_CATA_PARAM componentsSeparatedByString:@","]];
    [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_CATA_API withType:QUESTIONS_CATA success:^(id responseObject){
        [self addSubVIew:responseObject];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}

-(void)rightNavItemClick{
    [self.view endEditing:YES];
    if(![HYHelper mLoginID:nil]){
        [self.myAlert show];
        return ;
    }
    if(textView == nil || textView.text == nil || [textView.text isEqualToString:@""]){
        [BMUtils showError:@"请输入内容"];
        return;
    }
    if([catId isEqualToString:@""]){
        [BMUtils showError:@"请选择分类"];
        return;
    }
    if (picImageView.image==nil) {
        [self mSave:^(id qid){
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
                answerListVC.qid = [qid integerValue];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectWenTI" object:nil userInfo:@{@"TargetVC":answerListVC}];
                }];
            }];
        }];
    }else{
        [SVProgressHUD showWithStatus:@"上传图片中" maskType:SVProgressHUDMaskTypeGradient];
        UIButton *submitBtn = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
        submitBtn.enabled = NO;
        //UIImage *image = [HYHelper imageCompressForSize:picImageView.image  targetSize:CGSizeMake(320, 480)];
        //NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
        NSData *imageData = [HYHelper imageCompressWithImage:picImageView.image];
        NSURL *uploadURL = [NSURL URLWithString:UploadPathAPI];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uploadURL];
        request.HTTPMethod  = @"POST";
        [request setValue:[@(kUploadQuestion)stringValue] forHTTPHeaderField:@"type"];
        [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
        UIProgressView *pv = [[UIProgressView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 5)];
        [self.view addSubview:pv];
        NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                id d = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if (!error && d != nil && [d[@"code"] integerValue] == 88) {
                    self.imageURL = d[@"url"];
                    [self mSave:^(id qid){
                        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                            submitBtn.enabled = YES;
                            [pv removeFromSuperview];
                            MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
                            answerListVC.qid = [qid integerValue];
                            [self dismissViewControllerAnimated:YES completion:^{
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"SelectWenTI" object:nil userInfo:@{@"TargetVC":answerListVC}];
                            }];
                        }];
                    }];
                }else{
                    submitBtn.enabled = YES;
                    [pv removeFromSuperview];
                }
            });
        }];
        [pv setProgressWithUploadProgressOfTask:uploadTask animated:YES];
        [uploadTask resume];
    }
}

- (void)mSave:(void(^)(id qid))block
{
    NSInteger s = textView.text.length;
    if (s>200) {
        [BMUtils showError:@"提问字数不能超过200字"];
        return;
    }
    if (s<10){
        [BMUtils showError:@"提问字数不能少于10个字"];
        return;
    }
    NSMutableDictionary *listTest = [[NSMutableDictionary alloc] initWithObjectsAndKeys:catText,@"1",nil];
    SBJsonWriter *jsonParser = [[SBJsonWriter alloc] init];
    NSString *catString = [jsonParser stringWithObject:listTest];
    int extNum  = totleNum;
    if (scoreLabel.text.length > 0) {
        extNum  = totleNum - sReward;
    }
    NSMutableDictionary *superDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < self.superList.count; i++) {
        NSDictionary *dict = [self.superList objectAtIndex:i];
        [superDict setObject:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]] forKey:[NSString stringWithFormat:@"%d",i+1]];
    }
    NSString *superStr = [superDict.allValues componentsJoinedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjects: @[[self getUserId],catId,textView.text,catString,@(sReward),superStr,N2V(_imageURL, @"")] forKeys:[QUESTIONS_ADD_PARAM componentsSeparatedByString:@","]];
    [SVProgressHUD showWithStatus:@"数据处理中..." maskType:SVProgressHUDMaskTypeGradient];
    [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_ADD_API withType:QUESTIONS_ADD success:^(id responseObject){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wangyu" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactNoti" object:nil];
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:[NSString stringWithFormat:@"%d",extNum] forKey:INTEGRAL];
        self.imageURL = nil;
        rmImgBtn.hidden = YES;
        textView.text = @"";
        [chooseArray removeAllObjects];
        catId = nil;
        catText = nil;
        jifenLabel.text = @"";
        scoreLabel.text = @"";
        gaoShouLabel.text = @"";
        if (block) {
            block(responseObject[@"id"]);
        }
        [SVProgressHUD dismiss];
    }failure:^(id error){
        [SVProgressHUD dismiss];
        [BMUtils showError:error];
    }];
}

#pragma mark -- dropDownListDelegate
-(void) chooseAtSection:(NSInteger)section index:(NSString *)index withText:(NSString *)text
{
    catId = index;
    catText = text;
}

#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [chooseArray count];
}

-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return @"";
}

-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 点击事件
/**
 *  @author 崔俊红, 15-05-05 17:05:33
 *
 *  @brief  删除图片
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)rmImgAct:(id)sender
{
    rmImgBtn.hidden = YES;
    picImageView.image = nil;
    self.imageURL = nil;
}

/**
 *  @author 崔俊红, 15-05-05 17:05:00
 *
 *  @brief  关闭窗口
 *  @since v1.0
 */
-(void)leftNavItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  @author 崔俊红, 15-05-05 17:05:43
 *
 *  @brief  添加高手
 *  @param sender UIButton
 *  @since v1.0
 */
- (void)wengaoshou:(UIButton *)sender{
//    if (totleNum<30) {
//        return [BMUtils showError:@"当前积分不足30分，不能@高手！"];
//    }
    tiwen.keyBoardFrame = CGRectZero;
    tiwen.xuanShangisSelected = NO;
    [tiwen mShowToolBar];
    XHWenGaoShouViewController *control = [[XHWenGaoShouViewController alloc] init];
    control.mydelegate = self;
    control.selectedDics = self.superList;
    [self.navigationController pushViewController:control animated:YES];
}

- (void)xuanShangGO
{
    [self resetScore];
}

/**
 *  @author 崔俊红, 15-05-06 14:05:22
 *
 *  @brief  积分
 *  @param scoreStr
 *  @since v1.0
 */
- (void)didClickedRankWitnScore:(NSString *)scoreStr{
    sReward  = scoreStr.intValue;
    if (sReward - totleNum > 0) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"您当前积分不足"
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    jifenLabel.text  = [NSString stringWithFormat:@"我的积分:%d",(totleNum - sReward)];
    //scoreLabel.text = [NSString stringWithFormat:@"%@分", scoreStr];
    NSString *reward = [NSString stringWithFormat:@"  %@分 ", scoreStr];
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = [UIImage imageNamed:@"answer_M"];
    textAttach.bounds = CGRectMake(2, -1, scoreLabel.font.pointSize, scoreLabel.font.pointSize);
    NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:reward attributes:@{NSFontAttributeName:scoreLabel.font,NSForegroundColorAttributeName:scoreLabel.textColor}];
    [contentAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:1];
     scoreLabel.attributedText = contentAtt;
    scoreLabel.layer.masksToBounds = YES;
    scoreLabel.layer.borderWidth = 1;
    scoreLabel.layer.borderColor = [UIColor colorWithWhite:0.741 alpha:0.290].CGColor;
    scoreLabel.layer.cornerRadius = VHeight(scoreLabel)/2;
}

- (void)didSelectedWithGaoShou:(NSMutableArray *)dArray{
    self.superList = dArray;
    NSString *string = @"";
    for (int i = 0; i < dArray.count; i++) {
        NSDictionary *dic   = dArray[i];
        if (i == dArray.count - 1) {
            string = [string stringByAppendingFormat:@"%@",dic[@"nickname"]];
        } else {
            string = [string stringByAppendingFormat:@"%@,",dic[@"nickname"]];
        }
    }
    if (string.length>0) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:@"邀请" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:gaoShouLabel.font}];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:gaoShouLabel.font,NSForegroundColorAttributeName:gaoShouLabel.textColor}]];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:@"回答" attributes:@{NSFontAttributeName:gaoShouLabel.font,NSForegroundColorAttributeName:[UIColor grayColor]}]];
        gaoShouLabel.attributedText = mAttr;
    }else {
        gaoShouLabel.text = string;
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(NSString *)actionSheetStr
{
    if ([actionSheetStr isEqualToString:@"拍照"]||[actionSheetStr isEqualToString:@"从手机相册选择"]) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        if([actionSheetStr isEqualToString:@"拍照"]){
            type = UIImagePickerControllerSourceTypeCamera;
        }else{
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        if (type == UIImagePickerControllerSourceTypeCamera &&
            ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            [[[UIAlertView alloc] initWithTitle:@"您的设备不支持摄像头"
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"好"
                              otherButtonTitles:nil] show];
        }
        else {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = type;
            imagePicker.allowsEditing = NO;
            if (type == UIImagePickerControllerSourceTypeCamera) {
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.showsCameraControls = YES;
                imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
            }
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self actionSheet:@"拍照"];
    }else if(buttonIndex == 1){
        [self actionSheet:@"从手机相册选择"];
    }
}

- (void)changeHeadImage{
    tiwen.keyBoardFrame = CGRectZero;
    tiwen.xuanShangisSelected = NO;
    [tiwen mShowToolBar];
    if (IS_IOS_7) {
        UIActionSheet *action = [[DDActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        action.delegate = self;
        [action showInView:self.view.window];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"你可以用以下两种方式选择照片" preferredStyle: UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *archiveAction1 = [UIAlertAction actionWithTitle:@"拍照"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             [self actionSheet:@"拍照"];
                                         }];
        
        UIAlertAction *archiveAction2 = [UIAlertAction actionWithTitle:@"从手机相册选择"
                                                                style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action)
                                         {
                                             [self actionSheet:@"从手机相册选择"];
                                         }];        
        [alertController addAction:archiveAction1];
        [alertController addAction:archiveAction2];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    picImageView.image = image;
    rmImgBtn.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
   if ([dropDownView.mLeftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
       [dropDownView.mLeftTableView setSeparatorInset:UIEdgeInsetsZero];
   }
   
   if ([dropDownView.mLeftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
       [dropDownView.mLeftTableView setLayoutMargins:UIEdgeInsetsZero];
   }
    if ([dropDownView.mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [dropDownView.mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([dropDownView.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [dropDownView.mTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
