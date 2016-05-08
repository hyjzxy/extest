//
//  XHContactTableViewController.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHContactTableViewController.h"
#import "XHMyselfViewController.h"
#import "XHStoreManager.h"
#import "XHContactTableViewCell.h"
#import "XHFoundationCommon.h"
#import "XHNewsTableViewController.h"
#import "UIButton+WebCache.h"
#import "SBJsonParser.h"
#import "selectCollectionCell.h"
#import "MZAnswerListVC.h"
#import "HYHelper.h"
#import "UIView+Cate.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, DNDType){
    kFsHelp = 1,kNetQuest,kSearchQuest
};
@interface XHContactTableViewController ()<loginBtnGotoLoginDelegate,HKSegViewDelegete>
{
    UIImageView *buttonBg;
//    UIButton *leftBtn;
//    UIButton *rightBtn;
//    UIView *bottnSelectd0;
//    UIView *bottnSelectd1;
    UIButton *back;
    int page;
}
@property (nonatomic, strong) NSMutableArray    *typeArray;
@property (nonatomic, strong) NSMutableArray    *sonArray;
@property (nonatomic,strong) UICollectionView   *collectionView;
@property (nonatomic,strong) UIButton           *goldButton;
@property (nonatomic,strong) UIButton           *solveButton;
@property (nonatomic, assign) DNDType dndType;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic,strong) UIView* topView;
@property (nonatomic,strong) HKSelectView* selectView;
@end

@implementation XHContactTableViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.title = @"全部问题";
//    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftAction)];
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:_topView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"ContactNoti" object:nil];
//    self.tabBarController.title = @"全部问题";
    [self requestTypeList:@""];
    page = 1;
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.dndType = kNetQuest;
    
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:_topView];
//    self.tabBarController.title = @"";
    NSArray* segTitle = [NSArray arrayWithObjects:@"网友提问",@"粉丝求助", nil];
    HKSegView* segView = [[HKSegView alloc]initWithFrame:CGRectMake(65, 5, 170, 25)];
    segView.titleArray = segTitle;
    segView.delegate = self;
    [_topView addSubview:segView];
    
    NSArray* selectArray = [NSArray arrayWithObjects:@"问题状态",@"选择分类",@"选择子类", nil];
    _selectView = [[HKSelectView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    _selectView.titleArray = selectArray;
    [self.view addSubview:_selectView];
//    [_selectView.detailArray insertObject:self.typeArray atIndex:0];
    
    CGRect frame = self.tableView.frame;
    frame.origin.y = 50;
    frame.size.height = frame.size.height - 50;
    
    self.tableView.frame = frame;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //添加上拉加载更多
    __weak XHContactTableViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        if(blockSelf.dndType == kNetQuest){
            if (blockSelf.isSearch) {
                [blockSelf reloadShaiXuanData];
            }else{
                [blockSelf requestDataArticle];
            }
        }else{
            [blockSelf requestDataComment];
        }
    }];
    WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        page = 1;
        ws.isSearch = NO;
//        ws.tabBarController.title = @"全部问题";
        ws.goldButton.selected = NO;
        ws.solveButton.selected = NO;
        [ws.typeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            obj[@"bSelect"] = @(NO);
        }];
        [ws.sonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            obj[@"bSelect"] = @(NO);
        }];
        [ws.collectionView reloadData];
        [blockSelf reloadData];
    }];
    UICollectionViewFlowLayout  *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing   = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize  = CGSizeMake(320, 30);
    
    
    UIView  *backContentView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, self.view.bounds.size.height)];
    [backContentView setBackgroundColor:[UIColor whiteColor]];
    UIView  *topSelectView= ViewFromXib(@"MyTableViewCell", 16);
    [backContentView addSubview:topSelectView];
    
    self.goldButton     = (UIButton*)[topSelectView viewWithTag:666];
    self.solveButton    = (UIButton*)[topSelectView viewWithTag:555];
    [self.goldButton addTarget:self action:@selector(topSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.solveButton addTarget:self action:@selector(topSelectClick:) forControlEvents:UIControlEventTouchUpInside];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topSelectView.frame.size.height, 280, VHeight(self.view)-VMaxY(topSelectView) - 250.0f) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[selectCollectionCell class]
            forCellWithReuseIdentifier:@"selectCollectionCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionOne"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionTwo"];
    self.collectionView.delegate    = (id)self;
    self.collectionView.dataSource  = (id)self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [backContentView addSubview:self.collectionView];

    UIView  *line   = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), 280, .5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [backContentView addSubview:line];
    
    UIButton *commitBtn  = [[UIButton alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(line.frame)+20, 100, 40)];
    [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"dengNIDaOk"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    [backContentView addSubview:commitBtn];
    
    CGRect tableViewFrame = self.view.bounds;
    
    back = [[UIButton alloc] initWithFrame:tableViewFrame];
    back.backgroundColor = RGBACOLOR(100, 100, 100, .7);
    [back addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:backContentView];
    [self.tabBarController.view addSubview:back];
    [self.tabBarController.view bringSubviewToFront:back];
    back.alpha = 0;
    [self.tableView.legendHeader beginRefreshing];
    
}

