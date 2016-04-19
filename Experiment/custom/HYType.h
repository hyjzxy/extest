//
//  HYType.h
//  HuaYue
//
//  Created by 崔俊红 on 15-3-28.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#ifndef HuaYue_HYType_h
#define HuaYue_HYType_h

typedef void(^userdefaults_block_t) (NSUserDefaults *userDefaults);
typedef void(^hy_block_t)(void);

typedef NS_ENUM(NSInteger, ChatTType) {
    kNoneChat,
    kAnswerChat,// 回答
    kAddQuestChat//追问
};
typedef NS_ENUM(NSInteger, ChatFrom) {
    kChatFromWaitAnswer,//等你答
    kChatFromMyQuest,    //我的提问
    kChatFromMyAnswer,  //我的回答
    kChatFromMyAddQuest,// 我的追问
    kChatFromPersonPage // 个人主页
};
#endif
