//
//  ViewController.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EASYLINK.h"
#import "Reachability.h"


@interface EasylinkViewController : UIViewController<UITextFieldDelegate>{
    Reachability *wifiReachability;
    NSData *_ssidData;
    EASYLINK *easylink_config;
    IBOutlet UITextField *ssidField, *passwordField, *infoField, *encryptKeyField;
    IBOutlet UIButton *easylinkButton;
}



- (IBAction) easyLinkButtonPressed: (UIButton *) button;


@end

