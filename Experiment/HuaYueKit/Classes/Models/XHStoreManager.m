//
//  XHStoreManager.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-18.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHStoreManager.h"

#import "XHContact.h"
#import "XHAlbum.h"

#import "NSString+XHDiskSizeTransfrom.h"

@implementation XHStoreManager

+ (instancetype)shareStoreManager {
    static XHStoreManager *storeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[XHStoreManager alloc] init];
    });
    return storeManager;
}

- (NSMutableArray *)getDiscoverConfigureArray {
    NSMutableArray *discoverConfigureArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSDictionary *AlbumDictionary = @{@"title": @"助手日报", @"subTitle": @"每日精选，丰富你的实验生活",@"image" : @"ff_IconShowNews"};
    NSDictionary *shitDictionary = @{@"title": @"实验周刊", @"subTitle": @"每周精选问答，培训资料等",@"image" : @"ff_IconShowTest"};
    NSDictionary *faDictionary = @{@"title": @"法规文献", @"subTitle": @"查询国内外法规，文献资料",@"image" : @"ff_IconShowLaw"};
    [discoverConfigureArray addObject:@[AlbumDictionary,shitDictionary,faDictionary]];
    
    NSDictionary *QRCodeDictionary = @{@"title": @"活动中心", @"subTitle": @"促销，活动",@"image" : @"ff_IconActivity"};
    NSDictionary *ShakeDictionary = @{@"title": @"品牌库",@"subTitle": @"实验室仪器，耗材品牌，正牌代理商", @"image" : @"ff_IconBrand"};
    NSDictionary *peiDictionary = @{@"title": @"培训信息", @"subTitle": @"实验室相关培训安排",@"image" : @"ff_IconTech"};
    [discoverConfigureArray addObject:@[QRCodeDictionary, ShakeDictionary,peiDictionary]];
    
    NSDictionary *LocationServiceDictionary = @{@"title": @"积分商城",@"subTitle": @"积分换大礼", @"image" : @"ff_IconScore"};
    NSDictionary *BottleDictionary = @{@"title": @"排行榜",@"subTitle": @"各路高手答题一较高下", @"image" : @"ff_IconRand"};
    [discoverConfigureArray addObject:@[LocationServiceDictionary, BottleDictionary]];
    
    return discoverConfigureArray;
}


- (NSMutableArray *)getLoveArray {
    NSMutableArray *discoverConfigureArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSDictionary *AlbumDictionary = @{@"title": @"助手日报", @"subTitle": @"每日精选，丰富你的实验生活",@"image" : @"ff_IconShowNews"};
    NSDictionary *shitDictionary = @{@"title": @"实验周刊", @"subTitle": @"每周精选问答，培训资料等",@"image" : @"ff_IconShowTest"};
    NSDictionary *faDictionary = @{@"title": @"法规文献", @"subTitle": @"查询国内外法规，文献资料",@"image" : @"ff_IconShowLaw"};
    [discoverConfigureArray addObject:@[AlbumDictionary,shitDictionary,faDictionary]];
    
    NSDictionary *QRCodeDictionary = @{@"title": @"活动中心", @"subTitle": @"促销，活动",@"image" : @"ff_IconActivity"};
    NSDictionary *ShakeDictionary = @{@"title": @"品牌库",@"subTitle": @"实验室仪器，耗材品牌，正牌代理商", @"image" : @"ff_IconBrand"};
    NSDictionary *peiDictionary = @{@"title": @"培训信息", @"subTitle": @"实验室相关培训安排",@"image" : @"ff_IconTech"};
    [discoverConfigureArray addObject:@[QRCodeDictionary, ShakeDictionary,peiDictionary]];
    
    NSDictionary *LocationServiceDictionary = @{@"title": @"积分商城",@"subTitle": @"积分换大礼", @"image" : @"ff_IconScore"};
    NSDictionary *BottleDictionary = @{@"title": @"排行榜",@"subTitle": @"各路高手答题一较高下", @"image" : @"ff_IconRand"};
    [discoverConfigureArray addObject:@[LocationServiceDictionary, BottleDictionary]];
    
    return discoverConfigureArray;
}

- (NSMutableArray *)getContactConfigureArray {
    NSMutableArray *contacts = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= 26; i ++) {
        XHContact *contact = [[XHContact alloc] init];
        
        NSString *contactName;
        switch (i) {
            case 0:
                contactName = @"apple";
                break;
            case 1:
                contactName = @"bpple";
                break;
            case 2:
                contactName = @"cpple";
                break;
            case 3:
                contactName = @"dpple";
                break;
            case 4:
                contactName = @"epple";
                break;
            case 5:
                contactName = @"fpple";
                break;
            case 6:
                contactName = @"gpple";
                break;
            case 7:
                contactName = @"hpple";
                break;
            case 8:
                contactName = @"ipple";
                break;
            case 9:
                contactName = @"jpple";
                break;
            case 10:
                contactName = @"kpple";
                break;
            case 11:
                contactName = @"rpple";
                break;
            case 12:
                contactName = @"mpple";
                break;
            case 13:
                contactName = @"npple";
                break;
            case 14:
                contactName = @"opple";
                break;
            case 15:
                contactName = @"ppple";
                break;
            case 16:
                contactName = @"qpple";
                break;
            case 17:
                contactName = @"rpple";
                break;
            case 18:
                contactName = @"spple";
                break;
            case 19:
                contactName = @"tpple";
                break;
            case 20:
                contactName = @"upple";
                break;
            case 21:
                contactName = @"vpple";
                break;
            case 22:
                contactName = @"wpple";
                break;
            case 23:
                contactName = @"xpple";
                break;
            case 24:
                contactName = @"ypple";
                break;
            case 25:
                contactName = @"zpple";
                break;
            case 26:
                contactName = @"#pple";
                break;
            default:
                break;
        }
        
        contact.contactName = contactName;
        
        [contacts addObject:@[contact, contact]];
    }
    
    return contacts;
}

