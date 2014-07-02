//
//  PFShareAuthorizeView.m
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

#import "PFShareAuthorizeView.h"
#import "PFShareConstants.h"
#import "PFShareManager.h"
#import "PFShareRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
static CGFloat kTransitionDuration = 0.3;
static CGFloat kPadding = 0;
static CGFloat kBorderWidth = 10;

@interface PFShareAuthorizeView ()
{
    UIWebView                   *webView;
    UIButton                    *closeButton;           //关闭按钮
    UIView                      *modalView;
    UIActivityIndicatorView     *indicatorView;         //活动指示器（菊花）
    UIInterfaceOrientation      previousOrientation;    //设备方向

    NSString                    *appRedirectURI;
    NSDictionary                *authorizeParams;       //授权的参数

    PFShareTarget               shareTarget;            //分享的目标
}

@end

@implementation PFShareAuthorizeView

@synthesize delegate = _delegate;

#pragma mark - Drawing

- (void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect radius:(float)radius
{
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    
    if (radius == 0)
    {
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddRect(context, rect);
    }
    else
    {
        rect = CGRectOffset(CGRectInset(rect, 0.5, 0.5), 0.5, 0.5);
        CGContextTranslateCTM(context, CGRectGetMinX(rect)-0.5, CGRectGetMinY(rect)-0.5);
        CGContextScaleCTM(context, radius, radius);
        float fw = CGRectGetWidth(rect) / radius;
        float fh = CGRectGetHeight(rect) / radius;
        
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    }
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors)
    {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius)
        {
            [self addRoundedRectToPath:context rect:rect radius:radius];
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(space);
}

- (void)strokeLines:(CGRect)rect stroke:(const CGFloat*)strokeColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextSaveGState(context);
    CGContextSetStrokeColorSpace(context, space);
    CGContextSetStrokeColor(context, strokeColor);
    CGContextSetLineWidth(context, 1.0);
    
    {
        CGPoint points[] = {{rect.origin.x + 0.5, rect.origin.y - 0.5},
            {rect.origin.x + rect.size.width, rect.origin.y - 0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x + 0.5, rect.origin.y+rect.size.height - 0.5},
            {rect.origin.x + rect.size.width - 0.5, rect.origin.y+rect.size.height - 0.5}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x + rect.size.width - 0.5, rect.origin.y},
            {rect.origin.x + rect.size.width - 0.5, rect.origin.y + rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    {
        CGPoint points[] = {{rect.origin.x+0.5, rect.origin.y},
            {rect.origin.x + 0.5, rect.origin.y + rect.size.height}};
        CGContextStrokeLineSegments(context, points, 2);
    }
    CGContextRestoreGState(context);
    CGColorSpaceRelease(space);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRect:rect fill:kBorderGray radius:0];
    
    CGRect webRect = CGRectMake(ceil(rect.origin.x+kBorderWidth), ceil(rect.origin.y+kBorderWidth)+1, rect.size.width-kBorderWidth*2, rect.size.height-(1+kBorderWidth*2));
    
    [self strokeLines:webRect stroke:kBorderBlack];
}

#pragma mark - Init

- (id)init
{
    if ((self = [super init]))
    {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
        
        webView = [[UIWebView alloc] init];
        webView.delegate = self;
        webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:webView];

        UIImage *closeImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeiboSDK.bundle/images/close" ofType:@"png"]];
        UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:closeImage forState:UIControlStateNormal];
        [closeButton setTitleColor:color forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [closeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        closeButton.showsTouchWhenHighlighted = YES;
        closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:closeButton];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:indicatorView];

        modalView = [[UIView alloc] init];
    }
    return self;
}

- (id)initWithAuthorizeParams:(NSDictionary *)params delegate:(id<PFShareAuthorizeViewDelegate>)delegate
{
    if ((self = [self init]))
    {
        self.delegate = delegate;
        authorizeParams = [params copy];
        appRedirectURI = [authorizeParams objectForKey:@"redirect_uri"];
    }
    return self;
}

#pragma mark - UIDeviceOrientation

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation
{
    if (orientation == previousOrientation)
    {
        return NO;
    }
    else
    {
        return orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown
        || orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight;
    }
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    }
    else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

//适配屏幕
- (void)sizeToFitOrientation:(BOOL)transform
{
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scaleFactor = PFShareIsDeviceIPad() ? 0.6f : 1.0f;
    CGFloat width = floor(scaleFactor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scaleFactor * frame.size.height) - kPadding * 2;
    
    previousOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(previousOrientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

//设备旋转后调整webView
- (void)updateWebOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.setAttribute('orientation', 90);"];
    } else {
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.removeAttribute('orientation');"];
    }
}

#pragma mark - UIDeviceOrientationDidChangeNotification

