//
//  PFShareRegisterApp.m
//  PFShareKit
//
//  Created by PFei_He on 14-7-2.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFShareRegisterApp.h"

@implementation PFShareRegisterApp

@synthesize SinaWeiboAppKey = _SinaWeiboAppKey;
@synthesize SinaWeiboAppSecret = _SinaWeiboAppSecret;
@synthesize SinaWeiboAppRedirectURI = _SinaWeiboAppRedirectURI;

@synthesize TencentWeiboAppKey = _TencentWeiboAppKey;
@synthesize TencentWeiboAppSecret = _TencentWeiboAppSecret;
@synthesize TencentWeiboAppRedirectURI = _TencentWeiboAppRedirectURI;

@synthesize QzoneAppKey = _QzoneAppKey;
@synthesize QzoneAppSecret = _QzoneAppSecret;
@synthesize QzoneAppRedirectURI = _QzoneAppRedirectURI;

@synthesize WeChatAppKey = _WeChatAppKey;
@synthesize WeChatAppSecret = _WeChatAppSecret;
@synthesize WeChatAppRedirectURI = _WeChatAppRedirectURI;

@synthesize QQAppKey = _QQAppKey;
@synthesize QQAppSecret = _QQAppSecret;
@synthesize QQAppRedirectURI = _QQAppRedirectURI;

@synthesize DoubanBroadAppKey = _DoubanBroadAppKey;
@synthesize DoubanBroadAppSecret = _DoubanBroadAppSecret;
@synthesize DoubanBroadAppRedirectURI = _DoubanBroadAppRedirectURI;

@synthesize RenrenBroadAppID = _RenrenBroadAppID;
@synthesize RenrenBroadAppKey = _RenrenBroadAppKey;
@synthesize RenrenBroadAppSecret = _RenrenBroadAppSecret;
@synthesize RenrenBroadAppRedirectURI = _RenrenBroadAppRedirectURI;

+ (void)registerWithSinaWeiboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.SinaWeiboAppKey = appKey;
    app.SinaWeiboAppSecret = appSecret;
    app.SinaWeiboAppRedirectURI = appRedirectURI;
}

+ (void)registerWithTencentWeiboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.SinaWeiboAppKey = appKey;
    app.SinaWeiboAppSecret = appSecret;
    app.SinaWeiboAppRedirectURI = appRedirectURI;
}

+ (void)registerWithQzoneAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.SinaWeiboAppKey = appKey;
    app.SinaWeiboAppSecret = appSecret;
    app.SinaWeiboAppRedirectURI = appRedirectURI;
}

+ (void)registerWithWeChatAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.SinaWeiboAppKey = appKey;
    app.SinaWeiboAppSecret = appSecret;
    app.SinaWeiboAppRedirectURI = appRedirectURI;
}

+ (void)registerWithQQAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.QQAppKey = appKey;
    app.QQAppSecret = appSecret;
    app.QQAppRedirectURI = appRedirectURI;
}

+ (void)registerWithDoubanboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.DoubanBroadAppKey = appKey;
    app.DoubanBroadAppSecret = appSecret;
    app.DoubanBroadAppRedirectURI = appRedirectURI;
}

+ (void)registerWithRenrenboAppID:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI
{
    PFShareRegisterApp *app = [[self alloc] init];
    app.RenrenBroadAppID = appID;
    app.RenrenBroadAppKey = appKey;
    app.RenrenBroadAppSecret = appSecret;
    app.RenrenBroadAppRedirectURI = appRedirectURI;
}

@end
