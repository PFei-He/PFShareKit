//
//  PFShareRequest.h
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

@class PFShareManager;
@class PFShareRequest;

/**
 *  @brief 第三方应用访问API时实现此协议，当SDK完成API的访问后通过传入的此类对象完成接口访问结果的回调，应用在协议实现的相应方法中接收访问结果并做对应处理。
 */
@protocol PFShareRequestDelegate <NSObject>

@optional

/**
 *  @brief 请求响应
 *  @param response: 具体的响应对象
 */
- (void)request:(PFShareRequest *)request didReceiveResponse:(NSURLResponse *)response;

/**
 *  @brief 请求完成
 *  @param data: 返回结果
 */
- (void)request:(PFShareRequest *)request didFinishLoadingWithDataResult:(NSData *)data;

/**
 *  @brief 请求完成
 *  @param result: 返回结果
 */
- (void)request:(PFShareRequest *)request didFinishLoadingWithResult:(id)result;

/**
 *  @brief 请求失败
 *  @param error: 错误信息
 */
- (void)request:(PFShareRequest *)request didFailWithError:(NSError *)error;

@end

@interface PFShareRequest : NSObject
{
    NSString            *url;               //请求的接口
    NSString            *httpMethod;        //http类型，GET或POST
    NSDictionary        *params;            //请求的参数，如发微博所带的文字内容等
    NSURLConnection     *connection;        //创建连接
    NSMutableData       *responseData;      //返回的数据
}

///分享管理
@property (nonatomic, assign) PFShareManager    *manager;

///请求的接口
@property (nonatomic, retain) NSString          *url;

///http类型，GET或POST
@property (nonatomic, retain) NSString          *httpMethod;

///请求的参数，如发微博所带的文字，图片
@property (nonatomic, retain) NSDictionary      *params;

///PFShareRequest对象的代理
@property (nonatomic, assign) id<PFShareRequestDelegate> delegate;

/**
 *  @brief
 */
+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;

/**
 *  @brief 分享请求
 *  @param url: 请求地址
 *  @param params: 发送的参数
 *  @param httpMethod: http请求类型（GET/POST）
 */
+ (NSString *)requestWithURL:(NSString *)baseURL httpMethod:(NSString *)httpMethod params:(NSDictionary *)params;

/**
 *  @brief 接口请求，方法中自动完成token信息的拼接
 *  @param url: 请求的接口
 *  @param httpMethod: http请求类型（GET/POST）
 *  @param params: 请求的参数，如发微博所带的文字内容等
 *  @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 *  @return 完成实际请求操作的PFShareRequest对象
 */
+ (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate;

/**
 *  @brief 获取认证请求
 *  @param url: 请求的接口
 *  @param httpMethod: http请求类型（GET/POST）
 *  @param params: 请求的参数，如发微博所带的文字内容等
 *  @param delegate: 处理请求结果的回调的对象，PFShareRequestDelegate类
 */
+ (PFShareRequest *)requestWithAccessToken:(NSString *)accessToken
                                       url:(NSString *)url
                                httpMethod:(NSString *)httpMethod
                                    params:(NSDictionary *)params
                                  delegate:(id<PFShareRequestDelegate>)delegate;

/**
 *  @brief 连接网络
 */
- (void)connect;

/**
 *  @brief 断开网络
 */
- (void)disconnect;

@end
