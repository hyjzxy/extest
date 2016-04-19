//
//  XHMyWuPinViewController.m
//  HuaYue
//
//  Created by lee on 15/1/12.
//
//

#import "XHMyWuPinViewController.h"
#import "XHContactTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "NSObject+Cate.h"

@interface XHMyWuPinViewController ()<UIWebViewDelegate>
{
    int page;
    UIImageView *buttonBg;
    UIButton *leftBtn;
    UIButton *rightBtn;
    UIView *detailView;
    UIView *bottnSelectd0;
    UIView *bottnSelectd1;

}

//type=1 实物礼品,2学习资料
@property (nonatomic,assign)int currentType;


@end

@implementation XHMyWuPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的物品";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    page = 1;
    self.currentType    = 1;
    buttonBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [buttonBg setUserInteractionEnabled:YES];
    [self.view addSubview:buttonBg];
    
    leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,  160,  35)];
    [leftBtn setTitle:@"实物礼品" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn.titleLabel setFont:BOLDSYSTEMFONT(14.0)];
    [leftBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [leftBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    [buttonBg addSubview:leftBtn];
    //#67B4D4
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 0,  160,  35)];
    [rightBtn setTitle:@"学习资料" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setTitleColor:UIColorFromRGB(0x20ACF4) forState:UIControlStateSelected];
    [rightBtn setTitleColor:UIColorFromRGB(0x626363) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:BOLDSYSTEMFONT(14)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonBg addSubview:rightBtn];
    
    bottnSelectd0 = [[UIView alloc]initWithFrame:CGRectMake(0, 31,  160,  4)];
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1 = [[UIView alloc]initWithFrame:CGRectMake(160, 31,  160,  4)];
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    [buttonBg addSubview:bottnSelectd0];
    [buttonBg addSubview:bottnSelectd1];
    
    CGRect frame = self.tableView.frame;
    frame.origin.y = 35;
    frame.size.height = frame.size.height - 35;
    
    self.tableView.frame = frame;
    
    [self configuraTableViewNormalSeparatorInset];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加上拉加载更多
    WS(ws);
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [ws reloadData];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

-(void)leftBtnClick:(id)sender
{
    self.currentType =1;
    leftBtn.selected = YES;
    rightBtn.selected = NO;
    bottnSelectd0.backgroundColor = UIColorFromRGB(0x00A6F4);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0xDBDADA);
    page = 1;
    [self.dataSource removeAllObjects];
    [self reloadMoreData];
    
}
-(void)rightBtnClick:(id)sender
{
    leftBtn.selected = NO;
    rightBtn.selected = YES;
    bottnSelectd0.backgroundColor = UIColorFromRGB(0xDBDADA);
    bottnSelectd1.backgroundColor = UIColorFromRGB(0x00A6F4);
    self.currentType =2;
    page = 1;
    [self.dataSource removeAllObjects];
    [self reloadMoreData];
}

-(void)reloadMoreData{
    
    __weak XHMyWuPinViewController *weakMy = self;
    
    
    NSArray *keyValue = [MY_PRODUCT_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(self.currentType),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_PRODUCT_API withType:MY_PRODUCT success:^(id responseObject){
        
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

- (void)loadDataSource{
    NSArray *keyValue = [MY_QUESTIONSLIST_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(1),@(5),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_QUESTIONSLIST_API withType:MY_QUESTIONSLIST success:^(id responseObject){
        //将登录信息保存本地
        NSLog(@"class%@", [responseObject class]);
        for (NSDictionary *dic in responseObject) {
            [self.dataSource addObject:dic];
        }
        [self.tableView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"mywoods";
    XHContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        
        NSArray *cellList = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:nil options:nil];
        
        cell = (XHContactTableViewCell *)cellList[12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor    = [UIColor clearColor];
        cell.contentView.backgroundColor    = [UIColor clearColor];
    }
    NSDictionary *dic  = self.dataSource[indexPath.row];
    UIImageView *headImage = (UIImageView *)[cell viewWithTag:201];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:202];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:203];
    UILabel *jinfenLabel = (UILabel *)[cell viewWithTag:204];
    
    //头像
    [headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] placeholderImage:[UIImage imageNamed:@"1.png"]];

    NSString *timeStr = [BMUtils getDateByStringOld:WYISBLANK([self.dataSource[indexPath.row] objectForKey:@"inputtime"])];
    NSInteger status = [dic[@"status"]integerValue];
    NSArray *statuss = @[@"处理中",@"成功",@"失败"];
    timeStr = WYISBLANK(timeStr)?[NSString stringWithFormat:@"于%@申请兑换 %@", timeStr,statuss[status]]:@"";
    timeLabel.text = timeStr;
    jinfenLabel.text = WYISBLANK(dic[@"integral"]);
    titleLabel.text = WYISBLANK(dic[@"name"]);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.dataSource count];
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}
#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dicM  = self.dataSource[indexPath.row];
    [self detailDataSourceWithProid:[dicM[@"proid"]intValue]];
}

