//
//  PFShareConstants.h
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

#pragma mark - SDK Management

//新浪微博
#define SinaWeiboSdkVersion                 @"2.0"
#define kSinaWeiboSDKErrorDomain            @"SinaWeiboSDKErrorDomain"
#define kSinaWeiboSDKErrorCodeKey           @"SinaWeiboSDKErrorCodeKey"
#define kSinaWeiboSDKAPIDomain              @"https://open.weibo.cn/2/"
#define kSinaWeiboSDKOAuth2APIDomain        @"https://open.weibo.cn/2/oauth2/"
#define kSinaWeiboWebAuthURL                @"https://open.weibo.cn/2/oauth2/authorize"
#define kSinaWeiboWebAccessTokenURL         @"https://open.weibo.cn/2/oauth2/access_token"
#define kSinaWeiboAppAuthURL_iPhone         @"sinaweibo://"
#define kSinaWeiboAppAuthURL_iPad           @"sinaweibohd://"

//腾讯微博
#define TencentWeiboSdkVersion              @"2.0"
#define kTencentWeiboSDKErrorDomain         @"TCSDKErrorDomain"
#define kTencentWeiboSDKErrorCodeKey        @"TCSDKErrorCodeKey"
#define kTencentWeiboSDKAPIDomain           @"https://open.t.qq.com/api/"
#define kTencentWeiboSDKOAuth2APIDomain     @"https://open.t.qq.com/cgi-bin/oauth2/"
#define kTencentWeiboWebAuthURL             @"https://open.t.qq.com/cgi-bin/oauth2/authorize/ios"
#define kTencentWeiboWebAccessTokenURL      @"https://open.t.qq.com/cgi-bin/oauth2/access_token"
#define kTencentWeiboAppAuthURL_iPhone      @"tencentweibo://"
#define kTencentWeiboAppAuthURL_iPad        @"tencentweibohd://"

//QQ空间
#define kQzoneWebAuthURL                    @"qzone://"

//微信
#define kWeChatAppAuthURL                   @"weixin://"

//QQ
#define kQQAppAuthURL                       @"mqq://"

//豆瓣
#define DoubanBroadSdkVersion               @"2.0"
#define kDoubanBroadSDKErrorDomain          @"DoubanSDKErrorDomain"
#define kDoubanBroadSDKErrorCodeKey         @"DoubanSDKErrorCodeKey"
#define kDoubanBroadSDKAPIDomain            @"https://api.douban.com/"
#define kDoubanBroadSDKOAuth2APIDomain      @"https://www.douban.com/service/auth2/"
#define kDoubanBroadWebAuthURL              @"https://www.douban.com/service/auth2/auth"
#define kDoubanBroadWebAccessTokenURL       @"https://www.douban.com/service/auth2/token"
#define kDoubanBroadAppAuthURL_iPhone       @"doubanbroadsso://login"
#define kDoubanBroadAppAuthURL_iPad         @"doubanbroadhdsso://login"

//人人
#define RenrenBroadSdkVersion               @"3.0"
#define kRenrenBroadSDKErrorDomain          @"RenrenSDKErrorDomain"
#define kRenrenBroadSDKErrorCodeKey         @"RenrenSDKErrorCodeKey"
#define kRenrenBroadSDKAPIDomain            @"https://api.renren.com/"
#define kRenrenBroadSDKOAuth2APIDomain      @"http://graph.renren.com/oauth/"
#define kRenrenBroadWebAuthURL              @"http://graph.renren.com/oauth/authorize"
#define kRenrenBroadWebAccessTokenURL       @"https://graph.renren.com/oauth/token"
#define kRenrenBroadAppAuthURL_iPhone       @"renren://"
#define kRenrenBroadAppAuthURL_iPad         @"renrenhd://"

//请求延时
#define kShareRequestTimeOutInterval 120.0f

typedef enum
{
    kSDKErrorCodeParseError       = 200,
	kSDKErrorCodeSSOParamsError   = 202,
} SDKErrorCode;

//#endif
