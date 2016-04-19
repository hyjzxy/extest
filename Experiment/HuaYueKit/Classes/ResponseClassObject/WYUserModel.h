//
//  UserModel.h
//  Les
//
//  Created by 朱亮亮 on 14-11-3.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  登录类型
 */
typedef enum {
    ULNeverActivationType = 0, /**< 未激活 */
    ULLoginType = 1,           /**< 登录 */
    ULLogoutType = 2           /**< 注销 */
} UserLoginType;

/**
 *  用户
 */
@interface WYUserModel : NSObject

/**
 *  逻辑主键
 */
@property (nonatomic, copy) NSString *userID;

/**
 *  第三方语音聊天的用户ID
 */
@property (nonatomic, copy) NSString *uuID;

/**
 *  第三方语音聊天的用户名（账号）
 */
@property (nonatomic, copy) NSString *uusername;

/**
 *  第三方语音聊天的密码
 */
@property (nonatomic, copy) NSString *upassword;

/**
 *  是否已登录
 */
@property (nonatomic, assign) UserLoginType isLogin;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 *  头像大图
 */
@property (nonatomic, copy) NSString *avatarBig;

/**
 *  头像中图
 */
@property (nonatomic, copy) NSString *avatarMiddle;

/**
 *  头像小图
 */
@property (nonatomic, copy) NSString *avatarSmall;

/**
 *  头像袖珍图
 */
@property (nonatomic, copy) NSString *avatarTiny;

/**
 *  相片
 */
@property (nonatomic, copy) NSString *photoImg;

/**
 *  性别（角色）0:T 1:H 2:P
 */
@property (nonatomic, copy) NSString *sex;

/**
 *  年龄（岁）
 */
@property (nonatomic, copy) NSString *birthday;

/**
 *  身高cm
 */
@property (nonatomic, copy) NSString *tall;

/**
 *  体重kg
 */
@property (nonatomic, copy) NSString *weight;

/**
 *  个性签名
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  颜色
 */
@property (nonatomic, copy) NSString *color;

/**
 *  纬度
 */
@property (nonatomic, assign) double latitude;

/**
 *  经度
 */
@property (nonatomic, assign) double longitude;

/**
 *  城市字符串
 */
@property (nonatomic, copy) NSString *location;

/**
 *  关注数量
 */
@property (nonatomic, assign) int followingCount;

/**
 *  粉丝数量
 */
@property (nonatomic, assign) int fanCount;

/**
 *  好友数量
 */
@property (nonatomic, assign) int friendCount;

/**
 *  状态：1:注册成功 2:已经完善资料 3:已编辑资料
 */
@property (nonatomic, assign) int status;

/**
 *  我是否关注了TA，YES：是  NO：否
 */
@property (nonatomic, assign) BOOL isFollowing;

/**
 *  他是否关注了我，YES：是  NO：否
 */
@property (nonatomic, assign) BOOL isFollowed;

/**
 *  距离
 */
@property (nonatomic, assign) int distance;

/**
 *  距离
 */
@property (nonatomic, assign) float width;

/**
 *  距离
 */
@property (nonatomic, assign) float height;

/**
 *  我是否拉黑TA，YES：是  NO：否
 */
@property (nonatomic, assign) BOOL isBlacking;

/**
 *  他是否拉黑了我，YES：是  NO：否
 */
@property (nonatomic, assign) BOOL isBlacked;


/**
 *  他是否拉黑了我，YES：是  NO：否
 */
@property (nonatomic, assign) BOOL isOnline;


/**
 *  在线时间
 */
@property (nonatomic, assign) NSString *onlineTime;

@end
