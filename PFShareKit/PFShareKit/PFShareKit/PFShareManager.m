//
//  PFShareManager.m
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

/*
 *声明

 *此项目名称为：PFShareKit（以下简称本项目）。

 *本项目为开源项目，允许各位使用者转载，修改，更新，传播。 目的是为开发者提供一个快捷
 方便的分享功能，以提高开发效率，减少开发者在分享方面的开发时间和开发成本。

 *本项目旨在反对一切以提供分享功能为目的，却不分享源码，并在包中插入各种监听，跟踪的行
 为而诞生的。
 
 *本项目尊重一切开发者的合法权益，如项目中出现一切侵犯或影响到相关利益的行为，请告知。
 
 *本项目所有权为参与项目开发和维护的每一位贡献者共同所有。

 *本项目仍然处于优化和完善阶段，后续会继续进行。如有志同道合的朋友请与作者联系。如需交
 流讨论，欢迎添加QQ：498130877。谢谢！

 本软件为版权所有人和贡献者“按现状”为根据提供，不提供任何明确或暗示的保证，包括但不限于
 本软件针对特定用途的可售性及适用性的暗示保证。在任何情况下，版权所有人或其贡献者均不对
 因使用本软件而以任何方式产生的任何直接、间接、偶然、特殊、典型或因此而生的损失（包括但
 不限于采购替换产品或服务；使用价值、数据或利润的损失；或业务中断）而根据任何责任理论，
 包括合同、严格责任或侵权行为（包括疏忽或其他）承担任何责任，即使在已经提醒可能发生此类
 损失的情况下。
 */

#import "PFShareManager.h"
#import "PFShareConstants.h"
#import "PFShareRegisterApp.h"

@interface PFShareManager ()
{
//    PFShareTarget       shareTarget;            //分享的目标
    PFShareManager      *sharedInstance;         //分享的实例

    NSString            *userIDKey;             //用户ID
    NSString            *accessTokenKey;           //访问令牌
    NSDate              *expirationDateKey;        //请求的期限

//    NSString            *appKey;
//    NSString            *appSecret;
//    NSString            *appRedirectURI;
//    NSString            *ssoCallbackSheme;      //返回的App的Url地址

//    PFShareRequest      *request;
    NSMutableSet        *requestSet;
    BOOL                ssoLoggingIn;           //判断是否已经登陆
}

@end

@implementation PFShareManager

@synthesize userID = _userID;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize refreshToken = _refreshToken;
@synthesize ssoCallbackScheme = _ssoCallbackScheme;
@synthesize delegate = _delegate;
@synthesize appID = _appID;
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appRedirectURI = _appRedirectURI;
@synthesize request = _request;
@synthesize target = _target;
@synthesize title;
@synthesize url = _url;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params;
@synthesize description = _description;
@synthesize thumbData = _thumbData;

#pragma mark - Data Management Methods

//分享目标的单例
+ (id)sharedInstanceWithTarget:(PFShareTarget)target
{
    static PFShareManager *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    sharedInstance.target = target;
    [sharedInstance getAuthorizeData];
    return sharedInstance;
}

