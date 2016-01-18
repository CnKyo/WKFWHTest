//
//  HTTPRequest.m
//  kTest
//
//  Created by wangke on 16/1/6.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "HTTPRequest.h"

#import "Model.h"
static  NSString *const HTTPRequestUrlString = @"http://api.fwh1988.com/staff/v1/";

@interface HTTPRequest()

@end

@implementation HTTPRequest

+ (instancetype)HttpRequest{
    static HTTPRequest *request = nil;
    static dispatch_once_t onecrToken;
    
    dispatch_once(&onecrToken,^{
        request = [[HTTPRequest alloc] initWithBaseURL:[NSURL URLWithString:HTTPRequestUrlString]];
        request.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    });
    
    request.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8",@"text/plain",@"application/json", nil];
    request.requestSerializer.timeoutInterval = 5;
    return request;
}
- (NSString *)getToken{

    if ([mUser backNowUser].mToken.length == 0) {
        return [mAppInfo initAppInfo].mGToken;
    }
    return [mUser backNowUser].mToken;
}
- (NSString *)getUserId{
    if ( [mUser backNowUser].mUserId ) {
        return [NSString stringWithFormat:@"%d",[mUser backNowUser].mUserId];
    }
    return nil;
}
- (void)getUrl:(NSString *)URLString andParameters:(id)parameters block:(void (^)(mBaseModel *))block{

    NSMutableDictionary *mParameter  = [NSMutableDictionary new];
    
    if ([self getToken].length == 0) {
        ///如果初始化接口没有返回token就返回固定错误
        if ( ![URLString isEqualToString:@"app.init"]) {
            
            mBaseModel  *mBaseData = [mBaseModel infoWithError:@"获取配置信息错误，正在重新获取！"];
            block( mBaseData );
            return;
        }
    }else{
        [mParameter setObject:[self getToken] forKey:@"token"];
    }
    if ([self getUserId].length == 0) {
        [mParameter setObject:[self getUserId] forKey:@"staffId"];
    }
    
    if ( parameters ) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString    *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [mParameter setObject:str forKey:@"data"];
    }
    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        mBaseModel  *model = [[mBaseModel alloc]initWithObj:responseObject];
        
        if (model.mCode == 99996) {
            ///需要登录
            [((AppDelegate*)[UIApplication sharedApplication].delegate) performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.4];
        }
        
        block( model );
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block( [mBaseModel infoWithError:@"网络请求错误"] );
        
    }];
    
}

- (void)postUrl:(NSString *)URLString andParameters:(id)parameters block:(void (^)(mBaseModel *))block{
    BOOL    isInit = [URLString isEqualToString:@"app.init"];
    NSString    *token = [self getToken];
    
    NSMutableDictionary *mParameter = [NSMutableDictionary new];
    
    if (token.length == 0) {
        ///如果没有token就返回特点的错误
        if ( !isInit ) {
            mBaseModel *model = [mBaseModel infoWithError:@"获取配置信息错误，正在重新获取!"];
            block ( model );
            return;
        }
    }
    else{
        [mParameter setObject:token forKey:@"token"];
    }
    
    if ( [self getUserId].length  ) {
        [mParameter setObject:[self getUserId] forKey:@"staffId"];
    }
    lll(@"接口：%@,参数：%@",URLString,parameters);
    if ( parameters ) {
        
        NSData  *data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
        NSString    *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
#ifdef ENC
        

        
#endif
        [mParameter setObject:str forKey:@"data"];
    }
        [self POST:URLString parameters:mParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
#ifdef ENC
            
#endif
            
            mBaseModel  *model = [[mBaseModel alloc]initWithObj:responseObject];
            
            if (model.mCode == 99996) {
                ///需要登录
                [((AppDelegate*)[UIApplication sharedApplication].delegate) performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.4];

            }
            block ( model );
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络请求错误！"];
            lll(@"---------错误信息：\n%@",error);
            block ( [mBaseModel infoWithError:@"网络请求错误！"] );
            
            
        }];
    
}
- (void)cancelHTTPOperation:(AFHTTPRequestOperation *)http{
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        if ([operation isEqual:http]) {
            [operation cancel];
            break;
        }
    }
}
+ (NSString *)getAppName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);//直接打印数据。
    NSString *ss = [data objectForKey:@"CFBundleName"];
    return ss;
}
+ (NSString *)getAppScheme{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);//直接打印数据。
    
    NSString *ss = nil;
    
    for (NSDictionary *dic in [data objectForKey:@"CFBundleURLTypes"]) {
        
       ss = [dic objectForKey:@"CFBundleURLSchemes"];
    }
    
    return ss;
}
@end
