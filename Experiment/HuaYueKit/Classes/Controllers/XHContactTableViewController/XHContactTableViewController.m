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
@interface XHContactTableViewController ()<loginBtnGotoLoginDelegate,HKSegViewDelegete,HKSelectViewDelegate>
{
    UIImageView *buttonBg;
    UIButton *back;
    int page;
    
}
@property (nonatomic, strong) NSMutableArray    *typeArray;
@property (nonatomic, strong) NSMutableArray    *sonArray;
@property (nonatomic, assign) DNDType dndType;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic,strong) UIView* topView;
@property (nonatomic,strong) HKSelectView* selectView;
@property (nonatomic,strong) HKSegView* segView;
@property (nonatomic,strong) NSNumber* status;
@property(nonatomic,strong) NSMutableArray* topArray;
@end

@implementation XHContactTableViewController

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:_topView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _status = @1;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"ContactNoti" object:nil];
    [self requestTypeList:@""];
    page = 1;
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-32, 44)];
//    _topView.backgroundColor = [UIColor redColor];
    self.dndType = kNetQuest;
    
    self.tabBarController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:_topView];
//    self.tabBarController.title = @"";
    NSArray* segTitle = [NSArray arrayWithObjects:@"网友提问",@"粉丝求助", nil];
    HKSegView* segView = [[HKSegView alloc]initWithFrame:CGRectMake(54, 7, 170, 23)];
    segView.center = CGPointMake(_topView.width/2.0, segView.center.y);
    segView.tag = 10001;
    segView.titleArray = segTitle;
    segView.delegate = self;
    segView.lineView.hidden = YES;
    [_topView addSubview:segView];
    
    NSArray* selectArray = [NSArray arrayWithObjects:@"问题状态",@"选择分类",@"选择子类", nil];
    _selectView = [[HKSelectView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    _selectView.titleArray = selectArray;
//    [self.view addSubview:_selectView];
    self.tableView.tableHeaderView = _selectView;
    _selectView.delegate = self;
    
    NSString *uidS = [NSString stringWithFormat:@"%@topArray", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:uidS] != nil){
        _topArray = [[NSMutableArray alloc]initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:uidS]];
    }else{
        _topArray = [NSMutableArray arrayWithObjects:@{@"bSelect":@"0",@"catname":@"悬赏",@"id":@"0"},@{@"bSelect":@"0",@"catname":@"未解决",@"id":@"0"}, nil];
    }
    
    _selectView.stateArray = _topArray;
    
    NSArray* segArrray = [NSArray arrayWithObjects:@"全部",@"未回答",@"已回答", nil];
    _segView = [[HKSegView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    _segView.tag = 10002;
    _segView.titleArray = segArrray;
    _segView.normalBackgroundColor = [UIColor whiteColor];
    _segView.normalColor = [UIColor blackColor];
    _segView.selectColor = [UIColor blackColor];
    _segView.delegate = self;
//    [self.view addSubview:_segView];
    _segView.hidden = YES;
    UIView* sepLine = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/3.0-0.5, 10, 0.5, _segView.height-20)];
    [_segView addSubview:sepLine];
    sepLine.backgroundColor = [UIColor grayColor];
    UIView* sepLine2 = [[UIView alloc]initWithFrame:CGRectMake(2*self.view.width/3.0-0.5, 10, 0.5, _segView.height-20)];
    [_segView addSubview:sepLine2];
    sepLine2.backgroundColor = [UIColor grayColor];
    
//    CGRect frame = self.tableView.frame;
//    frame.origin.y = 40;
//    frame.size.height = frame.size.height - 40;
//    
//    self.tableView.frame = frame;
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
//        ws.isSearch = NO;
        [ws.typeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            obj[@"bSelect"] = @(NO);
        }];
        if (ws.sonArray.count > 0){
            [ws.sonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                obj[@"bSelect"] = @"0";
            }];
        }
        
        [blockSelf reloadData];
    }];
    [self.tabBarController.view addSubview:back];
    [self.tabBarController.view bringSubviewToFront:back];
    back.alpha = 0;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:UID]!=nil){
//        
//    }else{
//        [self reloadData];
//    }
//    [HYHelper mLoginID:^(id uid) {
//        if (uid){
//            NSLog(@"%@",uid);
//        }else{
//            [self reloadData];
//        }
//    }];
}

