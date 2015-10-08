//
//  ViewController.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyLinkForAXZWifiLink.h"
#import "Reachability.h"


@interface EasylinkAliViewController : UIViewController<UITextFieldDelegate>{
    Reachability *wifiReachability;
    EasyLinkForAXZWifiLink *easylink_ali;
    IBOutlet UIButton *easylinkAliButton;
    IBOutlet UITextField *ssidField, *passwordField, *moduleField;
}

- (IBAction) easyLinkAliButtonPressed: (UIButton *) button;


@end

