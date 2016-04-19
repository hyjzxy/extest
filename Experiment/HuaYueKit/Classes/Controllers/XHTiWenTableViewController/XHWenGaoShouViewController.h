//
//  XHWenGaoShouViewController.h
//  HuaYue
//
//  Created by lee on 15/1/14.
//
//

#import "XHBaseTableViewController.h"

@protocol wenGaoShouDelegate <NSObject>

@optional
- (void)didSelectedWithGaoShou:(NSMutableArray *)dArray;

@end


@interface XHWenGaoShouViewController : XHBaseTableViewController
{
    NSMutableArray *dArray;
}

@property(nonatomic,assign) id<wenGaoShouDelegate> mydelegate;
@property(nonatomic, strong) NSArray *selectedDics;

@end