//获取认证数据
- (void)getAuthorizeData
{
    NSDictionary *shareAuthorizeInfo;
    PFShareRegisterApp *app;
    if (self.target == PFShareTargetSinaWeibo)
    {//新浪微博
        self.appKey = app.SinaWeiboAppKey;
        self.appSecret = app.SinaWeiboAppSecret;
        self.appRedirectURI = app.SinaWeiboAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-SinaWeibo"];
    }
    else if (self.target == PFShareTargetTencentWeibo)
    {//腾讯微博
        self.appKey = app.TencentWeiboAppKey;
        self.appSecret = app.TencentWeiboAppSecret;
        self.appRedirectURI = app.TencentWeiboAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-TencentWeibo"];
    }
    else if (self.target == PFShareTargetQzone)
    {//QQ空间
        self.appKey = app.QzoneAppKey;
        self.appSecret = app.QzoneAppSecret;
        self.appRedirectURI = app.QzoneAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-Qzone"];
    }
    else if (self.target == PFShareTargetWeChatTimeline)
    {//朋友圈
        self.appKey = app.WeChatAppKey;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-WeChatTimeline"];
    }
    else if (self.target == PFShareTargetWeChatSession)
    {//微信
        self.appKey = app.WeChatAppKey;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-WeChatSession"];
    }
    else if (self.target == PFShareTargetQQ)
    {//QQ
        self.appKey = app.QQAppKey;
        self.appSecret = app.QQAppSecret;
        self.appRedirectURI = app.QQAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-QQ"];
    }
    else if (self.target == PFShareTargetDouban)
    {//豆瓣
        self.appKey = app.DoubanBroadAppKey;
        self.appSecret = app.DoubanBroadAppSecret;
        self.appRedirectURI = app.DoubanBroadAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-Douban"];
    }
    else
    {//人人
        self.appID = app.RenrenBroadAppID;
        self.appKey = app.RenrenBroadAppKey;
        self.appSecret = app.RenrenBroadAppSecret;
        self.appRedirectURI = app.RenrenBroadAppRedirectURI;
        shareAuthorizeInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"PFShareAuthData-Renren"];
    }
    
    if ([shareAuthorizeInfo objectForKey:@"AccessTokenKey"] && [shareAuthorizeInfo objectForKey:@"ExpirationDateKey"] && [shareAuthorizeInfo objectForKey:@"UserIDKey"])
    {
        userIDKey = [shareAuthorizeInfo objectForKey:@"UserIDKey"];
        accessTokenKey = [shareAuthorizeInfo objectForKey:@"AccessTokenKey"];
        expirationDateKey = [shareAuthorizeInfo objectForKey:@"ExpirationDateKey"];
    }
    else
    {
        userIDKey = nil;
        accessTokenKey = nil;
        expirationDateKey = nil;
    }
}

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<PFShareDelegate>)delegate
{
    self.appKey = appKey;
    self.appSecret = appSecret;
    self.appRedirectURI = appRedirectURI;
    self.delegate = delegate;

    return [self initWithAppKey:self.appKey
                      appSecret:self.appSecret
                 appRedirectURI:self.appRedirectURI
              ssoCallbackScheme:nil
                    andDelegate:self.delegate];
}

- (id)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<PFShareDelegate>)delegate
{
    if ((self = [super init]))
    {
        self.appKey = appKey;
        self.appSecret = appSecret;
        self.appRedirectURI = appRedirectURI;
        self.delegate = delegate;
        
        if (!ssoCallbackScheme) {
            ssoCallbackScheme = [NSString stringWithFormat:@"PFShareSSO.%@://", self.appKey];
        }
        self.ssoCallbackScheme = ssoCallbackScheme;
        
        requestSet = [[NSMutableSet alloc] init];
    }
    return self;
}

//存储认证数据
- (void)storeAuthorizeData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              userIDKey, @"UserIDKey",
                              accessTokenKey, @"AccessTokenKey",
                              expirationDateKey, @"ExpirationDateKey",
                              self.refreshToken, @"refresh_token", nil];
    
    if(self.target == PFShareTargetSinaWeibo) {//新浪微博
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-SinaWeibo"];
    }
    else if(self.target == PFShareTargetTencentWeibo) {//腾讯微博
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-TencentWeibo"];
    }
    else if (self.target == PFShareTargetQzone) {//QQ空间
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Qzone"];
    }
    else if (self.target == PFShareTargetWeChatTimeline) {//微信朋友圈
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Timeline"];
    }
    else if (self.target == PFShareTargetWeChatSession) {//微信会话
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-WeChat"];
    }
    else if (self.target == PFShareTargetQQ) {//QQ
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-QQ"];
    }
    else if(self.target == PFShareTargetDouban) {//豆瓣
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Douban"];
    }
    else if(self.target == PFShareTargetRenren) {//人人
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"PFShareAuthData-Renren"];
    }
    //同步用户数据
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//移除认证数据
- (void)removeAuthorizeData
{
    self.accessToken = nil;
    self.userID = nil;
    self.expirationDate = nil;
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSString *url;
    if(self.target == PFShareTargetSinaWeibo) {//新浪微博
        url = @"https://open.weibo.cn";
    }
    else if(self.target == PFShareTargetTencentWeibo) {//腾讯微博
        url = @"https://open.t.qq.com";
    }
    else if(self.target == PFShareTargetDouban) {//豆瓣
        url = @"https://www.douban.com";
    }
    else if(self.target == PFShareTargetRenren) {//人人
        url = @"https://graph.renren.com";
    }
    
    NSArray* PFShareCookies = [cookies cookiesForURL:
                               [NSURL URLWithString:url]];
    
    for (NSHTTPCookie *cookie in PFShareCookies) {
        [cookies deleteCookie:cookie];
    }

    if(self.target == PFShareTargetSinaWeibo) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-SinaWeibo"];
    }
    else if (self.target == PFShareTargetTencentWeibo) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-TencentWeibo"];
    }
    else if (self.target == PFShareTargetQzone) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Qzone"];
    }
    else if (self.target == PFShareTargetWeChatTimeline) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Timeline"];
    }
    else if (self.target == PFShareTargetWeChatSession) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-WeChat"];
    }
    else if (self.target == PFShareTargetQQ) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-QQ"];
    }
    else if (self.target == PFShareTargetDouban) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Douban"];
    }
    else if (self.target == PFShareTargetRenren) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PFShareAuthData-Renren"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private Methods

