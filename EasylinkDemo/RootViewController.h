//
//  ViewController.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasylinkViewController.h"
//#import "EasylinkViewAliController.h"


@interface RootViewController : UIViewController{
    bool hidden;
    IBOutlet UITextView *console;
}

@property bool hidden;

@end