- (NSMutableArray *)getAlbumConfigureArray {
    NSMutableArray *albumConfigureArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 60; i ++) {
        XHAlbum *currnetAlbum = [[XHAlbum alloc] init];
        currnetAlbum.userName = @"Jack";
        currnetAlbum.profileAvatorUrlString = @"http://www.pailixiu.com/jack/meIcon@2x.png";
        currnetAlbum.albumShareContent = @"朋友圈分享内容，😗😗😗😗😗这里做图片加载，😗😗😗😗😗还是混排好呢？😜😜😜😜😜如果不混排，感觉CoreText派不上场啊！😄😄😄你说是不是？😗😗😗😗😗如果有混排的需要就更好了！😗😗😗😗😗";
        currnetAlbum.albumSharePhotos = [NSArray arrayWithObjects:@"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", @"http://www.pailixiu.com/jack/JieIcon@2x.png", nil];
        currnetAlbum.timestamp = [NSDate date];
        [albumConfigureArray addObject:currnetAlbum];
    }
    
    return albumConfigureArray;
}

- (NSMutableArray *)getProfileConfigureArray {
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSString *titleKey = @"title";
    NSString *subTitleKey = @"subTitle";
    NSString *imageKey = @"image";
    
    NSMutableDictionary *userInfoDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Jack", titleKey, @"15915895880", @"WeChatNumber", @"MeIcon", imageKey, nil];
    [profiles addObject:@[userInfoDictionary]];
    
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 6; i ++) {
        NSString *title;
        NSString *subTitle;
        NSString *imageName;
        switch (i) {
            case 0:
                title = @"我的提问";
                subTitle = @"";
                imageName = @"MyQuestion";
                break;
            case 1:
                title = @"我的回答";
                subTitle = @"";
                imageName = @"MyAnswer";
                break;
            case 2:
                title = @"粉丝求助";
                subTitle = @"";
                imageName = @"FansAskMy";
                break;
            case 3:
                title = @"追问";
                subTitle = @"";
                imageName = @"AskMy";
                break;
            case 4:
                title = @"我的收藏";
                subTitle = @"";
                imageName = @"CollectionMy";
                break;
            case 5:
                title = @"系统消息";
                subTitle = @"";
                imageName = @"SystemMsg";
                break;
            default:
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey,subTitle, subTitleKey, imageName, imageKey, nil];
        [rows addObject:sectionDictionary];
    }
     [profiles addObject:rows];
    NSMutableArray *rows1 = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 4; i ++) {
        NSString *title;
        NSString *subTitle;
        NSString *imageName;
        switch (i) {
            case 0:
                title = @"关注信息";
                subTitle = @"";
                imageName = @"MyMsg";
                break;
            case 1:
                title = @"我感兴趣的";
                subTitle = @"微生物，食品";
                imageName = @"MyFavorites";
                break;
            /*case 2:
                title = @"任务成就";
                subTitle = @"";
                imageName = @"MyBankCard";
                break;*/
            case 2:
                title = @"我的物品";
                subTitle = @"";
                imageName = @"MySomething";
                break;
            case 3:
                title = @"邀请好友";
                subTitle = @"";
                imageName = @"FansAskMy";
                break;
            default:
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey,subTitle, subTitleKey,  imageName, imageKey, nil];
        [rows1 addObject:sectionDictionary];
    }
    [profiles addObject:rows1];
    
    return profiles;
}

- (NSMutableArray *)getLocationServiceArray {
    NSMutableArray *locationServices = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < 20; i ++) {
        if (i % 2) {
            [locationServices addObject:@"杨仁捷"];
        } else {
            [locationServices addObject:@"吴盛潮"];
        }
    }
    
    return locationServices;
}

- (NSMutableArray *)getSettingConfigureArray {
    NSMutableArray *settings = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *titleKey = @"title";
    [settings addObject:@[@{titleKey: @"修改昵称"}, @{titleKey: @"实名认证"}, @{titleKey: @"修改密码"}]];
    [settings addObject:@[@{titleKey: @"分享给朋友们"}]];
//    [settings addObject:@[@{titleKey: @"绑定手机号"}]];
//    [settings addObject:@[@{titleKey: @"关于软件"}, @{titleKey: @"帮助"}, @{titleKey: @"检查新版本"},@{titleKey: @"退出帐号"}]];
        [settings addObject:@[@{titleKey: @"关于软件"}, @{titleKey: @"帮助"},@{titleKey: @"退出帐号"}]];
    return settings;
}

@end
