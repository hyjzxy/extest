//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "DropDownListView.h"
#import "NetManager.h"
#import "SVProgressHUD.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@interface DropDownListView ()

@property (nonatomic, strong) NSDictionary *oneDict;
@property (strong, nonatomic) UIButton *dropDwonBtn;
@end

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate withArray:(NSMutableArray *)arrayList
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        array1 = arrayList;
        array = [[NSMutableArray alloc] init];
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 1, sectionWidth, frame.size.height)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            [sectionBtn  setTitle:@"请选择行业和分类" forState:UIControlStateNormal];
            [sectionBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            sectionBtn.backgroundColor = UIColorFromRGB(0xF9FBFD);
            sectionBtn.titleLabel.font = BOLDSYSTEMFONT(14);
            [sectionBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
            [self addSubview:sectionBtn];
            [sectionBtn.titleLabel sizeToFit];
            UIImage *arrowImage = sectionBtn.currentImage;
            [sectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -arrowImage.size.width, 0, arrowImage.size.width)];
            [sectionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, sectionBtn.titleLabel.bounds.size.width, 0, -sectionBtn.titleLabel.bounds.size.width)];
            if (i<sectionNum && i != 0) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self addSubview:lineView];
            }
        }
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    [btn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        [btn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
//    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
//    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        CGRect rectLeft = self.mLeftTableView.frame;
        rectLeft.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            self.mLeftTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            self.mLeftTableView.alpha = 0.2f;
            
            self.mTableView.frame = rect;
            self.mLeftTableView.frame = rectLeft;
            
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mLeftTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.mTableBaseView.backgroundColor = UIColorFromRGB(0x98999A);
        
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height, 125, 240) style:UITableViewStylePlain];
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        self.mTableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.mLeftTableView = [[UITableView alloc] initWithFrame:CGRectMake(120, self.frame.origin.y + self.frame.size.height, 200, 240) style:UITableViewStylePlain];
        self.mLeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mLeftTableView.delegate = self;
        self.mLeftTableView.dataSource = self;
        self.mLeftTableView.backgroundColor = UIColorFromRGB(0xF3F7F5);
    }
    
    CGRect rect = self.mTableView.frame;
    rect.size.height = 0;
    CGRect rectLeft = self.mLeftTableView.frame;
    rectLeft.size.height = 0;
    self.mTableView.frame = rect;
    self.mLeftTableView.frame = rectLeft;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    [self.mSuperView addSubview:self.mLeftTableView];
    //动画设置位置
    rect .size.height = 240;
    rectLeft .size.height = 240;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 0.2;
        self.mLeftTableView.alpha = 0.2;
        self.mTableBaseView.alpha = 1.0;
        self.mTableView.alpha = 1.0;
        self.mLeftTableView.alpha = 1.0;
        self.mTableView.frame =  rect;
        self.mLeftTableView.frame =  rectLeft;
    }];
    [self.mTableView reloadData];
    [self.mLeftTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mTableView){
        NSDictionary *dicLIst = [array1 objectAtIndex:indexPath.row];
        self.oneDict = dicLIst;
        __weak DropDownListView *weakMy = self;
        NSArray *keyValue = [QUESTIONS_CATA_PARAM componentsSeparatedByString:@","];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:dicLIst[@"id"],nil] forKeys:keyValue];
        [SVProgressHUD showWithStatus:@"加载中"];
        [[NetManager sharedManager] myRequestParam:dic withUrl:QUESTIONS_CATA_API withType:QUESTIONS_CATA success:^(id responseObject){
            [array removeAllObjects];
            [array addObjectsFromArray:responseObject];
            [weakMy.mLeftTableView reloadData];
            [SVProgressHUD dismiss];
        }failure:^(id error){
            [weakMy.mLeftTableView reloadData];
            [SVProgressHUD dismiss];
        }];
        
        
    }else{
        if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:withText:)]) {
            
            NSDictionary *dic = [array objectAtIndex:indexPath.row];
            
            UIButton *currentIV= (UIButton *)[self viewWithTag:(SECTION_BTN_TAG_BEGIN )];
            [currentIV setTitle:[NSString stringWithFormat:@"%@ %@",[self.oneDict objectForKey:@"catname"],[Utils isBlankString:dic[@"catname"]]] forState:UIControlStateNormal];
            [currentIV setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
            UILabel *title = currentIV.titleLabel;
            [title sizeToFit];
            UIImage *arrowImage = currentIV.currentImage;
            [currentIV setImage:arrowImage forState:UIControlStateNormal];
            [currentIV setTitleEdgeInsets:UIEdgeInsetsMake(0, -arrowImage.size.width, 0, arrowImage.size.width)];
            [currentIV setImageEdgeInsets:UIEdgeInsetsMake(0, title.bounds.size.width, 0, -title.bounds.size.width)];
            [self.dropDownDelegate chooseAtSection:currentExtendSection index:[Utils isBlankString:dic[@"id"]] withText:[Utils isBlankString:dic[@"catname"]]];
            [self hideExtendedChooseView];
        }
    }
    
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.mTableView){
        return [array1 count];
    }else{
        return [array count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mTableView){
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            UIView *bgView = [[UIView alloc]initWithFrame:cell.frame];
            UIView *l = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, CGRectGetHeight(cell.frame))];
            l.backgroundColor = UIColorFromRGB(0x5ACFBB);
            [bgView addSubview:l];
            cell.selectedBackgroundView = bgView;
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xF3F7F5);
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        NSDictionary *dic = [array1 objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = dic[@"catname"];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else{
        static NSString * cellIdentifier = @"cellIdentifier11111";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIView *bgView = [[UIView alloc]initWithFrame:cell.frame];
            cell.selectedBackgroundView = bgView;
            cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xF3F7F5);
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        NSDictionary *dic = [array objectAtIndex:indexPath.row];
        cell.textLabel.backgroundColor =  [UIColor clearColor];
        cell.textLabel.text = dic[@"catname"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mTableView){
        UITableViewCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didMoveToSuperview
{
    if ([_mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([_mLeftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mLeftTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mLeftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mLeftTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