- (void)segViewSelectIndex:(NSInteger)index SegView:(HKSegView *)segView
{
    if (index == 0 ){
        [self leftBtnClick:nil];
    }else{
        [self rightBtnClick:nil];
    }
}

- (void)topSelectClick:(UIButton*)btn
{
    btn.selected    = !btn.selected;
}

- (void)reloadData
{
    if(self.dndType == kNetQuest){
        if (_isSearch) {
            [self reloadShaiXuanData];
        }else{
           [self requestDataArticle];
        }
    }else if(self.dndType == kFsHelp){
        [self requestDataComment];
    }
}

-(void)closeView:(id)s{
    self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    back.alpha = 0;
}

-(void)clickedLeftAction{
    if(back.alpha == 0){
        self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        back.alpha = 1;
    }else{
        self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        back.alpha = 0;
    }
}

-(void)clickedBarButtonItemAction{
    
}

-(void)leftBtnClick:(id)sender
{
//    leftBtn.selected = YES;
//    rightBtn.selected = !leftBtn.selected;
//    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
//    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    page = 1;
    self.dndType = kNetQuest;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self requestDataArticle];
    
}
-(void)rightBtnClick:(id)sender
{
    if(![HYHelper mLoginID:nil]){
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"登录后才能查看"
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil, nil] show];
        
        return;
    }
//    rightBtn.selected = YES;
//    leftBtn.selected = !rightBtn.selected;
//    bottnSelectd0.backgroundColor = UIColorFromRGB(0xDBDADA);
//    bottnSelectd1.backgroundColor = UIColorFromRGB(0x00A6F4);
    page = 1;
    self.dndType = kFsHelp;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self requestDataComment];
}

-(void)requestDataArticle{
    if (![NetManager isNetAlive]) {
        NSString *filePath = NSDocFilePath(kQuestionFileName);
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
            [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:[[NSArray alloc]initWithContentsOfFile:filePath]];
            [self.tableView reloadData];
        }
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
    }else{
        NSArray *keyValue = [QUESTIONS_LIST_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_LIST_API withType:QUESTIONS_LIST success:^(id responseObject){
            if (self.dndType != kNetQuest) return;
            if (page == 1) [self.dataSource removeAllObjects];
            [self.dataSource addObjectsFromArray:responseObject];
            page++;
            [self.tableView reloadData];
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
            [[NSBlockOperation blockOperationWithBlock:^{
                [self.dataSource writeToFile:NSDocFilePath(kQuestionFileName) atomically:YES];
            }]start];
        }failure:^(id error){
            [self.tableView.legendHeader endRefreshing];
            [self.tableView.legendFooter endRefreshing];
        }];
    }
}

-(void)requestDataComment
{
    __weak XHContactTableViewController *weakMy = self;
    if(![HYHelper mLoginID:nil]) {
         [weakMy.dataSource removeAllObjects];
        [weakMy.tableView reloadData];
        return;
    }
    
    
    NSArray *keyValue = [MY_FANSSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_FANSSLIST_API withType:MY_FANSSLIST success:^(id responseObject){
        if (self.dndType != kFsHelp) return;
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
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }];
}


