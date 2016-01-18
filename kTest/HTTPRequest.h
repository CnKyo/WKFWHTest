//
//  HTTPRequest.h
//  kTest
//
//  Created by wangke on 16/1/6.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "AFURLResponseSerialization.h"

@class mBaseModel;

@interface HTTPRequest : AFHTTPRequestOperationManager
///初始化方法
+ (HTTPRequest *)HttpRequest;
///get请求
- (void)getUrl:(NSString *)URLString andParameters:(id)parameters block:(void(^)(mBaseModel *dic))block;
///post请求
- (void)postUrl:(NSString *)URLString andParameters:(id)parameters block:(void(^)(mBaseModel *dic))block;
///取消操作
- (void)cancelHTTPOperation:(AFHTTPRequestOperation *)http;
///获取token
- (NSString *)getToken;
///获取userid
- (NSString *)getUserId;
///获取appname
+ (NSString *)getAppName;
///获取组建webvc的url
+ (NSString *)getWebUrl;
///获取app的appscheme
+ (NSString *)getAppScheme;
@end
