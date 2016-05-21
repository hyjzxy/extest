//
//  MZShareItemTableViewCell.h
//  HuaYue
//
//  Created by chulaihai on 2/26/16.
//  Copyright © 2016 麦子收割队. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MZShareItemTableViewCellDelegateSuccess)();

@interface MZShareItemTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *content;
@property (strong,nonatomic)NSDictionary*data;
@property (strong,nonatomic)NSIndexPath*indexPath;
@property (assign, nonatomic) NSInteger uid;
@property (nonatomic,copy)  MZShareItemTableViewCellDelegateSuccess             deleteSuccess;
@end
