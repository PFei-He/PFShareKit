//
//  PFTestView.h
//  PFShareKit
//
//  Created by PFei_He on 14-6-4.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFShareKit.h"

@interface PFTestView : UIViewController <UIApplicationDelegate, PFShareDelegate, PFShareRequestDelegate,UIActionSheetDelegate>
{
    PFShareManager *manager;
}

@end
