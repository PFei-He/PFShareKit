//
//  PFShareRegisterApp.h
//  PFShareKit
//
//  Created by PFei_He on 14-7-2.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFShareRegisterApp : NSObject

///
@property (nonatomic, copy) NSString *SinaWeiboAppKey;
///
@property (nonatomic, copy) NSString *SinaWeiboAppSecret;
///
@property (nonatomic, copy) NSString *SinaWeiboAppRedirectURI;

///
@property (nonatomic, copy) NSString *TencentWeiboAppKey;
///
@property (nonatomic, copy) NSString *TencentWeiboAppSecret;
///
@property (nonatomic, copy) NSString *TencentWeiboAppRedirectURI;

///
@property (nonatomic, copy) NSString *QzoneAppKey;
///
@property (nonatomic, copy) NSString *QzoneAppSecret;
///
@property (nonatomic, copy) NSString *QzoneAppRedirectURI;

///
@property (nonatomic, copy) NSString *WeChatAppKey;
///
@property (nonatomic, copy) NSString *WeChatAppSecret;
///
@property (nonatomic, copy) NSString *WeChatAppRedirectURI;

///
@property (nonatomic, copy) NSString *QQAppKey;
///
@property (nonatomic, copy) NSString *QQAppSecret;
///
@property (nonatomic, copy) NSString *QQAppRedirectURI;

///
@property (nonatomic, copy) NSString *DoubanBroadAppKey;
///
@property (nonatomic, copy) NSString *DoubanBroadAppSecret;
///
@property (nonatomic, copy) NSString *DoubanBroadAppRedirectURI;

///
@property (nonatomic, copy) NSString *RenrenBroadAppID;
///
@property (nonatomic, copy) NSString *RenrenBroadAppKey;
///
@property (nonatomic, copy) NSString *RenrenBroadAppSecret;
///
@property (nonatomic, copy) NSString *RenrenBroadAppRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithSinaWeiboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithTencentWeiboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithQzoneAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithWeChatAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithQQAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithDoubanboAppKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

/**
 *  @brief
 *  @param
 *  @param
 *  @param
 *  @param
 */
+ (void)registerWithRenrenboAppID:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret appRedirectURI:(NSString *)appRedirectURI;

@end
