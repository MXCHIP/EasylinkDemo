//
//  ViewController.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXCHIPAirlink.h"
#import "Reachability.h"


@interface GizwitsViewController : UIViewController<UITextFieldDelegate>{
    Reachability *wifiReachability;
    MXCHIPAirlink *airlink;
    IBOutlet UIButton *airlinkButton;
    IBOutlet UITextField *ssidField, *passwordField, *timeOutField;
}

- (IBAction) airlinkButtonPressed: (UIButton *) button;


@end

