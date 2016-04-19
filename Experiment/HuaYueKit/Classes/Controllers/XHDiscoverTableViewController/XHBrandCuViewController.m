//
//  XHBrandCuViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-8.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBrandCuViewController.h"
#import "MyLabel.h"
#import "BMCollectionViewCell.h"
#import "BMMyCollectionReusableView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Cate.h"
#import "Masonry.h"
#import "NSObject+Cate.h"

@interface XHBrandCuViewController ()<UISearchBarDelegate>
{
    UISearchBar *search;
}
@property (nonatomic,assign) BOOL    isSearch;//是否是搜索数据

@end

@implementation XHBrandCuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"品牌库";
    
    self.view.backgroundColor = RGBACOLOR(239, 239, 239, .9);
    [self.collectionView registerClass:[BMCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [self.collectionView registerClass:[BMMyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryCollectionCell"];
    search = [[UISearchBar alloc]init];
    search.delegate = self;
    search.placeholder = @"搜索";
    [self.view addSubview:search];
    WS(ws);
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(ws.view);
        make.height.mas_equalTo(@44);
    }];
    
    UIView *tsView = [[UIView alloc]init];
    [self.view addSubview:tsView];
    [tsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(ws.view);
        make.top.equalTo(search.mas_bottom);
        make.height.mas_equalTo(@55);
    }];
    tsView.info = @{@"CALL":^(){
        [ws.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(search.mas_bottom);
        }];
    }};
    [tsView mTSWithType:kTSPPK];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom).with.offset(55.0f);
        make.leading.trailing.bottom.equalTo(ws.view);
    }];

    [self loadDataSource];
    
}

- (void)loadDataSource{
    NSArray *keyValue = [FIND_BRAND_PARAM componentsSeparatedByString:@","];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"INVITATION<<<<<<<<%@", [userDefault objectForKey:UID]);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@(1),@(50),nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:FIND_BRAND_API withType:FIND_BRAND success:^(id responseObject){
        //将登录信息保存本地
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:responseObject];
        [self.collectionView reloadData];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(106.6f, 106.6f);
}
//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return -1.0f;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BMCollectionViewCell *cell = (BMCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.row];
    UIImageView *image = cell.contentView.subviews[1];
    image.contentMode = UIViewContentModeScaleAspectFit;
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_ADDRESS,WYISBLANK([dic objectForKey:@"thumb"])]] placeholderImage:[UIImage imageNamed:@"AlbumHeaderBackgrounImage.png"]];
    UILabel *titleLabel = cell.contentView.subviews[0];
    titleLabel.text = WYISBLANK(dic[@"title"]);
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    xiangqingye *control = [[xiangqingye alloc] initWithWID:[self.dataSource[indexPath.row][@"id"] intValue] title:@"品牌库"];
    [self.navigationController pushViewController:control animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark # UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length <= 0) return;
    
    self.isSearch   = YES;
    [self requestSearchData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length <= 0) {
        self.isSearch   = YES;
        [self loadDataSource];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)requestSearchData
{
    [self.view endEditing:YES];
    if (search.text.length <= 0) return;
    __weak XHBrandCuViewController *weakMy = self;
    NSArray *keyValue = [FIND_BRANDSSEARC_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:@[@1,@50,search.text] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:FIND_BRANDSSEARC_API
                                      withType:FIND_BRANDSSEARC
                                       success:^(id responseObject) {
                                           
                                            [weakMy.dataSource removeAllObjects];
                                            [weakMy.dataSource addObjectsFromArray:responseObject];
                                            [weakMy.collectionView reloadData];
                                           
                                       }failure:^(id error){
                                           [weakMy.collectionView reloadData];
                                           [BMUtils showError:@"没有搜索到相应的结果"];
                                       }];
}

@end
