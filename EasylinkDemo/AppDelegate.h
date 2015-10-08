//
//  AppDelegate.h
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ConsoleLog(A, ...) do{[[(AppDelegate*)[[UIApplication sharedApplication]delegate] console] displayDebug:[NSString stringWithFormat:@"%s:%d-> %@", __func__, __LINE__, [NSString stringWithFormat:(A), ##__VA_ARGS__]]];} while(1==0)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) UITextView *console;

@end

@interface UITextView (Additions)
- (void)displayDebug:(NSString *)debugInfo;
@end



