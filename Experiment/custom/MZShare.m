//
//  MZShare.m
//  HuaYue
//  分享
//  Created by 崔俊红 on 15/5/26.
//  Copyright (c) 2015年 麦子收割队. All rights reserved.
//

#import "MZShare.h"
#import "UMSocial.h"
#import "BMUtils.h"
#import "UMSocialWechatHandler.h"

@interface MZShare ()<UMSocialUIDelegate>
@property (nonatomic,strong)NSString *pn;
@property (nonatomic,strong)share_block mBlock;
@end

@implementation MZShare

+ (instancetype)shared
{
    static MZShare *__singleInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singleInstance = [[MZShare alloc]init];
    });
    return __singleInstance;
}

- (void)shareInVC:(UIViewController*)vc title:(NSString*)title image:(UIImage *)image url:(NSString*)url block:(share_block)block
{
    self.mBlock = block;
    UMSocialData *socialData = [UMSocialData defaultData];
    socialData.extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    socialData.extConfig.wechatSessionData.snsName = @"实验助手";
    socialData.extConfig.wechatTimelineData.snsName = @"实验助手";
    socialData.extConfig.sinaData.snsName = @"实验助手";
    socialData.extConfig.wechatSessionData.title = @"实验助手";
    socialData.extConfig.wechatTimelineData.title = title;
    socialData.extConfig.wechatSessionData.url = url;
    socialData.extConfig.wechatTimelineData.url = url;
    socialData.extConfig.qzoneData.title = title;
    socialData.extConfig.qqData.title = @"实验助手";
    socialData.extConfig.qqData.url = url;
    socialData.extConfig.qzoneData.url = url;
//    socialData.extConfig.
    socialData.title = title;
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:@"54b9aefefd98c5f227000907"
                                      shareText:title
                                     shareImage:image
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ]
                                       delegate:self];
}

- (void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    self.pn = platformName;
    if (platformName == UMShareToSina) {//新浪微博
        [UMSocialData defaultData].extConfig.sinaData.shareText = [socialData.shareText stringByAppendingString:socialData.extConfig.wechatSessionData.url];
        DLog(@"%@",[UMSocialData defaultData].extConfig.sinaData.shareText);
    } else if(platformName == UMShareToWechatSession ){//微信好友
        
    } else if(platformName == UMShareToWechatTimeline){//微信圈
        
    } else if (platformName == UMShareToQQ){//qq
        
    } else if (platformName == UMShareToQzone){//qq空间
        
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        [BMUtils showSuccess:@"分享成功"];
        NSInteger flag = 0;
        if (self.pn == UMShareToSina) {//新浪微博
            flag = 1;
        } else if(self.pn == UMShareToWechatSession ){//微信好友
            flag = 2;
        } else if(self.pn == UMShareToWechatTimeline){//微信圈
            flag = 3;
        } else if (self.pn == UMShareToQQ){
            flag = 4;
        } else if (self.pn == UMShareToQzone){
            flag = 5;
        }
        if (self.mBlock) {
            self.mBlock(flag);
        }
    }
}

@end
