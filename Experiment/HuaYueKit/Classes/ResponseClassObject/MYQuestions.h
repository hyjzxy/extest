//
//  MYQuestions.h
//  HuaYue
//
//  Created by Appolls on 14-12-29.
//
//

#import "WYBaseModel.h"

@interface MYQuestions : WYBaseModel
/*
 data":"{"id":1,"catid":1,"content":"XXXXXXXXX","lable":"XXX","reward":"XXXXXXXXX","superlist":"1,2","inputtime":1418007752}"}
 */
@property (nonatomic,strong)NSString *qID;
@property (nonatomic,strong)NSString *catId;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *lable;
@property (nonatomic,strong)NSString *reward;
@property (nonatomic,strong)NSString *superList;
@property (nonatomic,strong)NSString *inputTime;
@end
