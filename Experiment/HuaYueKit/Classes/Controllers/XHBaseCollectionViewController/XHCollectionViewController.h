//
//  XHCollectionViewController.h
//  HuaYue
//
//  Created by Appolls on 14-12-10.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHBaseViewController.h"

@interface XHCollectionViewController : XHBaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>



/**
 *  显示大量数据的控件
 */
@property (nonatomic, strong) UICollectionView *collectionView;
/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, retain) UICollectionViewFlowLayout *flowLayout;

/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;



@end