//请求认证口令和认证码
- (void)requestAccessTokenWithAuthorizationCode:(NSString *)code
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.appKey, @"client_id",
                            self.appSecret, @"client_secret",
                            @"authorization_code", @"grant_type",
                            self.appRedirectURI, @"redirect_uri",
                            code, @"code", nil];
    [self.request disconnect];
    
    NSString *AccessTokenURL;
    if(self.target == PFShareTargetSinaWeibo) {//新浪微博
        AccessTokenURL = kSinaWeiboWebAccessTokenURL;
    }
    else if(self.target == PFShareTargetTencentWeibo) {//腾讯微博
        AccessTokenURL = kTencentWeiboWebAccessTokenURL;
    }
    else if(self.target == PFShareTargetDouban) {//豆瓣
        AccessTokenURL = kDoubanBroadWebAccessTokenURL;
    }
    else if (self.target == PFShareTargetRenren) {//人人
        AccessTokenURL = kRenrenBroadWebAccessTokenURL;
    }
    
    self.request = [PFShareRequest requestWithURL:AccessTokenURL
                                  httpMethod:@"POST"
                                      params:params
                                    delegate:self];
    [self.request connect];
}

//请求完成
- (void)requestDidFinish:(PFShareRequest *)request
{
    [requestSet removeObject:request];
    request.manager = nil;
}

//请求失败（无效的口令）
- (void)requestDidFailWithInvalidToken:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(share:accessTokenInvalidOrExpired:)]) {
        [self.delegate share:self accessTokenInvalidOrExpired:error];
    }
}

//通知口令过期
- (void)notifyTokenExpired:(id<PFShareRequestDelegate>)delegate
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Token expired", NSLocalizedDescriptionKey, nil];
    NSString *SDKErrorDomain;
    if(self.target == PFShareTargetSinaWeibo) {//新浪微博
        SDKErrorDomain = kSinaWeiboSDKErrorDomain;
    }
    else if(self.target == PFShareTargetTencentWeibo) {//腾讯微博
        SDKErrorDomain = kTencentWeiboSDKErrorDomain;
    }
    else if(self.target == PFShareTargetDouban) {//豆瓣
        SDKErrorDomain = kDoubanBroadSDKErrorDomain;
    }
    else if (self.target == PFShareTargetRenren) {//人人
        SDKErrorDomain = kRenrenBroadSDKErrorDomain;
    }
    
    NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                         code:21315
                                     userInfo:userInfo];
    
    if ([self.delegate respondsToSelector:@selector(share:accessTokenInvalidOrExpired:)]) {
        [self.delegate share:self accessTokenInvalidOrExpired:error];
    }
    if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[delegate request:nil didFailWithError:error];
	}
}

//取消登陆
- (void)logInDidCancel
{
    if ([self.delegate respondsToSelector:@selector(shareLogInDidCancel:)]) {
        [self.delegate shareLogInDidCancel:self];
    }
}

- (void)logInDidFinishWithAuthorizeInfo:(NSDictionary *)authorizeInfo
{
    NSLog(@"auto:%@",authorizeInfo);
    
    //新浪的比较特别，所以不在这个函数中获得access_token
    NSString *access_token = [authorizeInfo objectForKey:@"access_token"];
    NSString *uid = [authorizeInfo objectForKey:@"uid"];
    NSString *remind_in = [authorizeInfo objectForKey:@"remind_in"];
    NSString *refresh_token = [authorizeInfo objectForKey:@"refresh_token"];
    
    if(self.target == PFShareTargetTencentWeibo) {
        uid = [authorizeInfo objectForKey:@"openid"];
        remind_in = [authorizeInfo objectForKey:@"expires_in"];
    }
    else if(self.target == PFShareTargetDouban) {
        uid = [authorizeInfo objectForKey:@"douban_user_id"];
        remind_in = [authorizeInfo objectForKey:@"expires_in"];
    }
    else if(self.target == PFShareTargetRenren) {
        uid = [[authorizeInfo objectForKey:@"user"] objectForKey:@"id"];
        remind_in = [authorizeInfo objectForKey:@"expires_in"];
    }
    
    if (access_token && uid)
    {
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        
        self.accessToken = access_token;
        self.userID = uid;
        self.refreshToken = refresh_token;
        
        [self storeAuthorizeData];
        
        if ([self.delegate respondsToSelector:@selector(shareDidLogIn:)]) {
            [self.delegate shareDidLogIn:self];
        }
    }
}

