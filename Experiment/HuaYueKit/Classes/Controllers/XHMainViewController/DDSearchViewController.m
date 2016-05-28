//
//  DDSearchViewController.m
//  IYiMing
//
//  Created by lee on 14/12/2.
//  Copyright (c) 2014年 lee. All rights reserved.
//
#import "DDSearchViewController.h"
#import "XHNewsTableViewController.h"
//#import "DDListCell.h"
//#import "DDItemDetailViewController.h"
#import "UIImage+DD.h"
#import "XHContactTableViewCell.h"
#import "SBJsonParser.h"
#import "UIButton+WebCache.h"
#import "MZAnswerListVC.h"
#import "Masonry.h"
#import "NSObject+Cate.h"
#import "UIView+Cate.h"
#import "HYHelper.h"
#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]
#define BACKGROUND_COLOR RGB(236, 240, 241)

#define LOGIN_PLACEHOLDER_COLOR [UIColor whiteColor]
#define LOGIN_CODESENDER_COLOR RGB(232, 186, 24)
#define DARK_TITLE_COLOR RGB(52, 73, 94)
#define CELL_BACKGROUND_COLOR RGB(237, 236, 243)

@interface DDSearchViewController ()<UISearchBarDelegate>
{
    NSString *pID;
    int page;
    NSString *keyword;
}

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *selectedResults;

@property (nonatomic, strong) UISearchBar *curSearchBar;

@end

@implementation DDSearchViewController

-(void)reloadMoreData{
    if ([self.curSearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [self.tableView.legendHeader endRefreshing];
        [self.tableView.legendFooter endRefreshing];
        [BMUtils showError:@"请输入查询关键字"];
        [self.curSearchBar becomeFirstResponder];
        return;
    }
    __weak DDSearchViewController *weakMy = self;
    NSArray *keyValue = [QUESTIONS_SEAR_PARAM componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",page],[NSNumber numberWithInt:20],self.curSearchBar.text,nil] forKeys:keyValue];
    [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_SEAR_API withType:QUESTIONS_SEAR success:^(id responseObject){
        keyword = dic[@"keyword"];
        if (page == 1) [weakMy.dataSource removeAllObjects];
        [weakMy.dataSource addObjectsFromArray:responseObject];
        page++;
        [weakMy.tableView reloadData];
        [weakMy.tableView.legendHeader endRefreshing];
        [weakMy.tableView.legendFooter endRefreshing];
    }failure:^(id error){
        [BMUtils showError:error];
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

- (void)initSearchBar {
    self.curSearchBar = [[UISearchBar alloc] init];
    _curSearchBar.tintColor=[UIColor blackColor];
    self.curSearchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width -80, 30);
    self.curSearchBar.center = CGPointMake(self.navigationController.navigationBar.center.x+20, 22);
    self.curSearchBar.placeholder = @"输入关键字";
    self.curSearchBar.delegate = self;
    self.curSearchBar.backgroundColor = [UIColor clearColor];
    [self.curSearchBar setBackgroundImage:[UIImage createImageWithColor:CELL_BACKGROUND_COLOR]];
}

- (void)addAction:(UIButton *)sender {
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_curSearchBar removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_curSearchBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF1F2F6);
    // Do any additional setup after loading the view.
    [self.curSearchBar becomeFirstResponder];
    self.resultArray = [[NSMutableArray alloc] init];
    self.selectedResults = [[NSMutableArray alloc] init];
    [self initSearchBar];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    page = 1;
    //添加上拉加载更多
    __weak DDSearchViewController *blockSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [blockSelf reloadMoreData];
    }];
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [blockSelf reloadData];
    }];
    if ([self.tableView respondsToSelector:@selector(setKeyboardDismissMode:)]) {
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    UIView *tsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VWidth(self.view), 40)];
    self.tableView.tableHeaderView = tsView;
    tsView.info = @{@"CALL":^(){
        self.tableView.tableHeaderView = nil;
    }};
    [tsView mTSWithType:kTSearch];
}

#pragma mark - TableView Delegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 500.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"contactTableViewCellIdentifier";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = (XHContactTableViewCell *)ViewFromXib(@"MyTableViewCell", 0);
    }
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    
    [cell.headBtn sd_setBackgroundImageWithURL:IMG_URL(dic[@"head"]) forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultImg.png"]];
    cell.headBtn.info = @{@"uid":dic[@"uid"]};
    cell.headBtn.tapBlock = ^(UIButton *iv){
        [HYHelper pushPersonCenterOnVC:self uid:[iv.info[@"uid"]intValue]];
    };
    cell.userName.text = WYISBLANK([dic objectForKey:@"nickname"]);
    [HYHelper mSetLevelLabel:cell.level level:dic[@"rank"]];
    cell.time.text = N2V(dic[@"inputtime"], @"");
    if (dic[@"hits"] != nil){
        [cell.readsButton setTitle:dic[@"hits"] forState:UIControlStateNormal];
    }else{
        [cell.readsButton setTitle:@"0" forState:UIControlStateNormal];
    }
    
    //关键字处理
    NSString * content = WYISBLANK([dic objectForKey:@"content"]);
    NSArray *tmp = [keyword componentsSeparatedByString:@" "];
    NSMutableArray *keys = [NSMutableArray array];
    if (tmp) {
        [tmp enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0) {
                [keys addObject:obj];
            }
        }];
    }
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:cell.content.font}];
    [content enumerateSubstringsInRange:NSMakeRange(0, content.length) options:NSStringEnumerationByWords|NSStringEnumerationLocalized usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [keys enumerateObjectsUsingBlock:^(NSString *k, NSUInteger idx, BOOL *stop) {
            if ([substring rangeOfString:k options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [mAttr setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:substringRange];
            }
        }];
    }];
    cell.content.attributedText = mAttr;
    cell.logImg.hidden = !([N2V(dic[@"image"],@"")stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length>0);
    if([WYISBLANK([dic objectForKey:@"issolveed"]) isEqualToString:@"0"]){
        cell.checkBtn.alpha = 0;
    }else{
        cell.checkBtn.alpha = 1;
    }
    cell.count.text = [NSString stringWithFormat:@"%@人回答",WYISBLANK([dic objectForKey:@"anum"])];
    cell.huidaIMG.hidden = YES;
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
    cell.reward.layer.masksToBounds = YES;
    cell.reward.layer.borderWidth = 1;
    cell.reward.layer.borderColor = [UIColor colorWithWhite:0.741 alpha:0.290].CGColor;
    cell.reward.layer.cornerRadius = VHeight(cell.reward)/2;
//    cell.label.text = WYISBLANK([dic objectForKey:@"lable"]);
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
    cell.profileLabel.text = N2V(dic[@"info"], @"");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    /*XHNewsTableViewController *newsTableViewController = [[XHNewsTableViewController alloc] init];
    newsTableViewController.dic = dic;
    [self pushNewViewController:newsTableViewController];*/
    MZAnswerListVC *answerListVC = [[MZAnswerListVC alloc]init];
    //TODO:
    answerListVC.qid = [dic[@"id"]integerValue];
    [self pushNewViewController:answerListVC];
}

#pragma mark - SearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.curSearchBar resignFirstResponder];
    [self.tableView.legendHeader beginRefreshing];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