- (void)setIsSearch:(BOOL)isSearch{
    _isSearch = isSearch;
    NSString *uidS = [NSString stringWithFormat:@"%@ContactIsSearch",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];

    [[NSUserDefaults standardUserDefaults]setBool:isSearch forKey:uidS];
}

- (void)segViewSelectIndex:(NSInteger)index SegView:(HKSegView *)segView
{
    if (segView.tag == 10001) {
        [self.selectView dismiss];
        if (index == 0 ){
            self.tableView.tableHeaderView = self.selectView;
            [self leftBtnClick:nil];
        }else{
            self.tableView.tableHeaderView = self.segView;
            [self rightBtnClick:nil];
        }
    }else if (segView.tag == 10002) {
        if (index == 0) {
            self.status = @1;
        } else if (index == 1) {
            self.status = @3;
        } else if (index == 2) {
            self.status = @2;
        }
        [self rightBtnClick:nil];
    }
    
}

- (void)selectView:(HKSelectView*)selectView selectIndex:(NSInteger)index subindex:(NSInteger)subindex{
    if (index == 1) {
        NSMutableString *titleStr = [NSMutableString string];
        for (int i = 0; i < self.typeArray.count; i++) {
            NSDictionary *dic   = [self.typeArray objectAtIndex:i];
            if ([dic[@"bSelect"] boolValue]) {
                [titleStr appendString:dic[@"catname"]];
                [titleStr appendString:@"/"];
            }
        }
        
        if (titleStr.length > 0){
            [titleStr deleteCharactersInRange:NSMakeRange(titleStr.length-1, 1)];
            [self.selectView setButtonTitle:titleStr index:index];
        }
        NSString *uidS = [NSString stringWithFormat:@"%@Index", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        NSString* sub = [NSString stringWithFormat:@"%ld",(long)subindex];
        [[NSUserDefaults standardUserDefaults]setObject:sub forKey:uidS];
        if(subindex == 0 ){
            self.selectView.sonArray = [NSArray new];
            [self.selectView setButtonTitle:@"全部" index:2];
            page = 1;
            [self.tableView.legendHeader beginRefreshing];
        }else{
            NSDictionary* newDic = [self.typeArray objectAtIndex:subindex];
            [self requestTypeList:newDic[@"id"]];
        }
        
    }
}

- (void)selectView:(HKSelectView *)selectView selectIndex:(NSInteger)index subArray:(NSArray *)subArray{
    BOOL isSelect = NO;
    NSMutableString *titleStr = [NSMutableString string];
    for (int i = 0; i < subArray.count; i++) {
        NSDictionary *dic   = [subArray objectAtIndex:i];
        if ([dic[@"bSelect"] boolValue]) {
            [titleStr appendString:dic[@"catname"]];
            [titleStr appendString:@"/"];
            if (index == 2 ){
                isSelect = YES;
            }
        }
    }
    if (titleStr.length > 0){
        [titleStr deleteCharactersInRange:NSMakeRange(titleStr.length-1, 1)];
        [self.selectView setButtonTitle:titleStr index:index];
    }else{
        if (index == 0) {
            [self.selectView setButtonTitle:@"问题状态" index:index];
        }
    }
    if (index == 0){
        NSString *uidS = [NSString stringWithFormat:@"%@topArray", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        
        [[NSUserDefaults standardUserDefaults] setObject:subArray forKey:uidS];
        self.topArray = [[NSMutableArray alloc]initWithArray: subArray];
        self.selectView.stateArray = self.topArray;

    }else if (index == 2){
        if (isSelect == NO){
            [BMUtils showError:@"您未选择子类"];
            return;
        }
        NSString *uidS = [NSString stringWithFormat:@"%@Index",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
            NSString* sub = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
            NSString* sonA = [NSString stringWithFormat:@"%@%@",uidS,sub];
            [[NSUserDefaults standardUserDefaults]setObject:subArray forKey:sonA];
        }
        [self.sonArray removeAllObjects];
        [self.sonArray addObjectsFromArray:subArray];
    
    }
    page = 1;
    self.isSearch = YES;
    [self.tableView.legendHeader beginRefreshing];
}


- (void)reloadData
{
    page = 1;
    if(self.dndType == kNetQuest){
         NSString *uidS = [NSString stringWithFormat:@"%@ContactIsSearch",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
        self.isSearch = [[NSUserDefaults standardUserDefaults]boolForKey:uidS];
        if (_isSearch && [[NSUserDefaults standardUserDefaults] objectForKey:UID] != nil) {
            //悬赏
            NSString *uidS1 = [NSString stringWithFormat:@"%@topArray", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:uidS] != nil){
                _topArray = [[NSMutableArray alloc]initWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:uidS1]];
            }
            NSLog(@"topArray:%@",_topArray);
            self.selectView.stateArray = _topArray;
            NSMutableString *titleStr0 = [NSMutableString string];
            for (int i = 0; i < self.topArray.count; i++) {
                NSDictionary *dic   = [self.topArray objectAtIndex:i];
                if ([dic[@"bSelect"] boolValue]) {
                    [titleStr0 appendString:dic[@"catname"]];
                    [titleStr0 appendString:@"/"];
                }
            }
            
            if (titleStr0.length > 0){
                [titleStr0 deleteCharactersInRange:NSMakeRange(titleStr0.length-1, 1)];
                [self.selectView setButtonTitle:titleStr0 index:0];
            }else{
                [self.selectView setButtonTitle:@"问题状态" index:0];
            }
            //选择分类
            NSString *uidS = [NSString stringWithFormat:@"%@Index",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
            if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
                NSString* sub = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
                NSInteger index = sub.integerValue;
                self.typeArray[index][@"bSelect"] =  @"1";
                NSString* title = self.typeArray[index][@"catname"];
                if (title.length > 0){
                    [self.selectView setButtonTitle:title index:1];
                    //子类
                    NSString *uidS = [NSString stringWithFormat:@"%@Index",  [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:uidS]!=nil){
                        NSString* sub = [[NSUserDefaults standardUserDefaults]objectForKey:uidS];
                        NSString* sonA = [NSString stringWithFormat:@"%@%@",uidS,sub];
                        if ([[NSUserDefaults standardUserDefaults]objectForKey:sonA]!=nil){
                            NSArray* son = [[NSUserDefaults standardUserDefaults]objectForKey:sonA];
                            self.sonArray = [[NSMutableArray alloc]initWithArray:son];
                            self.selectView.sonArray = self.sonArray;
                            
                            NSMutableString *titleStr = [NSMutableString string];
                            for (int i = 0; i < self.sonArray.count; i++) {
                                NSDictionary *dic   = [self.sonArray objectAtIndex:i];
                                if ([dic[@"bSelect"] boolValue]) {
                                    [titleStr appendString:dic[@"catname"]];
                                    [titleStr appendString:@"/"];
                                }
                            }
                            
                            if (titleStr.length > 0){
                                [titleStr deleteCharactersInRange:NSMakeRange(titleStr.length-1, 1)];
                                [self.selectView setButtonTitle:titleStr index:2];
                            }else{
                                [self.selectView setButtonTitle:@"选择子类" index:2];
                            }
                        }
                    }
                }else{
                    [self.selectView setButtonTitle:@"选择分类" index:1];
                }
            }
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

//-(void)clickedLeftAction{
//    if(back.alpha == 0){
//        self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//        back.alpha = 1;
//    }else{
//        self.tabBarController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//        back.alpha = 0;
//    }
//}

//-(void)clickedBarButtonItemAction{
//    
//}

-(void)leftBtnClick:(id)sender
{
    self.selectView.hidden = NO;
    self.segView.hidden = YES;
    page = 1;
    self.dndType = kNetQuest;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [self reloadData];
    
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
    self.segView.hidden = NO;
    self.selectView.hidden = YES;
    page = 1;
    self.dndType = kFsHelp;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
//    [self requestDataComment];
    [self reloadData];

}
//网友提问
-(void)requestDataArticle{
    NSString *uidS = [NSString stringWithFormat:@"%@topArray", [[NSUserDefaults standardUserDefaults] objectForKey:UID]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:uidS] != nil){
        _topArray = [[NSUserDefaults standardUserDefaults] objectForKey:uidS];
    }else{
        _topArray = [NSMutableArray arrayWithObjects:@{@"bSelect":@"0",@"catname":@"悬赏",@"id":@"-1"},@{@"bSelect":@"0",@"catname":@"未解决",@"id":@"0"}, nil];
    }
    
    _selectView.stateArray = _topArray;
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
            NSLog(@"ssssssss %@",responseObject);
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

//粉丝求助接口
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
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],_status,nil] forKeys:keyValue];
//    NSLog(@"粉丝求助：%@",dic);
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
        [BMUtils showError:error];
        [weakMy.dataSource removeAllObjects];
        [weakMy.tableView reloadData];
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
    if(self.topArray.count <= 0 || self.topArray == nil){
        _topArray = [NSMutableArray arrayWithObjects:@{@"bSelect":@"0",@"catname":@"悬赏",@"id":@"0"},@{@"bSelect":@"0",@"catname":@"未解决",@"id":@"0"}, nil];
        self.selectView.stateArray = _topArray;
    }
    NSString* ward = self.topArray[0][@"bSelect"];
    NSInteger isreward = ward.integerValue;
    NSString* solveed = self.topArray[1][@"bSelect"];
    NSInteger issolveed = solveed.integerValue;
    self.isSearch = (catId.length > 0 || isreward > 0 || issolveed > 0);
    if (_isSearch) {
        NSArray *keyValue = [QUESTIONS_SELECT_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@(page),@20,catId,@(isreward),@(issolveed),@(self.dndType),@1] forKeys:keyValue];
        [[NetManager sharedManager] myRequestParam:dic
                                           withUrl:QUESTIONS_SELECT_API
                                          withType:QUESTIONS_SELECT
                                           success:^(id responseObject){
                                               NSLog(@"问题列表   %@",responseObject);
                                               if (page == 1) [self.dataSource removeAllObjects];
                                               [self.dataSource addObjectsFromArray:responseObject];
                                               page++;
                                               [self.tableView reloadData];
                                               [self.tableView.legendHeader endRefreshing];
                                               [self.tableView.legendFooter endRefreshing];
                                           }failure:^(id error){
                                               [BMUtils showError:error];
                                               [self.dataSource removeAllObjects];
                                               [self.tableView reloadData];
                                               [self.tableView.legendHeader endRefreshing];
                                               [self.tableView.legendFooter endRefreshing];
                                           }];
    }else{
        [self requestDataArticle];
//        [self.tableView.legendHeader beginRefreshing];
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
    if ([dic[@"from"]  isEqual: @2]) {
        cell.recommendIV.hidden = NO;
    }else {
        cell.recommendIV.hidden = YES;
    }
    if (dic[@"hits"] != nil && ![dic[@"hits"] isEqualToString:@""]) {
        NSString* hits = [NSString stringWithFormat:@"  %@",dic[@"hits"]];
        [cell.readsButton setTitle:hits forState:UIControlStateNormal];
    }else{
        [cell.readsButton setTitle:@"  0" forState:UIControlStateNormal];
    }
    
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
    [cell.label makeRoundCornerWithRadius:2];
    
    CGSize sizeEng = XZ_MULTILINE_TEXTSIZE(cell.label.text, [UIFont systemFontOfSize:10], CGSizeMake(SCREENWIDTH, 20), NSLineBreakByWordWrapping);
    [cell.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(sizeEng.width+10));
    }];
    [cell.label setColorWithText:cell.label.text];
    id superlist  = dic[@"superlist"];
    cell.gaoShou.text = [superlist isEqualToString:@"null"]||!superlist||[superlist length]<=0?@"":[NSString stringWithFormat:@"邀请%@回答",superlist];
    [HYHelper mSetVImageView:cell.head v:dic[@"type"] head:cell.headBtn];
    cell.count.text = [NSString stringWithFormat:@"%@",WYISBLANK([dic objectForKey:@"anum"])];
    
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

//- (void)enterNewsController {
//    XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
//    [self pushNewViewController:newsTableViewController];
//}
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


#pragma mark - 请求筛选栏目列表
- (void)requestTypeList:(NSString*)typeId
{
    if ([typeId isEqualToString:@"-1"]) {
        [self.sonArray removeAllObjects];
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
                                               if (weakMy.selectView.sonArray.count > 0){
                                                   [weakMy.selectView showDetailIndex:2];
                                               }
                                           }
                                       }failure:^(id error){
                                           if (typeId.length <= 0) {
                                               [weakMy.typeArray removeAllObjects];
                                           }else {
                                               [weakMy.sonArray removeAllObjects];
                                           }
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


@end