- (void)logInDidFailWithErrorInfo:(NSDictionary *)errorInfo
{
    NSString *error_code = [errorInfo objectForKey:@"error_code"];
    if ([error_code isEqualToString:@"21330"])
    {
        [self logInDidCancel];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(share:logInDidFailWithError:)])
        {
            NSString *error_description = [errorInfo objectForKey:@"error_description"];
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      errorInfo, @"error",
                                      error_description, NSLocalizedDescriptionKey, nil];
            
            NSString *SDKErrorDomain;
            if(self.target == PFShareTargetSinaWeibo) {//新浪微博
                SDKErrorDomain = kSinaWeiboSDKErrorDomain;
            }
            else if (self.target == PFShareTargetTencentWeibo) {//腾讯微博
                SDKErrorDomain = kTencentWeiboSDKErrorDomain;
            }
            else if (self.target == PFShareTargetQzone) {//QQ空间

            }
            else if (self.target == PFShareTargetWeChatTimeline) {//微信朋友圈

            }
            else if (self.target == PFShareTargetWeChatSession) {//微信会话

            }
            else if (self.target == PFShareTargetQQ) {//QQ

            }
            else if (self.target == PFShareTargetDouban) {//豆瓣
                SDKErrorDomain = kDoubanBroadSDKErrorDomain;
            }
            else if(self.target == PFShareTargetRenren) {//人人
                SDKErrorDomain = kRenrenBroadSDKErrorDomain;
            }
            
            NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                                 code:[error_code intValue]
                                             userInfo:userInfo];
            [self.delegate share:self logInDidFailWithError:error];
        }
        
    }
}

#pragma mark - Validation Managament Methods

- (BOOL)isLoggedIn
{
    return userIDKey && accessTokenKey && expirationDateKey;
}

- (BOOL)isAuthorizeExpired
{
    NSDate *now = [NSDate date];
    return ([now compare:expirationDateKey] == NSOrderedDescending);
}

- (BOOL)isAuthorizeValid
{
    return ([self isLoggedIn] && ![self isAuthorizeExpired]);
}

#pragma mark - LogIn / LogOut Management Methods

