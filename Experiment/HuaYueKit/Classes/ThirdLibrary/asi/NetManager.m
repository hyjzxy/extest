;//
//  NetManager.m
//  RongYi
//
//  Created by wen yu on 13-5-23.
//  Copyright (c) 2013年 bluemobi. All rights reserved.
//


#import "NetManager.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJsonParser.h"
#import "NSString+EncodingUTF8Additions.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "BMUtils.h"
#import "BMXinCaiFu.h"
#import "NSString+EncodingUTF8Additions.h"
#import "DesEncrypt.h"
#import "WYPlist.h"
#import "NSObject+Cate.h"
#define TIME_OUT 30

static NetManager *_manager;

@implementation NetManager

-(void)dealloc
{
    [_manager release];
    [super dealloc];
}

#pragma mark - 获取单例
+ (id)sharedManager
{
    if (!_manager)
    {
        _manager = [[NetManager alloc] init];
    }
    return _manager;
}

- (id)processNull:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (id key in [(NSDictionary*)obj allKeys]) {
            [dict setObject:[self processNull:[obj objectForKey:key]] forKey:key];
        }
        NSDictionary *returnDict = [NSDictionary dictionaryWithDictionary:dict];
        [returnDict setInfo:@{@"maxid":N2V(((NSObject*)obj).info[@"maxid"],@-1)}];
        [dict release];
        return returnDict;
    }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]]){
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (id o in (NSArray*)obj) {[array addObject:[self processNull:o]];}
        NSArray *returnArray = [NSArray arrayWithArray:array];
        [returnArray setInfo:@{@"maxid":N2V(((NSObject*)obj).info[@"maxid"],@-1)}];
        [array release];
        return returnArray;
    }else if([obj isKindOfClass:[NSNull class]]){
        return @"";
    }
    return obj;
}

#pragma mark - post请求入口

+ (BOOL)isNetHost:(NSString*)host
{
    NSString *aHost = [host stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    return [Reachability reachabilityWithHostName:aHost].currentReachabilityStatus != kNotReachable;
}

+ (BOOL)isNetAlive
{
    return [Reachability reachabilityForLocalWiFi].currentReachabilityStatus!=kNotReachable||[Reachability reachabilityForInternetConnection].currentReachabilityStatus!=kNotReachable;
}

- (void)postRequestWithUrlString:(NSString*)urlString
                             api:(NSString*)api
                     postParamDic:(NSDictionary*)postParamDic
                          success:(void (^)(id responseDic))success
                          failure:(void(^)(id errorString))failure
{
    printf("----------------------------------------------------------------------\n");

    NSLog(@"url:%@",urlString);
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
//          [MBProgressHUD hideHUDForView:appDele.window animated:YES];
//          [MBProgressHUD showHUDAddedTo:appDele.window animated:YES];
      });
    
    urlString = [BMUtils getEncodingWithUTF8:urlString];
    //DLog(@"<<<<<<<<<<<urlString%@", urlString);
    __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:postParamDic options:NSJSONWritingPrettyPrinted error:nil];
    
    [request appendPostData:data];
    [request setTimeOutSeconds:TIME_OUT];
    
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    
    DLog(@"\n我的请求数据==%@\n我的请求接口==%@\n我的接口名字==%@\n",postParamDic,request.url,api);
    
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:appDele.window animated:YES];
        });
        if (request.responseString.length == 0) {
            return ;
        }
        //DLog(@"completion : %@" ,request.responseString);
        NSUInteger location = [request.responseString rangeOfString:@"{"].location;
        NSUInteger length = [request.responseString length] - location;
        NSRange range = NSMakeRange(location, length);
        
        NSString *resoponse = nil;
        if ([request.responseString length] > 0) {
            resoponse = [request.responseString substringWithRange:range];
        }
        
        [request clearDelegatesAndCancel];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSError *error = nil;
        
        NSMutableDictionary *responseDic = [jsonParser objectWithString:resoponse error:&error];
        
        [jsonParser release];
        //DLog(@"error = %@",error);
        if (error)
        {
            failure?failure([error localizedDescription]):NULL;
            return ;
        }
        
        if (responseDic == nil)
        {
            NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"网络连接出错",NSLocalizedDescriptionKey, nil];
            NSError *customError=[NSError errorWithDomain:@"DuiDuiLa" code:500 userInfo:userInfo];
            failure?failure(customError):NULL;
        }
        else
        {
            NSLog(@"response:%@",responseDic);
            printf("-------------------------------------------------------------------------\n");
            int status=[[responseDic objectForKey:@"code"] intValue];
            if (status == 88)
            {
                //请求成功
                if ([responseDic.allKeys containsObject:@"data"]) {
                    NSError *error = nil;
                    NSObject *responseDic1 = nil;
                    if ([responseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
                        responseDic1 = responseDic[@"data"];
                    }else{
                        responseDic1 = [NSJSONSerialization JSONObjectWithData:[responseDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                    }
                    
                    NSNumber *lastid = @([N2V(responseDic[@"lastid"], @0) integerValue]);
                    [responseDic1 setInfo:@{@"maxid":N2V(lastid, @-1)}];
                    //DLog(@"我的返回数据 : \n %@" ,responseDic1);
                    success?success([self processNull:responseDic1]):NULL;
                }else{
                    success?success([self processNull:nil]):NULL;
                }
            }
            else
            {
                //请求失败
                NSString *resultString = [responseDic objectForKey:@"desc"];
                //NSLog(@"=== %@",resultString);
                
                NSDictionary *dic = [WYPlist userDefault];
                
                NSString *retError = [dic  objectForKey:WYISBLANK(resultString)];
                
                //DLog(@"=== %@",retError);
                failure?failure(resultString):NULL;
            }
        }
        [request release];
    }];
    [request setFailedBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:appDele.window animated:YES];
        });
        
        [request clearDelegatesAndCancel];
        NSString *errorMsg = @"网络连接失败，请重新加载";
        failure?failure(errorMsg):NULL;
        [request release];
    }];

}

