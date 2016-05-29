//
//  XHWenGaoShouViewController.m
//  HuaYue
//
//  Created by lee on 15/1/14.
//
//

#import "XHWenGaoShouViewController.h"
#import "UIImageView+WebCache.h"
#import "XHMyButton.h"
#import "BMUtils.h"
#import "UIView+Cate.h"
#import "NSObject+Cate.h"
#import "HYHelper.h"

@interface XHWenGaoShouViewController ()<UISearchBarDelegate>
{
    int page;
}
@end

@implementation XHWenGaoShouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight  = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.title = @"邀请回答";
    dArray = [[NSMutableArray alloc] init];
    page = 1;
    //[self.navigationItem.rightBarButtonItem setTitlePositionAdjustment:UIOffsetMake(500, 0) forBarMetrics:UIBarMetricsDefault];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
    [self configuraTableViewNormalSeparatorInset];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor clearColor];
    //添加上拉加载更多
    __weak XHWenGaoShouViewController *blockSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];

    UIView *tsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VWidth(self.tableView), 30)];
    [self.view addSubview:tsView];
    self.tableView.frame = CGRectInset(self.tableView.frame, 0, 20);
     CGRectSetY(self.tableView, 30);//tableview纵坐标更新
    tsView.info = @{@"CALL":^(){
        self.tableView.frame = CGRectInset(self.tableView.frame, 0, -10);
        CGRectSetY(self.tableView, 0);
    }};
    [tsView mTSWithType:kTSGS];
    
    UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
//    searchBar.barTintColor = UIColorFromRGB(0xF1F2F6);
//    searchBar.layer.masksToBounds = YES;
//    searchBar.layer.borderColor = [UIColor clearColor].CGColor;
    self.tableView.tableHeaderView = searchBar;
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索好友";
}

- (void)clickedBarButtonItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadMoreData
{
    __weak XHWenGaoShouViewController *weakMy = self;
    NSArray *keyValue = [QUESTIONS_GAOLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_GAOLIST_API withType:QUESTIONS_GAOLIST success:^(id responseObject){
        [weakMy.dataSource removeAllObjects];
        [weakMy.dataSource addObjectsFromArray:[weakMy convrtData:responseObject]];
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
    }failure:^(id error){
        [weakMy.tableView.legendHeader endRefreshing];
    }];
}

- (void)reloadData
{
    page = 1;
    
    [self reloadMoreData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"wengaoshou";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = ViewFromXib(@"TiWenView",1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic  = self.dataSource[indexPath.row];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:201];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:202];
    UILabel *campanyLabel = (UILabel *)[cell viewWithTag:203];
    
    XHMyButton *selectBtn = (XHMyButton *)[cell viewWithTag:204];
    UIImageView *rank = (UIImageView *)[cell viewWithTag:205];
    UILabel *level = (UILabel *)[cell viewWithTag:206];
    selectBtn.selected = [dic[@"bselect"] boolValue];
    for (NSDictionary* dict in dArray) {
        if ([dict[@"id"] integerValue] == [dic[@"id"] integerValue]){
            selectBtn.selected = [dict[@"bselect"] boolValue];
            break;
        }
    }
    
    selectBtn.arrayIndex = [dic[@"id"] integerValue];
    [selectBtn addTarget:self action:@selector(userSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"head"])]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    headImage.info = @{@"uid":dic[@"id"]};
    headImage.tapBlock = ^(UIImageView *iv){
        [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
    };
    titleLabel.text = WYISBLANK(dic[@"nickname"]);
    campanyLabel.text = WYISBLANK(dic[@"company"]);
    [HYHelper mSetVImageView:rank v:dic[@"type"] head:headImage];
    [HYHelper mSetLevelLabel:level level:dic[@"rank"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)userSelect:(XHMyButton*)btn
{
    NSArray *uidArray   = [self.dataSource valueForKeyPath:@"id"];
    NSInteger   index   = [uidArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)btn.arrayIndex]];
    NSDictionary *dic   = [self.dataSource objectAtIndex:index];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([mDic[@"bselect"] boolValue]) {
        [mDic setObject:@"0" forKey:@"bselect"];
        NSArray *idArray   = [dArray valueForKeyPath:@"id"];
        if (dArray.count > 0 && [idArray containsObject:dic[@"id"]]) {
            NSInteger index = [idArray indexOfObject:dic[@"id"]];
            [dArray removeObjectAtIndex:index];
        }
    }else {
        if (dArray.count>=3) {
            [BMUtils showError:@"@高手不能超3人"];
            return;
        }
        [mDic setObject:@"1" forKey:@"bselect"];
        NSArray *idArray   = [dArray valueForKeyPath:@"id"];
        if (![idArray containsObject:mDic[@"id"]]) {
            [dArray addObject:mDic];
        }
    }
    [self.dataSource replaceObjectAtIndex:index withObject:mDic];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 999;
    btn.frame = Rect(Main_Screen_Width-65, 10, 60, 25);
    [btn setBackgroundImage:[UIImage imageNamed:@"bar-btn"] forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = SYSTEMFONT(14);
    [btn addTarget:self action:@selector(clickedBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
            [self.mydelegate didSelectedWithGaoShou:dArray];
    [[self.navigationController.navigationBar viewWithTag:999]removeFromSuperview];
    
}

#pragma mark -
- (NSArray*)convrtData:(NSArray*)array
{
    if (array.count <= 0) return nil;
    NSMutableArray  *list   = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic    = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        [dic setObject:@"0" forKey:@"bselect"];
        [list addObject:dic];
    }
    if (self.selectedDics) {
        [dArray addObjectsFromArray:self.selectedDics];
        WS(ws);
        [list enumerateObjectsUsingBlock:^(id obj0, NSUInteger idx, BOOL *stop) {
           [ws.selectedDics enumerateObjectsUsingBlock:^(id obj1, NSUInteger idx, BOOL *stop) {
               if ([obj0[@"id"]integerValue]==[obj1[@"id"]integerValue]) {
                   obj0[@"bselect"] = @"1";
               }
           }];
        }];
    }
    return list;
}

#pragma mark - searchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    printf(searchBar.text);
    if (searchBar.text != nil && [searchBar.text isEqualToString: @""] == false){
        [self searchGaoshouWithSearchKey:searchBar.text];
    }
}

- (void)searchGaoshouWithSearchKey:(NSString *)searchKey{
    
    __weak XHWenGaoShouViewController *weakMy = self;
    NSArray *keyValue = [QUESTIONS_GAOLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],nil] forKeys:keyValue];
    [dic setObject:searchKey forKey:@"keyword"];
    [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_GAOLIST_API withType:QUESTIONS_GAOLIST success:^(id responseObject){
        [weakMy.dataSource removeAllObjects];
//        weakMy.d
        [weakMy.dataSource addObjectsFromArray:[weakMy convrtData:responseObject]];
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
    }failure:^(id error){
        [weakMy.tableView.legendHeader endRefreshing];
    }];
}

@end