- (void)logIn
{
    if ([self isAuthorizeValid])
    {
        if ([self.delegate respondsToSelector:@selector(shareDidLogIn:)]) {
            [self.delegate shareDidLogIn:self];
        }
    }
    else
    {
        ssoLoggingIn = NO;
        
        //打开对应的App客户端
        UIDevice *device = [UIDevice currentDevice];
        if ([device respondsToSelector:@selector(isMultitaskingSupported)] &&
            [device isMultitaskingSupported])
        {
            NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    self.appKey, @"client_id",
                                    self.appRedirectURI, @"redirect_uri",
                                    self.ssoCallbackScheme, @"callback_uri", nil];

            //App授权的接口
            NSString *appAuthorizeBaseURL;
            if (PFShareIsDeviceIPad())
            {//先判断是否iPad
                if (self.target == PFShareTargetSinaWeibo) {//新浪微博
                    appAuthorizeBaseURL = kSinaWeiboAppAuthURL_iPad;
                }
                else if (self.target == PFShareTargetTencentWeibo) {//腾讯微博
                    appAuthorizeBaseURL = kTencentWeiboAppAuthURL_iPad;
                }
                else if (self.target == PFShareTargetDouban) {//豆瓣
                    appAuthorizeBaseURL = kDoubanBroadAppAuthURL_iPad;
                }
                else if (self.target == PFShareTargetRenren) {//人人
                    appAuthorizeBaseURL = kRenrenBroadAppAuthURL_iPad;
                }
                NSString *appAuthorizeURL = [PFShareRequest requestWithURL:appAuthorizeBaseURL httpMethod:@"GET" params:params];
                ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthorizeURL]];
            }
            else
            {//再判断是否iPhone
                if (self.target == PFShareTargetSinaWeibo) {//新浪微博
                    appAuthorizeBaseURL = kSinaWeiboAppAuthURL_iPhone;
                }
                else if (self.target == PFShareTargetTencentWeibo) {//腾讯微博
                    appAuthorizeBaseURL = kTencentWeiboAppAuthURL_iPhone;
                }
                else if (self.target == PFShareTargetDouban) {//豆瓣
                    appAuthorizeBaseURL = kDoubanBroadAppAuthURL_iPhone;
                }
                else if (self.target == PFShareTargetRenren) {//人人
                    appAuthorizeBaseURL = kRenrenBroadAppAuthURL_iPhone;
                }
                NSString *appAuthorizeURL = [PFShareRequest requestWithURL:appAuthorizeBaseURL httpMethod:@"GET" params:params];
                ssoLoggingIn = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appAuthorizeURL]];

                //微信
                if (self.target == PFShareTargetWeChatSession || self.target == PFShareTargetWeChatTimeline)
                {
                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
                    {
                        WXMediaMessage *message = [WXMediaMessage message];
                        message.title = self.title;
                        message.description = self.description;
                        message.thumbData = self.thumbData;
                    }
                }
            }
        }

        //打开对应的App授权网页
        if (!ssoLoggingIn)
        {
            if (self.target != PFShareTargetWeChatSession && self.target != PFShareTargetWeChatTimeline)
            {
                //打开认证界面
                NSDictionary *params = @{@"client_id": self.appKey,
                                         @"response_type": @"code",
                                         @"redirect_uri": self.appRedirectURI,
                                         @"display": @"mobile"};
                PFShareAuthorizeView *authorizeView = [[PFShareAuthorizeView alloc] initWithAuthorizeParams:params delegate:self];
                [authorizeView show];
            }
        }
    }
}

- (void)logOut
{
    [self removeAuthorizeData];
    
    if ([self.delegate respondsToSelector:@selector(shareDidLogOut:)]) {
        [self.delegate shareDidLogOut:self];
    }
}

#pragma mark - Send Request With Token

- (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSMutableDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate
{
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    if ([self isAuthorizeValid])
    {
        [params setValue:self.accessToken forKey:@"access_token"];
        
        NSString *SDKDomain;
        if(self.target == PFShareTargetSinaWeibo) {//新浪微博
            SDKDomain = kSinaWeiboSDKAPIDomain;
        }
        else if(self.target == PFShareTargetTencentWeibo) {//腾讯微博
            SDKDomain = kTencentWeiboSDKAPIDomain;
        }
        else if (self.target == PFShareTargetQzone) {//QQ空间

        }
        else if (self.target == PFShareTargetWeChatTimeline) {//微信客户端

        }
        else if (self.target == PFShareTargetWeChatSession) {//微信会话

        }
        else if (self.target == PFShareTargetQQ) {//QQ
            
        }
        else if(self.target == PFShareTargetDouban) {//豆瓣
            SDKDomain = kDoubanBroadSDKAPIDomain;
        }
        else if(self.target == PFShareTargetRenren) {//人人
            SDKDomain = kRenrenBroadSDKAPIDomain;
        }

        self.url = url;
        self.httpMethod = httpMethod;
        self.params = params;

        NSString *fullURL = [SDKDomain stringByAppendingString:self.url];
        
        PFShareRequest *request = [PFShareRequest requestWithURL:fullURL httpMethod:self.httpMethod params:self.params delegate:delegate];
        request.manager = self;
        [requestSet addObject:request];
        if([self.delegate respondsToSelector:@selector(shareWillBeginRequest:)]) {
            [self.delegate shareWillBeginRequest:self.request];
        }
        [request connect];
        return request;
    }
    else
    {
        //在下一个线程循环提示口令过期
        [self performSelectorOnMainThread:@selector(notifyTokenExpired:) withObject:delegate waitUntilDone:NO];
        return nil;
    }
}

#pragma mark - PFShareAuthorizeViewDelegate

- (void)authorizeView:(PFShareAuthorizeView *)authorizeView didRecieveAuthorizationCode:(NSString *)code
{
    [self requestAccessTokenWithAuthorizationCode:code];
}

- (void)authorizeView:(PFShareAuthorizeView *)authorizeView didFailWithErrorInfo:(NSDictionary *)errorInfo
{
    [self logInDidFailWithErrorInfo:errorInfo];
}

- (void)authorizeViewDidCancel:(PFShareAuthorizeView *)authView
{
    [self logInDidCancel];
}

#pragma mark - PFShareRequestDelegate

- (void)request:(PFShareRequest *)request didFailWithError:(NSError *)error
{
    if (request == self.request) {
        if ([self.delegate respondsToSelector:@selector(share:logInDidFailWithError:)]) {
            [self.delegate share:self logInDidFailWithError:error];
        }
    }
}

- (void)request:(PFShareRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request == self.request) {
        [self logInDidFinishWithAuthorizeInfo:result];
    }
}

