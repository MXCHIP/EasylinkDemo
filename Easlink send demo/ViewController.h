//
//  ViewController.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EASYLINK.h"


@interface ViewController : UIViewController{
    EASYLINK *easylink_config;
    UIAlertView *alert;
}



- (IBAction) easyLinkButtonPressed: (UIButton *) button;


@end