//设备旋转
- (void)deviceOrientationDidChange:(id)object
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if ([self shouldRotateToOrientation:orientation])
    {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
	}
}

#pragma mark - Animation

- (void)bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration / 2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = [self transformForOrientation];
    [UIView commitAnimations];
}

#pragma mark - NSNotification

//添加通知
- (void)addNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

//移除通知
- (void)removeNotification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

#pragma mark - UIActivityIndicatorView

- (void)showIndicator
{
    [indicatorView sizeToFit];
    [indicatorView startAnimating];
    indicatorView.center = webView.center;
}

- (void)hideIndicator
{
    [indicatorView stopAnimating];
}

#pragma mark - Show / Hide

//加载
- (void)load
{
    NSString *webAuthURL;
    
    PFShareManager *manager = (PFShareManager *)self.delegate;
    
    if(manager.target == PFShareTargetSinaWeibo) {
        webAuthURL = kSinaWeiboWebAuthURL;
    }
    else if(manager.target == PFShareTargetTencentWeibo) {
        webAuthURL = kTencentWeiboWebAuthURL;
    }
    else if (manager.target == PFShareTargetQzone) {
        webAuthURL = kQzoneWebAuthURL;
    }
    else if (manager.target == PFShareTargetWeChatTimeline) {

    }
    else if (manager.target == PFShareTargetWeChatSession) {

    }
    else if (manager.target == PFShareTargetQQ) {
        
    }
    else if(manager.target == PFShareTargetDouban) {
        webAuthURL = kDoubanBroadWebAuthURL;
    } else {
        webAuthURL = kRenrenBroadWebAuthURL;
    }
    
    NSString *authPagePath = [PFShareRequest requestWithURL:webAuthURL httpMethod:@"GET" params:authorizeParams];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:authPagePath]]];
}

//显示分享的界面
- (void)showShareView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    modalView.frame = app.window.frame;
    [modalView addSubview:self];
    [app.window addSubview:modalView];

    //分享界面弹出动画
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
}

//显示授权页面
- (void)show
{
    [self load];
    [self sizeToFitOrientation:NO];
    
    CGFloat innerWidth = self.frame.size.width - (kBorderWidth + 1 ) * 2;
    [closeButton sizeToFit];
    closeButton.frame = CGRectMake(2, 2, 29, 29);
    
    webView.frame = CGRectMake(kBorderWidth+1, kBorderWidth+1, innerWidth, self.frame.size.height - (1 + kBorderWidth * 2));
    
    [self showShareView];
    [self showIndicator];
    [self addNotification];
}

- (void)hideModalView
{
    [self removeFromSuperview];
    [modalView removeFromSuperview];
}

- (void)hide
{
    [self removeNotification];
    
    //停止加载
    [webView stopLoading];
    
    [self performSelectorOnMainThread:@selector(hideModalView) withObject:nil waitUntilDone:NO];
}

- (void)cancel
{
    [self hide];
    [self.delegate authorizeViewDidCancel:self];
}

#pragma mark - UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	[self hideIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideIndicator];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;

    NSString *siteRedirectURI;
    if (shareTarget == PFShareTargetSinaWeibo) {
        siteRedirectURI = [NSString stringWithFormat:@"%@%@", kSinaWeiboSDKOAuth2APIDomain, appRedirectURI];
    }
    else if (shareTarget == PFShareTargetTencentWeibo) {

    }
    else if (shareTarget == PFShareTargetQzone) {

    }
    else if (shareTarget == PFShareTargetWeChatTimeline) {

    }
    else if (shareTarget == PFShareTargetWeChatSession) {

    }
    else if (shareTarget == PFShareTargetQQ) {

    }
    else if (shareTarget == PFShareTargetDouban) {

    } else {

    }

    if ([url hasPrefix:appRedirectURI] || [url hasPrefix:siteRedirectURI])
    {
        NSString *error_code = [PFShareRequest getParamValueFromUrl:url paramName:@"error_code"];
        
        if (error_code)
        {
            NSString *error = [PFShareRequest getParamValueFromUrl:url paramName:@"error"];
            NSString *error_uri = [PFShareRequest getParamValueFromUrl:url paramName:@"error_uri"];
            NSString *error_description = [PFShareRequest getParamValueFromUrl:url paramName:@"error_description"];
            
            NSDictionary *errorInfo = @{@"error": error,
                                        @"error_uri": error_uri,
                                        @"error_code": error_code,
                                        @"error_description": error_description};
            
            [self hide];
            [self.delegate authorizeView:self didFailWithErrorInfo:errorInfo];
        }
        else
        {
            NSString *code = [PFShareRequest getParamValueFromUrl:url paramName:@"code"];
            if (code) {
                [self hide];
                [self.delegate authorizeView:self didRecieveAuthorizationCode:code];
            }
        }
        return NO;
    }
    return YES;
}

//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