#pragma mark - Application life cycle

- (void)applicationDidBecomeActive
{
    if (ssoLoggingIn)
    {
        // user open the app manually
        // clean sso login state
        ssoLoggingIn = NO;
        
        if ([self.delegate respondsToSelector:@selector(shareLogInDidCancel:)]) {
            [self.delegate shareLogInDidCancel:self];
        }
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    PFShareManager *shareManager = [[PFShareManager alloc] init];
    return [shareManager handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:self.ssoCallbackScheme])
    {
        if (!ssoLoggingIn)
        {
            // sso callback after user have manually opened the app
            // ignore the request
        }
        else
        {
            ssoLoggingIn = NO;
            
            if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"sso_error_user_cancelled"]) {
                if ([self.delegate respondsToSelector:@selector(shareLogInDidCancel:)]) {
                    [self.delegate shareLogInDidCancel:self];
                }
            }
            else if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"sso_error_invalid_params"])
            {
                if ([self.delegate respondsToSelector:@selector(share:logInDidFailWithError:)])
                {
                    NSString *error_description = @"Invalid sso params";
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              error_description, NSLocalizedDescriptionKey, nil];
                    NSString *SDKErrorDomain;
                    if(self.target == PFShareTargetSinaWeibo) {
                        SDKErrorDomain = kSinaWeiboSDKErrorDomain;
                    }
                    else if(self.target == PFShareTargetTencentWeibo) {
                        SDKErrorDomain = kTencentWeiboSDKErrorDomain;
                    }
                    else if(self.target == PFShareTargetDouban) {
                        SDKErrorDomain = kDoubanBroadSDKErrorDomain;
                    } else {
                        SDKErrorDomain = kRenrenBroadSDKErrorDomain;
                    }
                    
                    NSError *error = [NSError errorWithDomain:SDKErrorDomain
                                                         code:kSDKErrorCodeSSOParamsError
                                                     userInfo:userInfo];
                    [self.delegate share:self logInDidFailWithError:error];
                }
            }
            else if ([PFShareRequest getParamValueFromUrl:urlString paramName:@"error_code"])
            {
                NSString *error_code = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_code"];
                NSString *error = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error"];
                NSString *error_uri = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_uri"];
                NSString *error_description = [PFShareRequest getParamValueFromUrl:urlString paramName:@"error_description"];
                
                NSDictionary *errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           error, @"error",
                                           error_uri, @"error_uri",
                                           error_code, @"error_code",
                                           error_description, @"error_description", nil];
                
                [self logInDidFailWithErrorInfo:errorInfo];
            }
            else
            {
                NSString *access_token = [PFShareRequest getParamValueFromUrl:urlString paramName:@"access_token"];
                NSString *expires_in = [PFShareRequest getParamValueFromUrl:urlString paramName:@"expires_in"];
                NSString *remind_in = [PFShareRequest getParamValueFromUrl:urlString paramName:@"remind_in"];
                NSString *uid = [PFShareRequest getParamValueFromUrl:urlString paramName:@"uid"];
                NSString *refresh_token = [PFShareRequest getParamValueFromUrl:urlString paramName:@"refresh_token"];
                
                NSMutableDictionary *authInfo = [NSMutableDictionary dictionary];
                if (access_token) [authInfo setObject:access_token forKey:@"access_token"];
                if (expires_in) [authInfo setObject:expires_in forKey:@"expires_in"];
                if (remind_in) [authInfo setObject:remind_in forKey:@"remind_in"];
                if (refresh_token) [authInfo setObject:refresh_token forKey:@"refresh_token"];
                if (uid) [authInfo setObject:uid forKey:@"uid"];
                
                [self logInDidFinishWithAuthorizeInfo:authInfo];
            }
        }
    }
    return YES;
}

@end

//判断设备是否为iPad
BOOL PFShareIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}