//请求筛选数据
- (void)reloadShaiXuanData
{
    //如果是粉丝就放弃
    if (self.dndType != kNetQuest) return;
    NSString *catId  = @"";
    NSMutableString *titleStr = [NSMutableString string];
    if (![[[self.typeArray firstObject] objectForKey:@"bSelect"] boolValue]) {//未选择全部
        for (int i = 0; i < self.typeArray.count; i++) {
            NSDictionary *dic   = [self.typeArray objectAtIndex:i];
            if ([dic[@"bSelect"] boolValue]) {
                catId   = [catId stringByAppendingFormat:@"%@,",dic[@"id"]];
                [titleStr appendString:dic[@"catname"]];
            }
        }
        if (self.sonArray.count > 0) {
            for (int i = 0; i < self.sonArray.count; i++) {
                NSDictionary *dic   = [self.sonArray objectAtIndex:i];
                if ([dic[@"bSelect"] boolValue]) {
                    catId   = [catId stringByAppendingFormat:@"%@,",dic[@"id"]];
                    [titleStr appendString:dic[@"catname"]];
                }
            }
        }
        if ([catId hasSuffix:@","]) {
            catId   = [catId substringToIndex:catId.length - 1];
        }
    }
//    self.tabBarController.title = titleStr.length==0?@"全部问题":titleStr;
    int isreward = self.goldButton.selected;
    int issolveed = self.solveButton.selected;
    self.isSearch = !(catId.length<=0 && ! self.goldButton.selected && !self.solveButton.selected);
    if (_isSearch) {
        NSArray *keyValue = [QUESTIONS_SELECT_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(page),@20,catId,@(isreward),@(issolveed),@(self.dndType)] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:QUESTIONS_SELECT_API
                                          withType:QUESTIONS_SELECT
                                           success:^(id responseObject){
                                               if (page == 1) [self.dataSource removeAllObjects];
                                               [self.dataSource addObjectsFromArray:responseObject];
                                               page++;
                                               [self.tableView reloadData];
                                               [self.tableView.legendHeader endRefreshing];
                                               [self.tableView.legendFooter endRefreshing];
                                           }failure:^(id error){
                                               [self.tableView reloadData];
                                               [self.tableView.legendHeader endRefreshing];
                                               [self.tableView.legendFooter endRefreshing];
                                           }];
    }else{
        [self.tableView.legendHeader beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gointoInformationWith:(XHMyButton *)sender Index:(int)index{
    [HYHelper pushPersonCenterOnVC:self uid:[self.dataSource[sender.arrayIndex][@"uid"] intValue]];
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"contactTableViewCellIdentifier";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = (XHContactTableViewCell *)ViewFromXib(@"MyTableViewCell", 0);
        cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xFBF8DD);
    }
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    [cell.headBtn addTarget:self action:@selector(gointoInformationWith:Index:) forControlEvents:UIControlEventTouchUpInside];
    cell.headBtn.arrayIndex = indexPath.row;
    [HYHelper mSetLevelLabel:cell.level level:dic[@"rank"]];
    cell.userName.text = WYISBLANK([dic objectForKey:@"nickname"]);
    cell.time.text = N2V(dic[@"inputtime"], @"");
    cell.tipImageView.hidden = YES;
    if (!isEmptyDicForKey(dic, @"reward")) {
        UIFont *font  = cell.reward.font;
        NSString *reward = [NSString stringWithFormat:@"  %@分 ",WYISBLANK([dic objectForKey:@"reward"]) ];
        NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
        textAttach.image = [UIImage imageNamed:@"answer_M"];
        textAttach.bounds = CGRectMake(2, -1, font.pointSize, font.pointSize);
        NSMutableAttributedString *contentAtt = [[NSMutableAttributedString alloc]initWithString:reward attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:cell.reward.textColor}];
        [contentAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:textAttach] atIndex:1];
        cell.reward.attributedText = contentAtt;
    }else{
         cell.reward.text = @"";
    }
    // 崔俊红 2015.03.31
    cell.logImg.hidden = !([N2V(dic[@"image"],@"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0);
    cell.checkBtn.hidden = [WYISBLANK([dic objectForKey:@"issolveed"]) isEqualToString:@"0"];
    NSInteger isTop =  [dic[@"istop"]integerValue];
    if (isTop>=1 && isTop<=3) {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:@[@"【置顶】",@"【活动】",@"【公告】"][isTop-1] attributes:@{NSFontAttributeName:cell.content.font,NSForegroundColorAttributeName:[UIColor redColor]}];
        [mAttr appendAttributedString:[[NSAttributedString alloc]initWithString:WYISBLANK([dic objectForKey:@"content"])  attributes:@{NSFontAttributeName:cell.content.font,NSForegroundColorAttributeName:UIColorFromRGB(0x666666)}]];
        cell.content.attributedText = mAttr;
        cell.content.superview.backgroundColor = UIColorFromRGB(0xFEFBE8);
    }else{
        cell.content.textColor = UIColorFromRGB(0x666666);
        cell.content.superview.backgroundColor = [UIColor whiteColor];
        cell.content.text = WYISBLANK([dic objectForKey:@"content"]);
    }
    cell.reward.layer.masksToBounds = YES;
    cell.reward.layer.borderWidth = 1;
    cell.reward.layer.borderColor = [UIColor colorWithWhite:0.741 alpha:0.290].CGColor;
    cell.reward.layer.cornerRadius = VHeight(cell.reward)/2;
    if (self.dndType != kNetQuest) {//粉丝求助
        if ([dic[@"isanswer"]boolValue]) {
            [cell.huidaIMG setImage:[UIImage imageNamed:@"huida"]];
        }else {
            [cell.huidaIMG setImage:[UIImage imageNamed:@"unhuida"]];
        }
    }else {
        [cell.huidaIMG setImage:nil];
    }
    NSString* label = WYISBLANK([dic objectForKey:@"lable"]);
    cell.label.text = [label stringByReplacingOccurrencesOfString:@" " withString:@"/"];
    id superlist  = dic[@"superlist"];
    cell.gaoShou.text = [superlist isEqualToString:@"null"]||!superlist||[superlist length]<=0?@"":[NSString stringWithFormat:@"邀请%@回答",superlist];
    [HYHelper mSetVImageView:cell.head v:dic[@"type"] head:cell.headBtn];
    cell.count.text = [NSString stringWithFormat:@"%@人回答",WYISBLANK([dic objectForKey:@"anum"])];
    
    // 布局 LogImg reward checkbtn
    if(cell.checkBtn.hidden){
        [cell.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@1);
        }];
    }else{
        [cell.checkBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@46);
        }];
    }
    cell.profileLabel.text = N2V(dic[@"company"], @"");
    if ([N2V(dic[@"image"], @"")length]>0) {
        /*[cell.qImgeView sd_setImageWithURL:IMG_URL(dic[@"img"]) placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        [cell.qImgeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@65);
        }];*/
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
#pragma mark - UITableView Delegate

- (void)enterNewsController {
    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    [self pushNewViewController:newsTableViewController];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    answerListVC.qid = [dic[@"id"]integerValue];
    answerListVC.chatFrom = kChatFromWaitAnswer;
    [self pushNewViewController:answerListVC];
}

- (void)gotoLogin{
    if(![HYHelper mLoginID:nil]){
        self.tabBarController.selectedIndex = 3;
    }
}

#pragma mark - 复选框
//点确定
- (void)commitClick
{
    page = 1;
    [self reloadShaiXuanData];
    [self clickedLeftAction];
}

//请求筛选栏目列表
- (void)requestTypeList:(NSString*)typeId
{
    if ([typeId isEqualToString:@"-1"]) {
        [self.sonArray removeAllObjects];
        [self.collectionView reloadData];
        return;
    }
    __weak XHContactTableViewController *weakMy = self;
    NSArray *keyValue = [QUESTIONS_CATA_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:typeId,nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:QUESTIONS_CATA_API
                                      withType:QUESTIONS_CATA
                                       success:^(id responseObject){
                                           NSMutableArray  *array  = [self convertData:responseObject];
                                           if (typeId.length <= 0) {
                                               NSMutableDictionary  *dic    = [[NSMutableDictionary alloc] init];
                                               [dic setObject:@"全部" forKey:@"catname"];
                                               [dic setObject:@"-1" forKey:@"id"];
                                               [dic setObject:@"0" forKey:@"bSelect"];
                                               [array insertObject:dic atIndex:0];
                                               
                                               [weakMy.typeArray removeAllObjects];
                                               weakMy.typeArray = array;
                                               weakMy.selectView.classifyArray = weakMy.typeArray;
                                           }else {
                                               [weakMy.sonArray removeAllObjects];
                                               weakMy.sonArray  = array;
                                               weakMy.selectView.sonArray = weakMy.sonArray;
                                           }
                                           [self.collectionView reloadData];
                                       }failure:^(id error){
                                           if (typeId.length <= 0) {
                                               [weakMy.typeArray removeAllObjects];
                                           }else {
                                               [weakMy.sonArray removeAllObjects];
                                           }
                                           [self.collectionView reloadData];
                                       }];
}

- (NSMutableArray *)convertData:(NSArray*)array
{
    NSMutableArray  *list   = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *mDic   = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
        [mDic setObject:@"0" forKey:@"bSelect"];
        [list addObject:mDic];
    }
    
    return list;
}