- (void)formRequestWithUrlString:(NSString*)urlString
                    postParamDic:(NSDictionary*)postParamDic
                         success:(void (^)(id responseDic))success
                         failure:(void(^)(id errorString))failure
{
    /*
    NSLog(@"postParamDic____%@",postParamDic);
    NSLog(@"____%@",urlString);*/
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:appDele.window animated:YES];
        [MBProgressHUD showHUDAddedTo:appDele.window animated:YES];
    });

    urlString = [BMUtils getEncodingWithUTF8:urlString];
    __block ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setUseCookiePersistence:NO];
    
    
    for (NSString *keyString in [postParamDic allKeys])
    {
        if ([keyString isEqualToString:@"CompanyImg"] || [keyString isEqualToString:@"HeadImg"] || [keyString isEqualToString:@"ArticleImages"] || [keyString isEqualToString:@"imag"] || [keyString isEqualToString:@"yuy"]||[keyString isEqualToString:@"RectImages"]||[keyString isEqualToString:@"SquarImages"]|| [keyString isEqualToString:@"imageUrlString"]||[keyString isEqualToString:@"file"]||[keyString isEqualToString:@"file1"]||[keyString isEqualToString:@"file2"]||
            [keyString isEqualToString:@"Images1"]||[keyString isEqualToString:@"Images2"]||[keyString isEqualToString:@"Images3"]||[keyString isEqualToString:@"Images4"]|| [keyString isEqualToString:@"images"]||[keyString isEqualToString:@"image"])
        {
            NSString *imgPath = [NSString stringWithFormat:@"%@",[postParamDic objectForKey:keyString]];
            if (imgPath.length > 0) {
                [request addFile:imgPath forKey:keyString];
            }
        }
        else
        {
            NSString *paraString = [NSString stringWithFormat:@"%@",[postParamDic objectForKey:keyString]];
            [request setPostValue:paraString forKey:keyString];
            
        }
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"application/json; charset=utf-8" forKey:@"Content-Type"];
    [request setRequestHeaders:dic];
    [request setRequestMethod:@"POST"];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIME_OUT];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
         [MBProgressHUD hideHUDForView:appDele.window animated:YES];
        });
        //NSLog(@"<><><><> %@",request.responseString);
        if (request.responseString.length == 0) {
            return ;
        }
        NSUInteger location = [request.responseString rangeOfString:@"{"].location;
        NSLog(@"responseDic %@",request.responseString);
        NSUInteger length = [request.responseString length] - location;
        NSRange range = NSMakeRange(location, length);
        NSString *resoponseBefore = [request.responseString substringWithRange:range];
        NSString * resoponseAfter = [BMUtils getPercentEscapesWithUTF8:resoponseBefore];
        
        [request clearDelegatesAndCancel];
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        NSError *error = nil;
        NSString * resoponse = @"";
        if (resoponseAfter == nil) {
            resoponse = resoponseBefore;
        }else{
            resoponse = resoponseAfter;
        }
        NSMutableDictionary *responseDic = [jsonParser objectWithString:resoponse error:&error];
        [jsonParser release];
        if (error)
        {
            failure([error localizedDescription]);
            return ;
        }
        if (responseDic == nil)
        {
            NSDictionary *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"网络连接出错",NSLocalizedDescriptionKey, nil];
            NSError *customError=[NSError errorWithDomain:@"DuiDuiLa" code:500 userInfo:userInfo];
            failure(customError);
        }
        else
        {
            int status=[[responseDic objectForKey:@"code"] intValue];
            if (status == 88)
            {
                //请求成功
                //防null
                success([self processNull:responseDic]);
            }
            else
            {
                //请求失败
                NSString *resultString=[responseDic objectForKey:@"desc"];
                failure(resultString);
            }
        }
        [request release];
    }];
    [request setFailedBlock:^{
        //NSLog(@"completion : %@" , request.responseString);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:appDele.window animated:YES];
        });
        
        [request clearDelegatesAndCancel];
        NSString *errorMsg = @"网络连接失败，请重新加载";
        
        failure(errorMsg);
        
        [request release];
    }];
    
}

