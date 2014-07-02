//
//  PFShareRequest.m
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

#import "PFShareRequest.h"
#import "PFShareConstants.h"
#import "PFShareManager.h"

#define kSinaWeiboRequestTimeOutInterval   120.0
#define kSinaWeiboRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@interface NSString (Encode)

- (NSString *)URLEncodedString;

@end

@implementation NSString (Encode)

- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[self mutableCopy], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

- (NSString *)URLEncodedString
{
	return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

@end

@interface PFShareManager (PFShareRequest)

//请求成功
- (void)requestDidFinish:(PFShareRequest *)request;

//请求失败（使用无效的认证）
- (void)requestDidFailWithInvalidToken:(NSError *)error;

@end

@interface PFShareRequest (Private)

//添加UTF8的字符串
- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;

//发送请求的原始参数
- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData;

//处理返回的数据
- (void)handleResponseData:(NSData *)data;

//解析JSON数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error;

//错误代码
- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

//请求失败的错误原因
- (void)failedWithError:(NSError *)error;

@end

@implementation PFShareRequest

@synthesize manager;
@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize delegate;

#pragma mark - Private Methods

//解码
- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kSinaWeiboRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kSinaWeiboRequestStringBoundary];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    NSMutableData *body = [NSMutableData data];
    [self appendUTF8Body:body dataString:bodyPrefixString];
    
    for (id key in [params keyEnumerator])
    {
        if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]])) {
            [dataDictionary setObject:[params valueForKey:key] forKey:key];
            continue;
        }
        
        [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
        [self appendUTF8Body:body dataString:bodyPrefixString];
    }
    
    if ([dataDictionary count] > 0)
    {
        *hasRawData = YES;
        for (id key in dataDictionary) {
            NSObject *dataParam = [dataDictionary valueForKey:key];
            
            if([key isEqual:@"upload"])
            {
                NSData* imageData;
                if ([dataParam isKindOfClass:[UIImage class]]) {
                    imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                }
                else if ([dataParam isKindOfClass:[NSData class]]) {
                    imageData = (NSData *)dataParam;
                }
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\";filename=no.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", kSinaWeiboRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type:\"image/jpeg\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", kSinaWeiboRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else
            {
                if ([dataParam isKindOfClass:[UIImage class]])
                {
                    NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                    [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\n", key,dataParam]];
                    [self appendUTF8Body:body dataString:@"Content-Type:\"image/jpeg\"\r\n\r\n"];
                    [body appendData:imageData];
                }
                else if ([dataParam isKindOfClass:[NSData class]])
                {
                    [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file\"\r\n", key]];
                    [self appendUTF8Body:body dataString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
                    [body appendData:(NSData*)dataParam];
                }
            }
            [self appendUTF8Body:body dataString:bodySuffixString];
        }
    }
    return body;
}

//管理接收的数据
- (void)handleResponseData:(NSData *)data
{
    if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithDataResult:)]) {
        [delegate request:self didFinishLoadingWithDataResult:data];
    }
	
	NSError *error = nil;
	id result = [self parseJSONData:data error:&error];
    
    NSString *tmpStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if(result == nil && [tmpStr hasPrefix:@"access_token="] && [(PFShareManager *)delegate target] == PFShareTargetTencentWeibo)
    {
        result = [NSMutableDictionary dictionary];
        for(NSString *tmpString in [tmpStr componentsSeparatedByString:@"&"])
        {
            [result setValue:[[tmpString componentsSeparatedByString:@"="] lastObject]
                      forKey:[[tmpString componentsSeparatedByString:@"="] objectAtIndex:0]];
        }
    }
    
	if (!result)
	{
		[self failedWithError:error];
	}
	else
	{
        NSInteger error_code = 0;
        if([result isMemberOfClass:[NSDictionary class]])
        {
            [[result objectForKey:@"error_code"] intValue];
        }
        
        if (error_code != 0)
        {
            NSString *error_description = [result objectForKey:@"error"];
            NSDictionary *userInfo = @{@"error": result, NSLocalizedDescriptionKey: error_description};
            NSError *error = [NSError errorWithDomain:kSinaWeiboSDKErrorDomain code:[[result objectForKey:@"error_code"] intValue] userInfo:userInfo];
            
            if (error_code == 21314     //access_token已经被使用
                || error_code == 21315  //access_token已经过期
                || error_code == 21316  //access_token不合法
                || error_code == 21317  //access_token不合法
                || error_code == 21327  //access_token过期
                || error_code == 21332) //access_token无效
            {
                [manager requestDidFailWithInvalidToken:error];
            }
            else
            {
                [self failedWithError:error];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
                [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }
        }
	}
}

//解析JSON数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
    NSError *parseError = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
	
	if (parseError && (error != nil)) {
        NSDictionary *userInfo = @{@"error": parseError, NSLocalizedDescriptionKey: @"Data parse error"};
        *error = [self errorWithCode:kSDKErrorCodeParseError userInfo:userInfo];
	}

	return result;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kSinaWeiboSDKErrorDomain code:code userInfo:userInfo];
}

- (void)failedWithError:(NSError *)error
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark - Public Methods

+ (NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="]) {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

+ (NSString *)requestWithURL:(NSString *)baseURL httpMethod:(NSString *)httpMethod params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]]) || ([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"]) {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        
        NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(CFStringRef)[params objectForKey:key], NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (PFShareRequest *)requestWithURL:(NSString *)url
                        httpMethod:(NSString *)httpMethod
                            params:(NSDictionary *)params
                          delegate:(id<PFShareRequestDelegate>)delegate
{
    PFShareRequest *request = [[PFShareRequest alloc] init];
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}

+ (PFShareRequest *)requestWithAccessToken:(NSString *)accessToken
                                       url:(NSString *)url
                                httpMethod:(NSString *)httpMethod
                                    params:(NSDictionary *)params
                                  delegate:(id<PFShareRequestDelegate>)delegate
{
    // add the access token field
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"access_token"];
    return [PFShareRequest requestWithURL:url httpMethod:httpMethod params:mutableParams delegate:delegate];
}

- (void)connect
{
    NSString* urlString = [[self class] requestWithURL:url httpMethod:httpMethod params:params];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kShareRequestTimeOutInterval];
    NSLog(@"%@",urlString);
    [request setHTTPMethod:self.httpMethod];

    if ([self.httpMethod isEqualToString: @"POST"])
    {
        BOOL hasRawData = NO;
        [request setHTTPBody:[self postBodyHasRawData:&hasRawData]];
        
        if (hasRawData)
        {
            NSString* contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@", kSinaWeiboRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
    }
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect
{
    [connection cancel];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	[self failedWithError:error];
	
    [connection cancel];
    
    [manager requestDidFinish:self];
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	[self handleResponseData:responseData];
    
    [connection cancel];
    
    [manager requestDidFinish:self];
}

@end
