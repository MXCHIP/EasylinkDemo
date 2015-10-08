//
//  ViewController.m
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"


@interface RootViewController ()

@end




@implementation RootViewController
@synthesize hidden;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    console.layoutManager.allowsNonContiguousLayout = NO;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.console = console;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
