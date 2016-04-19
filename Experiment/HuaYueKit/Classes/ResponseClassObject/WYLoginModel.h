//
//  WYLoginModel.h
//  HuaYue
//
//  Created by Appolls on 14-12-29.
//
//

#import "WYBaseModel.h"

@interface WYLoginModel : WYBaseModel

/*{"uid":1,"nickname":"Cocol","invitation":1001}"}*/
@property (nonatomic,strong)NSString *uID;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *invitation;

@end