-(void)myRequestParam:(NSMutableDictionary *)param withUrl:(NSString *)url withType:(NSString *)type
              success:(void (^)(id responseObject))success
              failure:(void (^)(id errorString))failure{
    if(![NetManager isNetAlive]){
        [BMUtils showError:@"请检查网络"];
        if (failure) {failure(@"请检查网络"); }
        return;
    }else {
        [self postRequestWithUrlString:url api:type postParamDic:param success:success failure:failure];
    }
}

- (void)updateimage:(NSMutableDictionary *)param withUrl:(NSString *)url withType:(NSString *)type withImage:(UIImage *)senderImage success:(void (^)(id))success failure:(void (^)(id))failure{
    if(![NetManager isNetAlive]){
        [BMUtils showError:@"请检查网络"];
        return;
    }
    UIImage* uplodeimage=senderImage;//[UIImage imageNamed:@"10.jpg"];
    NSData *data = UIImagePNGRepresentation(uplodeimage);//获取图片数据
    NSURL *url1 = [NSURL URLWithString:url];
    
    NSMutableData *imageData = [NSMutableData dataWithData:data];
    ASIFormDataRequest *aRequest = [[ASIFormDataRequest alloc] initWithURL:url1];
    [aRequest setDelegate:self];//代理
    [aRequest setRequestMethod:@"POST"];
//    [aRequest setPostBody:imageData];
    [ aRequest addData:imageData withFileName:[param objectForKey:@"name"] andContentType:@"image/jpeg" forKey:@"upload"];
    [aRequest addRequestHeader:@"Content-Type" value:@"file"];//这里的value值 需与服务器端 一致
    [aRequest startAsynchronous];//开始。异步

}


- (void)uploadImage:(UIImage *)sendImage
            success:(void (^)(id responseObject))success
            failure:(void (^)(id errorString))failure
{
    if(![NetManager isNetAlive]){
        [BMUtils showError:@"请检查网络"];
        return;
    }
    UIImage* uplodeimage=sendImage;//[UIImage imageNamed:@"10.jpg"];
    NSData *data = UIImagePNGRepresentation(uplodeimage);//获取图片数据
    NSString *url =  [IMAGE_ADDRESS stringByAppendingString:@"/index.php/api/member/uploadimg"];
    
    NSURL *url1 = [NSURL URLWithString:url];
    
    NSMutableData *imageData = [NSMutableData dataWithData:data];
    ASIFormDataRequest *aRequest = [[ASIFormDataRequest alloc] initWithURL:url1];
    //[aRequest setDelegate:self];//代理
    [aRequest setRequestMethod:@"POST"];
    
    [aRequest addData:imageData withFileName:@"image.png" andContentType:@"image/png" forKey:@"fileField"];
    [aRequest addRequestHeader:@"Content-Type" value:@"file"];//这里的value值 需与服务器端 一致
    [aRequest startAsynchronous];//开始。异步
    
    [aRequest setCompletionBlock:^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:aRequest.responseData options:NSJSONReadingMutableLeaves error:nil];
        success(dict);
    }];
    
    [aRequest setFailedBlock:^{
        
        [aRequest clearDelegatesAndCancel];
        NSString *errorMsg = @"网络连接失败，请重新加载";
        
        failure(errorMsg);
        
        [aRequest release];
    }];
    
}


@end