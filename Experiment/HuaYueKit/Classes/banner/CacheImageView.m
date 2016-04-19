//
//  CacheImageView.m
//  cacheView
//
//  Created by 潘鸿吉 on 13-3-12.
//  Copyright (c) 2013年 潘鸿吉. All rights reserved.
//

#import "CacheImageView.h"

@implementation CacheImageView

@synthesize delegate;

#pragma mark - dealloc
-(void)dealloc
{
    
}

#pragma - init
- (id) initWithImage : (UIImage*) _image Frame : (CGRect) _frame
{
    self = [super initWithFrame:_frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setImage:_image];
        aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [aiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [aiView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [self addSubview:aiView];
    }
    return self;
}

#pragma mark - getImageFromURL
- (void) getImageFromURL:(NSURL *) _url{
    if (!aiView) {
        aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [aiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [aiView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [self addSubview:aiView];
    }
    
    [aiView startAnimating];
    
    
    url = _url;
    if ([self isHaveImage]) {
        [delegate cacheImageViewDidFinishLoading:url];
        return;
    }
    
//    NSLog(@"%@",[_url absoluteString]);
    
    NSURLRequest* request = [NSURLRequest requestWithURL:_url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:45.0];
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request delegate:self];
  
}

#pragma mark - NSURLConnectionDelagete
- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (!data) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    if (incrementalData) {
//        NSLog(@"%i %i",[data length],[incrementalData length]);
        [data appendData:incrementalData];
    }
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"cache_error : %@" , error);
    [aiView stopAnimating];
    [aiView removeFromSuperview];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	UIImage* dataImage = [UIImage imageWithData:data];
    if (dataImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //        [self setImage:[UIImage imageNamed:@"icon.png"]];
            [self setImage:dataImage];
        });
    }
    [self saveImage];
    
    [aiView stopAnimating];
    [aiView removeFromSuperview];
}

#pragma mark - saveImage
- (void)saveImage{
    
    NSDictionary *saveDic = [self getSaveDictionary];
    if (saveDic) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:[self generatImageName]];

        [data writeToFile:imagePath atomically:YES];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:saveDic];
        [dict setObject:imagePath forKey:[url absoluteString]];
        [self saveDictionary:dict];
    }else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [cachesDirectory stringByAppendingPathComponent:[self generatImageName]];
        
        [data writeToFile:imagePath atomically:YES];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:imagePath forKey:[url absoluteString]];
        [self saveDictionary:dict];
    }
    [delegate cacheImageViewDidFinishLoading:url];
}

- (NSDictionary*) getSaveDictionary{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:@"CacheImageDic.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }
    NSLog(@"创建plist");
    return nil;
}

- (void) saveDictionary : (NSMutableDictionary *)_dic{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:@"CacheImageDic.plist"];
    [_dic writeToFile:path atomically:YES];
    NSLog(@"保存到plist");
}

#pragma mark 生成图片名
- (NSString*)generatImageName{
    NSDate *date = [[NSDate alloc]init];
    NSDateFormatter *fat = [[NSDateFormatter alloc]init];
    [fat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString =  [fat stringFromDate:date];
    
    int number = arc4random() % 899 +100;
    NSString *string = [[NSString alloc] initWithFormat:@"_%d",number];
    
    NSMutableString *randomName = [NSMutableString stringWithString:dateString];
    [randomName appendString:string];
    
    return randomName;
}

#pragma mark 判断图片是否存在
- (BOOL)isHaveImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDirectory stringByAppendingPathComponent:@"CacheImageDic.plist"];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return NO;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *imagePath = [dict objectForKey:[url absoluteString]];
    if (imagePath != nil) {
        
        data = [[NSMutableData alloc] initWithContentsOfFile:imagePath];
		UIImage* dataImage = [UIImage imageWithData:data];
        if (dataImage) {
            [self setImage:dataImage];
            
//            [self setNeedsLayout];
            
            [aiView stopAnimating];
            [aiView removeFromSuperview];
            return YES;
        }
        
        
    }
    
    return NO;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    callBack();
}
-(void)imageClickWithIndex:(block)db
{
   
    callBack=[db copy];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