- (void)quxiao:(UIButton *)btn{
    [detailView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)detailDataSourceWithProid:(int)proid{
    NSArray *keyValue = [PRODUC_INFO_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[userDefault objectForKey:UID],@(proid),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:PRODUC_INFO_API withType:PRODUC_INFO success:^(id responseObject){
        detailView = ViewFromXib(@"paihangbang", 2);
        detailView.frame = CGRectMake(0, 0, CGRectGetWidth(detailView.frame), CGRectGetHeight(detailView.frame));
        UIButton *btn = (UIButton *)[detailView viewWithTag:201];
        [btn addTarget:self action:@selector(quxiao:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *btn2 = (UIButton *)[detailView viewWithTag:207];
        UIScrollView *scrollView = (UIScrollView*)[detailView viewWithTag:202];
        UILabel *pageLabel = (UILabel*)[detailView viewWithTag:199];
        scrollView.delegate = self;
        [self.view addSubview:detailView];
        NSDictionary *dicM = responseObject[0];
        NSArray *imglist = dicM[@"imglist"];
        if(imglist && imglist.count>0){
            scrollView.info = @{@"PageLabel":pageLabel,@"currPage":@1,@"totals":@(imglist.count)};
            [self setPageWithLabel:pageLabel currPage:1 totals:imglist.count];
            UIView *lastView = nil;
            UIView *container = [UIView new];
            [scrollView addSubview:container];
            [container mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(scrollView);
                make.height.equalTo(scrollView);
            }];
            for (NSString *imgURL in imglist) {
                UIImageView *iv = [[UIImageView alloc]init];
                [iv sd_setImageWithURL:IMG_URL(imgURL) placeholderImage:[UIImage imageNamed:@"share-logo"]];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                [container addSubview:iv];
                [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(container);
                    make.width.equalTo(scrollView);
                    if (lastView) {
                        make.leading.equalTo(lastView.mas_trailing);
                    }else{
                        make.leading.equalTo(container.mas_leading);
                    }
                }];
                lastView = iv;
            }
            if (lastView) {
                [container mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.equalTo(lastView.mas_trailing);
                }];
            }
        }else{
            scrollView.info = @{@"PageLabel":pageLabel,@"currPage":@0,@"totals":@0};
            [self setPageWithLabel:pageLabel currPage:0 totals:0];
        }
        UILabel *titleLabel = (UILabel *)[detailView viewWithTag:203];
        UILabel *scoreLabel = (UILabel *)[detailView viewWithTag:204];
        UILabel *tjLabel = (UILabel *)[detailView viewWithTag:205];
        UIWebView *contentLabel = (UIWebView *)[detailView viewWithTag:206];
        contentLabel.delegate = self;
        [contentLabel setOpaque:NO];
        UIImageView *finshImage = (UIImageView *)[detailView viewWithTag:410];
        UIImageView *hotImage = (UIImageView *)[detailView viewWithTag:411];
        titleLabel.text = WYISBLANK([dicM objectForKey:@"title"]);
        scoreLabel.text = WYISBLANK([dicM objectForKey:@"integral"]);
        NSMutableArray *tjArray = [[NSMutableArray alloc] init];
        [tjArray addObject:[NSString stringWithFormat:@"L%@", WYISBLANK([dicM objectForKey:@"rank"])]];
        NSString *str = [[dicM objectForKey:@"type"]boolValue]?@"需认证":@"";
        [tjArray addObject:str];
        NSString *tjStr = [tjArray componentsJoinedByString:@","];
        
        tjLabel.text = tjStr;
        [contentLabel loadHTMLString:[NSString stringWithFormat:@"<div style='word-break:break-all;'>%@</div>",dicM[@"content"]] baseURL:nil];
        finshImage.hidden = YES;
        hotImage.hidden = YES;
        btn2.enabled = NO;
        [btn2 setImage:[UIImage imageNamed:@"btn_endagainsted"] forState:UIControlStateDisabled];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

- (void)setPageWithLabel:(UILabel*)label currPage:(NSInteger)currPage totals:(NSInteger)totals
{
    NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%zd/%zd",currPage,totals]];
    [mAttr setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFD5C12)} range:NSMakeRange(0, [@(currPage)stringValue].length)];
    label.attributedText = mAttr;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currPage = scrollView.contentOffset.x/VWidth(scrollView)+1;
    NSInteger totals = [scrollView.info[@"totals"]integerValue];
    [self setPageWithLabel:scrollView.info[@"PageLabel"] currPage:currPage totals:totals];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#915E01'"];
}
@end
