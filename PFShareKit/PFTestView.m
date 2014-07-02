//
//  PFTestView.m
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PFTestView.h"

@interface PFTestView ()

@end

@implementation PFTestView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 200, 80, 30);
    button.backgroundColor = UIColor.blackColor;
    [button setTitle:@"点击分享" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(StartShare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)StartShare
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"腾讯微博", @"QQ空间", @"微信朋友圈", @"微信对话", @"QQ", @"豆瓣说", @"人人网",nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

#pragma mark - PFShareDelegate Methods

- (void)shareDidLogIn:(PFShareManager *)shareManager
{
    if (shareManager.target == PFShareTargetSinaWeibo)
    {
        [shareManager requestWithURL:@"statuses/upload.json"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"", @"",
                                 @"", @"", nil]
                       delegate:self];
    }
    else if (shareManager.target == PFShareTargetTencentWeibo)
    {
        [shareManager requestWithURL:/*@"t/add_pic"*/@"t/add"
                      httpMethod:@"POST"
//                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                 @"", @"",
//                                 @"", @"", nil]
                            params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"json", @"format",
                                    @"小伙伴们，我刚刚下载安装了APPxxxx,非常好玩哦．下载地址:xxxxxx", @"content",
                                    @"221.232.172.30", @"clientip",
                                    @"all", @"scope",
                                    shareManager.userID, @"openid",
                                    @"ios-sdk-2.0-publish", @"appfrom",
                                    @"0", @"compatibleflag",
                                    @"2.a", @"oauth_version",
                                    @"801509185", @"oauth_consumer_key",
                                    [UIImage imageNamed:@"Default.png"], @"pic", nil]
                       delegate:self];
    }
    else if (shareManager.target == PFShareTargetQzone)
    {

    }
    else if (shareManager.target == PFShareTargetWeChatTimeline)
    {

    }
    else if (shareManager.target == PFShareTargetWeChatSession)
    {

    }
    else if (shareManager.target == PFShareTargetQQ)
    {

    }
    else if (shareManager.target == PFShareTargetDouban)
    {
        [shareManager requestWithURL:@"shuo/v2/statuses/"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"", @"",
                                 @"", @"", nil]
                       delegate:self];
    }
    else if (shareManager.target == PFShareTargetRenren)
    {
        [shareManager requestWithURL:@"restserver.do"
                      httpMethod:@"POST"
                          params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 @"", @"",
                                 @"", @"", nil]
                       delegate:self];
    }
}

- (void)shareDidLogOut:(PFShareManager *)shareManager
{
    [shareManager removeAuthorizeData];
}

- (void)shareLogInDidCancel:(PFShareManager *)shareManager
{
    NSLog(@"用户取消了登录");
}

- (void)share:(PFShareManager *)shareManager logInDidFailWithError:(NSError *)error
{
    NSLog(@"登录失败");
}

- (void)share:(PFShareManager *)shareManager accessTokenInvalidOrExpired:(NSError *)error
{
    [shareManager removeAuthorizeData];
}

- (void)shareWillBeginRequest:(PFShareRequest *)request
{
    NSLog(@"开始请求");
}

-(void)request:(PFShareRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        NSLog(@"发表微博失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        NSLog(@"发表微博失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        //发表人人网相片回调
        NSLog(@"发表人人网相片失败");
        NSLog(@"Post image status failed with error : %@", error);
    }
}

- (void)request:(PFShareRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        NSLog(@"======result:%@", result);
        //新浪微博响应
        if([[result objectForKey:@"error_code"] intValue]==20019) {
            NSLog(@"发送频率过高，请您过会再发");
        }
        else if([[result objectForKey:@"error_code"] intValue]==0) {
            NSLog(@"发送微博成功");
        }
    }
    else if ([request.url hasSuffix:@"api/t/add_pic"])
    {
        //腾讯微博响应
        if([[result objectForKey:@"errcode"] intValue]==0) {
            NSLog(@"发表微博成功");
        } else {
            NSLog(@"发表微博失败");
        }
    }
    else if ([request.url hasSuffix:@"shuo/v2/statuses/"])
    {
        //豆瓣说响应
        if([[result objectForKey:@"code"] intValue]==0) {
            NSLog(@"发表豆瓣说成功");
        } else {
            NSLog(@"%@",result);
            NSLog(@"发表豆瓣说失败");
        }
    }
    else if ([request.url hasSuffix:@"restserver.do"])
    {
        //发表人人网相片回调
        if([[result objectForKey:@"error_code"] intValue]==0) {
            NSLog(@"发表人人网相片成功");
        } else {
            NSLog(@"发表人人网相片失败");
        }
    }
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != actionSheet.cancelButtonIndex)
    {
        manager = [PFShareManager sharedInstanceWithTarget:buttonIndex];
        manager.delegate = self;
        [manager logIn];
    }
}

#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
