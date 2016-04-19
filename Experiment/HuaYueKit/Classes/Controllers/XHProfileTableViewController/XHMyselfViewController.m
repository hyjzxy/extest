//
//  XHMyselfViewController.m
//  HuaYue
//
//  Created by lee on 15/1/20.
//
//

#import "XHMyselfViewController.h"
#import "XHNewsTableViewController.h"

#import "UIImageView+WebCache.h"
#import "XHContactTableViewCell.h"
#import "DDActionSheet.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIProgressView+AFNetworking.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "Masonry.h"
#import "NSObject+Cate.h"
#import "MZAnswerChatVC.h"

@interface XHMyselfViewController (){
    int page;
}
@property(nonatomic, assign)int currentBtnIndex;
@property(nonatomic, assign)int ifself;
@property(nonatomic, assign)int uid;
@property(nonatomic, strong)NSDictionary *myinforMationDic;
@property(nonatomic, strong)UIImageView *headImageView;
@end

@implementation XHMyselfViewController
{
    UIButton *btn1;
    UIButton *btn2;
    UIView *selectView1;
    UIView *selectView2;
    NSMutableArray *mDatas1;
    NSMutableArray *mDatas2;
}

- (instancetype)initWithwithUID:(int)uid{
    if (self = [super init]) {
        _uid = uid;
        [HYHelper mLoginID:^(id cuID) {
            if ([cuID intValue]==uid) {
                 _ifself = 1;
            }
        }];
    }
    return self;
}
- (void)loadView{
    [super loadView];
    mDatas1 = [NSMutableArray array];
    mDatas2 = [NSMutableArray array];
    page = 1;
    [self configuraTableViewNormalSeparatorInset];
    [self initData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    //添加上拉加载更多
    __weak XHMyselfViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
         [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
}

-(void)initData{
    self.title = @"个人主页";
    UIView *tableHeadView = [[NSBundle mainBundle] loadNibNamed:@"myselfView" owner:self options:nil][0];
     self.tableView.tableHeaderView = tableHeadView;
    __block id cUid = nil;
    [HYHelper mLoginID:^(id uid) {
        cUid = uid;
    }];
    NSArray *keyValue = [MY_MEMEBERINFO_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[cUid,@(self.uid),_ifself?@1:@2] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_MEMEBERINFO_API
                                      withType:MY_MEMEBERINFO
                                       success:^(id responseObject)
    {
        self.myinforMationDic = [[NSDictionary alloc] initWithDictionary:responseObject];
        UIView *tableHeadView = self.tableView.tableHeaderView;
        btn1 = (UIButton *)[tableHeadView viewWithTag:201];
        UIButton *attentionBtn = (UIButton *)[tableHeadView viewWithTag:309];
        btn2 = (UIButton *)[tableHeadView viewWithTag:202];
        selectView1 = (UIView *)[tableHeadView viewWithTag:2011];
        selectView2 = (UIView *)[tableHeadView viewWithTag:2021];
        [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (_ifself==1) {
            self.title =  @"我的个人主页";
            [btn1 setTitle:@"我的提问" forState:UIControlStateNormal];
            [btn2 setTitle:@"我的回答" forState:UIControlStateNormal];
        }else {
            self.title =  [NSString stringWithFormat:@"%@的个人主页", WYISBLANK(self.myinforMationDic[@"nickname"])];
        }
        btn1.selected = _currentBtnIndex==0;
        btn2.selected = _currentBtnIndex==1;
        self.headImageView = (UIImageView *)[tableHeadView viewWithTag:301];
        self.headImageView.layer.cornerRadius = 22.5f;
        self.headImageView.layer.masksToBounds = YES;
        
        if (self.ifself) {
            attentionBtn.hidden = YES;
            [attentionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(@0);
            }];
            UITapGestureRecognizer *singleaction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImage)];
            singleaction.numberOfTapsRequired = 1;
            self.headImageView.userInteractionEnabled = YES;
            [self.headImageView addGestureRecognizer:singleaction];
            
        }else {
            if ([WYISBLANK(self.myinforMationDic[@"isattention"]) isEqual:@"1"]) {
                attentionBtn.selected = YES;
            }else {
                [attentionBtn addTarget:self action:@selector(attentionAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        //sex
        UIImageView *sexImage   = (UIImageView*)[tableHeadView viewWithTag:665];
        if([WYISBLANK(self.myinforMationDic[@"sex"]) isEqual:@"1"]) {//男
            sexImage.image=[UIImage imageNamed:@"sex_woman.png"];
        } else {
            sexImage.image=[UIImage imageNamed:@"sex_man.png"];
        }
        
        //renzhen
        UIImageView *renzhenImage   = (UIImageView*)[tableHeadView viewWithTag:666];
        [HYHelper mSetVImageView:renzhenImage v:self.myinforMationDic[@"type"] head:nil];
        UILabel *nickLabel = (UILabel *)[tableHeadView viewWithTag:302];
        UILabel *camPanyLabel = (UILabel *)[tableHeadView viewWithTag:303];
        UILabel *attentionLabel = (UILabel *)[tableHeadView viewWithTag:304];
        UILabel *favouriteLabel = (UILabel *)[tableHeadView viewWithTag:305];
        UILabel *qnumLabel = (UILabel *)[tableHeadView viewWithTag:306];
        UILabel *anumLabel = (UILabel *)[tableHeadView viewWithTag:307];
        UILabel *cnumLabel = (UILabel *)[tableHeadView viewWithTag:308];
        camPanyLabel.text   = WYISBLANK(self.myinforMationDic[@"company"]);
        qnumLabel.text = WYISBLANK(self.myinforMationDic[@"qnum"]);
        anumLabel.text = WYISBLANK(self.myinforMationDic[@"anum"]);
        cnumLabel.text = WYISBLANK(self.myinforMationDic[@"cnum"]);
        NSString *fsnum = WYISBLANK(self.myinforMationDic[@"fansnum"]);
        NSString *fensiStr = [NSString stringWithFormat:@"关注 %@ | 粉丝 %@", WYISBLANK(self.myinforMationDic[@"gnum"]),[fsnum  isEqualToString:@""]?@"0":fsnum];
    
        attentionLabel.text = fensiStr;
        favouriteLabel.text = [NSString stringWithFormat:@"%@感兴趣的: %@", _ifself?@"我":@"TA",WYISBLANK(self.myinforMationDic[@"interest"])];
        nickLabel.text = WYISBLANK(self.myinforMationDic[@"nickname"]);
        [_headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([self.myinforMationDic objectForKey:@"head"])]]  placeholderImage:[UIImage imageNamed:@"defaultImg"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         [self.tableView.legendHeader beginRefreshing];
    }failure:^(id error){

    }];

}

- (void)reloadMoreData
{
    if (self.currentBtnIndex == 0) {
        [self reloadtiwenData];
    }else{
        [self reloadhuidaData];
    }
}

-(void)reloadtiwenData{
    __weak XHMyselfViewController *weakMy = self;
    NSArray *keyValue = [MY_QUESTIONSLIST_NEW_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@(self.uid),[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_QUESTIONSLIST_NEW_API withType:MY_QUESTIONSLIST_NEW success:^(id responseObject){
        if (page == 1)[mDatas1 removeAllObjects];
        [mDatas1 addObjectsFromArray:responseObject];
        page ++ ;
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }failure:^(id error){
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }];
}

-(void)reloadhuidaData{
    __weak XHMyselfViewController *weakMy = self;
    NSArray *keyValue = [MY_ANSWERSLIST_NEW_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@(self.uid),[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_ANSWERSLIST_NEW_API withType:MY_ANSWERSLIST_NEW success:^(id responseObject){
        if (page == 1)[mDatas2 removeAllObjects];
        [mDatas2 addObjectsFromArray:responseObject];
        page ++ ;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentBtnIndex = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}


- (void)attentionAction
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    NSArray *keyValue = [MY_ATTENTION_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[userId,[NSString stringWithFormat:@"%d",_uid]] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_ATTENTION_API
                                      withType:MY_ATTENTION
                                       success:^(id responseObject) {
                                           UIView *tableHeadView = self.tableView.tableHeaderView;
                                           UIButton *attentionBtn = (UIButton *)[tableHeadView viewWithTag:309];
                                           attentionBtn.selected = YES;
                                           [BMUtils showSuccess:@"关注成功"];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
}

- (void)btnClick:(UIButton *)sender{
    if (sender == btn1) {
        btn2.selected = NO;
        btn1.selected = YES;
        self.currentBtnIndex = 0;
        selectView1.backgroundColor = UIColorFromRGB(0x00A6F4);
        selectView2.backgroundColor = UIColorFromRGB(0xDBDADA);
    }
    if(sender == btn2){
        btn2.selected = YES;
        btn1.selected = NO;
        self.currentBtnIndex = 1;
        selectView1.backgroundColor = UIColorFromRGB(0xDBDADA);
        selectView2.backgroundColor = UIColorFromRGB(0x00A6F4);
    }
    
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentBtnIndex==0) {
        return mDatas1.count;
    } else if(_currentBtnIndex==1){
        return mDatas2.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentBtnIndex == 0) {
        NSDictionary *dic = _currentBtnIndex==0?mDatas1[indexPath.row]:mDatas2[indexPath.row];
        static NSString *cellIdentifier = @"XHMoreMyFavoritesTableViewController";
        XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell = (XHContactTableViewCell *)(ViewFromXib(@"MyTableViewCell", 4));
        }
        UILabel *titileLabel = (UILabel *)[cell viewWithTag:201];
        UILabel *inviterLabel = (UILabel *)[cell viewWithTag:202];
        NSString *superlist = N2V(dic[@"superlist"], @"");
        inviterLabel.text = @"";
        if (superlist.length>0) {
            inviterLabel.text = [NSString stringWithFormat:@"邀请了%@进行回答",superlist];
        }
        UILabel *bookMark = (UILabel *)[cell viewWithTag:203];
        UIButton *resloveBtn = (UIButton *)[cell viewWithTag:204];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:205];
        timeLabel.text =  N2V(dic[@"inputtime"], @"");
        UILabel *anumLabel = (UILabel *)[cell viewWithTag:206];
        UILabel *name = (UILabel *)[cell viewWithTag:207];
        UILabel *lve = (UILabel *)[cell viewWithTag:208];
        name.text = N2V(dic[@"nickname"], @" ");
        [HYHelper mSetLevelLabel:lve level:N2V(dic[@"rank"], @"")];
        titileLabel.text = dic[@"content"];
        NSString *anumStr = [NSString stringWithFormat:@"%@人回答", dic[@"anum"]];
        anumLabel.text = anumStr;
        resloveBtn.hidden = ![dic[@"issolveed"]boolValue];
        NSString *responseString =dic[@"lable"];
        bookMark.attributedText = [HYHelper mBuildLable:responseString font:bookMark.font];
        return cell;

    }else{
        static NSString *cellIdentifier = @"myanwser";
        XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(!cell){
            cell = (XHContactTableViewCell *)(ViewFromXib(@"MyTableViewCell", 9));
        }
        NSDictionary *dic = _currentBtnIndex==0?mDatas1[indexPath.row]:mDatas2[indexPath.row];
        UILabel *titileLabel = (UILabel *)[cell viewWithTag:201];
        UILabel *timeLabel = (UILabel *)[cell viewWithTag:202];
        UILabel *markLabel = (UILabel *)[cell viewWithTag:203];
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:204];
        UIButton *btn = (UIButton *)[cell viewWithTag:205];
        UIButton *isadopt = (UIButton *)[cell viewWithTag:206];
        titileLabel.text = WYISBLANK(dic[@"title"]);
        timeLabel.text = N2V(dic[@"inputtime"], @"");
        NSString *responseString = dic[@"lable"];
        markLabel.attributedText = [HYHelper mBuildLable:responseString font:markLabel.font];
        __block id uid = nil;
        [HYHelper mLoginID:^(id mid) {uid = mid;}];
        /*if([N2V(dic[@"image"], @"")length]>0){
            UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
            [contentLabel addSubview:logoImg];
            [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(contentLabel);
            }];
        }*/
        contentLabel.attributedText = [HYHelper mBuildAnswerNick:N2V(dic[@"content"], @"") font:contentLabel.font nickname:_ifself==1?@"我":_myinforMationDic[@"nickname"] isAnswer:YES];
        btn.info = dic;
        [btn addTarget:self action:@selector(toChatAct:) forControlEvents:UIControlEventTouchUpInside];
        isadopt.hidden = ![dic[@"isadopt"]boolValue];
        return cell;
    }
}

//切换到互动页面
- (void)toChatAct:(UIButton*)sender
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
    if(!(userId.length>0)){
        [BMUtils showError:@"您还没有登录"];
        return;
    }
    NSDictionary *info = sender.info;
    MZAnswerChatVC *chatVC = [[MZAnswerChatVC alloc]init];
    chatVC.auid = [info[@"auid"]integerValue];
    chatVC.aid = [info[@"id"]integerValue];
    chatVC.qid = [info[@"qid"]integerValue];
    chatVC.nickName = _ifself?@"我":info[@"nickname"];
    chatVC.chatType = kAnswerChat;
    chatVC.isAddQuest = chatVC.chatType ==kAddQuestChat;
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _currentBtnIndex==0?mDatas1[indexPath.row]:mDatas2[indexPath.row];
    /*
    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    newsTableViewController.dic = dic;
    [self.navigationController pushViewController:newsTableViewController animated:YES];*/
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    //TODO:
    if ( self.currentBtnIndex==0) {
         answerListVC.qid = [dic[@"id"]intValue];
    }else {
         answerListVC.qid = [dic[@"qid"]intValue];
    }
    answerListVC.chatFrom = self.currentBtnIndex==0?kChatFromMyQuest:kChatFromPersonPage;
    [self pushNewViewController:answerListVC];
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
            imagePicker.allowsEditing = YES;
            if (type == UIImagePickerControllerSourceTypeCamera) {
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.showsCameraControls = YES;
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
    if (IS_IOS_7) {
        UIActionSheet *action = [[DDActionSheet alloc] initWithTitle:nil
                                                            delegate:(id)self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照",@"从手机相册选择", nil];
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
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    [picker dismissViewControllerAnimated:YES completion:nil];
    //NSData *imageData = UIImagePNGRepresentation([HYHelper imageCompressForSize:image  targetSize:CGSizeMake(120, 120)]);
    NSData *imageData = [HYHelper imageCompressWithImage:image];
    NSURL *uploadURL = [NSURL URLWithString:UploadPathAPI];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uploadURL];
    request.HTTPMethod  = @"POST";
    [request setValue:[@(kUploadMember)stringValue] forHTTPHeaderField:@"type"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    UIProgressView *pv = [[UIProgressView alloc]initWithFrame:Rect(0, 0, VWidth(self.view), 5)];
    [self.view addSubview:pv];
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            id d = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (d != nil && [d[@"code"] integerValue] == 88) {
                NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UID];
                NSString *imageURL = [d objectForKey:@"url"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:@[userId,imageURL] forKeys:@[@"uid",@"head"]];
                [[NetManager sharedManager] myRequestParam:dict
                                                   withUrl:MY_Change_API
                                                  withType:MY_Change
                                                   success:^(id responseObject) {
                                                       self.headImageView.image = image;
                                                       [BMUtils showSuccess:@"上传成功"];
                                                   } failure:^(id errorString) {
                                                       [BMUtils showError:errorString];
                                                   }];
            }
            [pv removeFromSuperview];
        });
    }];
    [pv setProgressWithUploadProgressOfTask:uploadTask animated:YES];
    [uploadTask resume];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
