//
//  WYLoginModel.m
//  HuaYue
//
//  Created by Appolls on 14-12-29.
//
//

#import "WYLoginModel.h"

@implementation WYLoginModel

-(id)initWithDictionary:(NSDictionary *)dictionary{
    
    self = [super initWithDictionary:dictionary];
    if(self){
        
        self.uID = WYISBLANK(dictionary[@"uid"]);
        self.nickName = WYISBLANK(dictionary[@"nickname"]);
        self.invitation = WYISBLANK(dictionary[@"invitation"]);
        
    }
    
    return self;
}

@end