//单选
- (void)reSetDataSourceForOne:(NSDictionary*)dic indexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *newDict   = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([newDict[@"bSelect"] boolValue]) {
        [newDict setObject:@"0" forKey:@"bSelect"];
    }else {
        [newDict setObject:@"1" forKey:@"bSelect"];
        for (int i = 0; i < self.typeArray.count; i++) {
            NSMutableDictionary *oldDict    = [NSMutableDictionary dictionaryWithDictionary:[self.typeArray objectAtIndex:i]];
            if (![newDict[@"id"] isEqualToString:oldDict[@"id"]]) {
                [oldDict setObject:@"0" forKey:@"bSelect"];
                [self.typeArray replaceObjectAtIndex:i withObject:oldDict];
            }
        }
    }
    [self.typeArray replaceObjectAtIndex:indexPath.row withObject:newDict];
}

//复选
- (void)reSetDataSourceForTwo:(NSDictionary*)dic indexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *newDict   = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([newDict[@"bSelect"] boolValue]) {
        [newDict setObject:@"0" forKey:@"bSelect"];
    }else {
        [newDict setObject:@"1" forKey:@"bSelect"];
    }
    [self.sonArray replaceObjectAtIndex:indexPath.row withObject:newDict];
    
    [self.collectionView reloadData];
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section?self.sonArray.count:self.typeArray.count;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 30);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        NSDictionary    *dic    = [self.sonArray objectAtIndex:indexPath.row];

        [self reSetDataSourceForTwo:dic indexPath:indexPath];
    }else {
        NSDictionary    *dic    = [self.typeArray objectAtIndex:indexPath.row];

        [self reSetDataSourceForOne:dic indexPath:indexPath];
        
        [self requestTypeList:dic[@"id"]];
    }
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"selectCollectionCell";
    selectCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *dataSource = indexPath.section?self.sonArray:self.typeArray;
    NSDictionary    *dic    = [dataSource objectAtIndex:indexPath.row];
    
    cell.titleLabel.text    = [dic objectForKey:@"catname"];
    
    if ([dic[@"bSelect"] boolValue]) {
        cell.titleLabel.textColor   =  RGBCOLOR(17, 198, 236);
    }else {
        cell.titleLabel.textColor   =  [UIColor darkGrayColor];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString    *reuseIdentifier    = indexPath.section?@"sectionOne":@"sectionTwo";
    UICollectionReusableView    *reusableView   = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        reusableView    = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:reuseIdentifier
                                                                    forIndexPath:indexPath];
        UILabel *sectionTitle   = (UILabel*)[reusableView viewWithTag:1314];
        if (sectionTitle == nil) {
            sectionTitle   = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            sectionTitle.textColor  = [UIColor whiteColor];
            sectionTitle.font = [UIFont systemFontOfSize:14.0f];
            [reusableView addSubview:sectionTitle];
        }
        sectionTitle.text   = indexPath.section?@"选择子类":@"选择分类";
        reusableView.backgroundColor = UIColorFromRGB(0x55C3E8);
    }
    return reusableView;
}

@end
