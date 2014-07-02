//
//  PFShareManager.h
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

#import <Foundation/Foundation.h>
#import "PFShareAuthorizeView.h"
#import "PFShareRequest.h"
#import "WXApi.h"

typedef NS_ENUM (NSInteger, PFShareTarget)
{
    PFShareTargetSinaWeibo          = 0,        //新浪微博
    PFShareTargetTencentWeibo       = 1,        //腾讯微博
    PFShareTargetQzone              = 2,        //QQ空间
    PFShareTargetWeChatTimeline     = 3,        //朋友圈
    PFShareTargetWeChatSession      = 4,        //微信
    PFShareTargetQQ                 = 5,        //QQ
    PFShareTargetDouban             = 6,        //豆瓣
    PFShareTargetRenren             = 7,        //人人
};

@protocol PFShareDelegate;                      //接入代理

@interface PFShareManager : NSObject <PFShareAuthorizeViewDelegate, PFShareRequestDelegate>

///用户ID
@property (nonatomic, copy)     NSString                *userID;

///访问口令
@property (nonatomic, copy)     NSString                *accessToken;

///认证过期时间
@property (nonatomic, strong)   NSDate                  *expirationDate;

///刷新令牌
@property (nonatomic, copy)     NSString                *refreshToken;

///返回的App的Url地址
@property (nonatomic, copy)     NSString                *ssoCallbackScheme;

///应用注册时的App ID
@property (nonatomic, copy)     NSString                *appID;

///应用注册时的App Key
@property (nonatomic, copy)     NSString                *appKey;

///应用注册时的App Redirect URI
@property (nonatomic, copy)     NSString                *appSecret;

///应用注册时的App Redirect URI
@property (nonatomic, copy)     NSString                *appRedirectURI;

///创建请求
@property (nonatomic, strong)   PFShareRequest          *request;

///分享目标
@property (nonatomic)           PFShareTarget            target;

///申请代理
@property (nonatomic, assign)   id<PFShareDelegate>     delegate;

///请求的接口
@property (nonatomic, copy)     NSString                *url;

///请求的方法（GET或POST）
@property (nonatomic, copy)     NSString                *httpMethod;

///请求的参数
@property (nonatomic, copy)     NSMutableDictionary     *params;

///标题
@property (nonatomic, copy)     NSString                *title;

///描述内容
@property (nonatomic, copy)     NSString                *description;

///缩略图数据
@property (nonatomic, copy)     NSData                  *thumbData;

/**
 *  @brief 设置分享的目标
 */
+ (id)sharedInstanceWithTarget:(PFShareTarget)target;

/**
 *  @brief 初始化构造函数，返回采用默认sso回调地址构造的PFShareManager对象
 *  @param appKey: 分配给第三方应用的appkey
 *  @param appSecrect: 分配给第三方应用的appsecrect
 *  @param appRedirectURI: 微博开放平台中授权设置的应用回调页
 *  @return PFShareManager对象
 */
- (id)initWithAppKey:(NSString *)appKey
           appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
         andDelegate:(id<PFShareDelegate>)delegate;

/**
 *  @brief 初始化构造函数，返回采用默认sso回调地址构造的PFShareManager对象
 *  @param appKey: 分配给第三方应用的appkey
 *  @param appSecrect: 分配给第三方应用的appsecrect
 *  @param ssoCallbackScheme: sso回调地址，此值应与URL Types中定义的保持一致。
 *  @param appRedirectURI: 微博开放平台中授权设置的应用回调页
 *  @return PFShareManager对象
 */
- (id)initWithAppKey:(NSString *)appKey
           appSecret:(NSString *)appSecret
      appRedirectURI:(NSString *)appRedirectURI
   ssoCallbackScheme:(NSString *)ssoCallbackScheme
         andDelegate:(id<PFShareDelegate>)delegate;

/**
 *  @brief 当应用从后台唤起时，应调用此方法，需要完成退出当前登录状态的功能
 */
- (void)applicationDidBecomeActive;

/**
 *  @brief sso回调方法，官方客户端完成sso授权后，回调唤起应用，应用中应调用此方法完成sso登录
 *  @param url: 官方客户端回调给应用时传回的参数，包含认证信息等
 *  @return YES
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief 获取认证信息
 */
- (void)getAuthorizeData;

/**
 *  @brief 清空认证信息
 */
- (void)removeAuthorizeData;

/**
 *  @brief 登录入口，当初始化PFShareManager对象完成后直接调用此方法完成登录
 */
- (void)logIn;

/**
 *  @brief 注销方法，需要退出时直接调用此方法
 */
- (void)logOut;

/**
 *  @brief 判断是否登陆
 *  @return YES为已登录，NO为未登录
 */
- (BOOL)isLoggedIn;

/**
 *  @brief 判断授权是否过期
 *  @return YES为已过期，NO为未过期
 */
- (BOOL)isAuthorizeExpired;

/**
 *  @brief 判断登陆是否有效，当已登录并且登录未过期时为有效状态
 *  @return YES为有效，NO为无效
 */
- (BOOL)isAuthorizeValid;

/**
 *  @brief 发送分享请求，方法中自动完成token信息的拼接
 *  @param url: 请求的接口
 *  @param httpMethod: http类型，GET或POST
 *  @param params: 请求的参数，如发微博所带的文字内容等
 *  @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 *  @return 完成实际请求操作的PFShareRequest对象
 */
- (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSMutableDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate;

@end

@protocol PFShareDelegate <NSObject>

@optional

/**
 *  @brief 登陆
 */
- (void)shareDidLogIn:(PFShareManager *)shareManager;

/**
 *  @brief 注销
 */
- (void)shareDidLogOut:(PFShareManager *)shareManager;

/**
 *  @brief 取消登陆
 */
- (void)shareLogInDidCancel:(PFShareManager *)shareManager;

/**
 *  @brief 即将发送请求
 */
- (void)shareWillBeginRequest:(PFShareRequest *)request;

/**
 *  @brief 登陆出错
 */
- (void)share:(PFShareManager *)shareManager logInDidFailWithError:(NSError *)error;

/**
 *  @brief 认证无效或失效
 */
- (void)share:(PFShareManager *)shareManager accessTokenInvalidOrExpired:(NSError *)error;

@end

extern BOOL PFShareIsDeviceIPad();  //判断设备是否为iPad
