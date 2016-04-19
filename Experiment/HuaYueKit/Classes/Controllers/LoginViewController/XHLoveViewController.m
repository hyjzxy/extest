//
//  XHLoveViewController.m
//  HuaYue
//
//  Created by Appolls on 14-12-16.
//
//

#import "XHLoveViewController.h"
#import "XHStoreManager.h"
#import "LoveTableViewCell.h"
#import "XHProfileTableViewController.h"
#import "NSObject+JSON.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

#define UserInterestInfoPath [NSHomeDirectory() stringByAppendingString:@"/Library/Preferences/UserInterestInfo.dat"]

@interface XHLoveViewController ()<LoveTableViewCellDelegate>
{
    UIButton *confirm;
    NSMutableArray *list;
    NSMutableArray *typeArray;
}

@end

@implementation XHLoveViewController
- (void)loadDataSource {
    
    __weak XHLoveViewController *love = self;
    
    NSArray *keyValue = [MY_GETINTEREST_PARAM componentsSeparatedByString:@","];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.uId,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic
                                       withUrl:MY_GETINTEREST_API
                                      withType:MY_GETINTEREST
                                       success:^(id responseObject) {
                                           [love.dataSource removeAllObjects];
                                           [love.dataSource addObjectsFromArray:responseObject];
                                           [love.tableView reloadData];
                                       }failure:^(id error){
                                           [BMUtils showError:error];
                                       }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(239, 239, 239);
    
    self.title = self.isSign?@"您感兴趣的":@"我感兴趣的";
    
    list = [[NSMutableArray alloc] init];
    typeArray   = [[NSMutableArray alloc] init];
    CGRect frame = self.tableView.frame;
    frame.size.height = frame.size.height - 45;
    self.tableView.frame = frame;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString    *btnTitle   = self.isSign?@"提交":@"修改";
    confirm = [[UIButton alloc] initWithFrame:CGRectMake(95, frame.size.height + 10, 130, 30)];
    [confirm setEnabled:NO];
    [confirm setTitle:btnTitle forState:UIControlStateNormal];
    [confirm setBackgroundImage:[UIImage imageNamed:@"提交"] forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:confirm];
    [self configuraTableViewNormalSeparatorInset];
    [self loadDataSource];
    
}
-(void)confirm
{
    __weak XHLoveViewController *love = self;
    
    NSArray *keyValue = [MY_INTEREST_PARAM componentsSeparatedByString:@","];
    
    NSString *catId = [list JSONRepresentation];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.uId,catId,nil] forKeys:keyValue];
    
    [[NetManager sharedManager] myRequestParam:dic withUrl:MY_INTEREST_API withType:MY_INTEREST success:^(id responseObject){
        [BMUtils showSuccess:@"提交成功"];
        [love.navigationController popToRootViewControllerAnimated:YES];
    }failure:^(id error){
        [BMUtils showError:error];
    }];
    
}

-(void)buttonBtn:(LoveTableViewCell *)loveCell
{
    NSDictionary *secDic = self.dataSource[loveCell.indexPath.section];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:secDic];
    
    SBJsonParser *jsonParser1 = [[SBJsonParser alloc] init];
    id result = dic[@"subcategory"];
    NSArray * responseDic1 = nil;
    if ([result isKindOfClass:[NSString class]]) {
        responseDic1 = [jsonParser1 objectWithString:WYISBLANK(dic[@"subcategory"]) error:nil];
    }else {
        responseDic1 = (NSArray*)result;
    }
    
    NSMutableArray  *array  = [NSMutableArray arrayWithArray:responseDic1];
    NSDictionary *disconverDictionary = array[loveCell.indexPath.row];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:disconverDictionary];
    
    if (loveCell.button.selected) {
        loveCell.button.selected = NO;
        [dict setObject:@"0" forKey:@"isselect"];
    }else {
        loveCell.button.selected = YES;
        [dict setObject:@"1" forKey:@"isselect"];
    }
    
    [array replaceObjectAtIndex:loveCell.indexPath.row withObject:dict];
    [dic setObject:array forKey:@"subcategory"];
    [self.dataSource replaceObjectAtIndex:loveCell.indexPath.section withObject:dic];
    
    if(loveCell.button.selected){
        [list addObject:loveCell.pId];
        [typeArray addObject:loveCell.type];
    }else{
        [list removeObject:loveCell.pId];
        [typeArray removeObject:loveCell.type];
    }
    
    NSMutableArray  *typeList = [[NSMutableArray alloc] init];
    if (typeArray.count > 0) {
        
        for (NSString *type in typeArray) {
            NSString *hasStr = [type componentsSeparatedByString:@"."][1];
            [typeList addObject:hasStr];
        }
    }
    
    if(list.count > 1 && [NSSet setWithArray:typeList].allObjects.count > 1){
        confirm.enabled = YES;
    }else{
        confirm.enabled = NO;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView  *headView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 30)];
    headView.backgroundColor = RGBCOLOR(239, 239, 239);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    label.text = section?@"请选择您感兴趣的内容（至少选一个）":@"请选择您感兴趣的行业（至少选一个）";//self.dataSource[section][@"catname"];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = RGBCOLOR(153, 153, 153);
    label.backgroundColor = [UIColor clearColor];
    [headView addSubview:label];

    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource[section];
    SBJsonParser *jsonParser1 = [[SBJsonParser alloc] init];
    NSArray * responseDic1 = [jsonParser1 objectWithString:WYISBLANK([self.dataSource[section] objectForKey:@"subcategory"]) error:nil];
    
    return responseDic1.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    LoveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *list1 = [[NSBundle mainBundle] loadNibNamed:@"LoginSignView" owner:nil options:nil];
        cell = (LoveTableViewCell *)list1[1];
        cell.delegate = self;
        
    }
    SBJsonParser *jsonParser1 = [[SBJsonParser alloc] init];
    
    id result = [self.dataSource[indexPath.section] objectForKey:@"subcategory"];
    NSArray * responseDic1 = nil;
    if ([result isKindOfClass:[NSString class]]) {
        responseDic1 = [jsonParser1 objectWithString:WYISBLANK([self.dataSource[indexPath.section] objectForKey:@"subcategory"]) error:nil];
    }else {
        responseDic1 = (NSArray*)result;
    }
    
    if (indexPath.row < responseDic1.count) {
        NSDictionary *disconverDictionary = responseDic1[indexPath.row];
        NSString *pid = [disconverDictionary valueForKey:@"id"];
        NSString *type= [NSString stringWithFormat:@"%@.%@",pid,self.dataSource[indexPath.section][@"catname"]];
        cell.label.text = [disconverDictionary valueForKey:@"catname"];
        cell.pId = pid;
        cell.indexPath  = indexPath;
        cell.type = type;
        [cell.headImg setImageWithURL:IMG_URL(disconverDictionary[@"image"]) usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        int isSelect    = [[disconverDictionary valueForKey:@"isselect"] intValue];
        
        if (isSelect == 1) {
            cell.button.selected = YES;
            if (![list containsObject:pid]) {
                [list addObject:pid];
                [typeArray addObject:type];
            }
        }else {
            cell.button.selected = NO;
            if ([list containsObject:pid]) {
                [list removeObject:pid];
                [typeArray removeObject:type];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma markr - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
