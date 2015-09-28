//
//  ViewController.m
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if( easylink_config == nil){
        easylink_config = [[EASYLINK alloc]initWithDelegate:self];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [easylink_config stopTransmitting];
    //[easylink_config stopTransmitting];
    //[easylink_config stopTransmitting];
}

#pragma mark - EasyLink delegate -

- (void)onFoundByFTC:(NSNumber *)ftcClientTag withConfiguration: (NSDictionary *)configDict
{
    NSLog(@"New device found!");
    [easylink_config configFTCClient:ftcClientTag
                   withConfiguration: [NSDictionary dictionary] ];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)onDisconnectFromFTC:(NSNumber *)ftcClientTag
{
    NSLog(@"Device disconnected!");
}


- (IBAction) easyLinkButtonPressed: (UIButton *) button
{
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    NSData *ssidData = [EASYLINK ssidDataForConnectedNetwork];
    NSString *ssidString = [EASYLINK ssidForConnectedNetwork];
    NSString *passwordString = @"stm32f215";

    [wlanConfig setObject:ssidData forKey:KEY_SSID];
    [wlanConfig setObject:passwordString forKey:KEY_PASSWORD];
    [wlanConfig setObject:[NSNumber numberWithBool:YES] forKey:KEY_DHCP];
    
    [easylink_config prepareEasyLink_withFTC:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    
    [easylink_config transmitSettings];
    
    NSString *message = [NSString stringWithFormat:@"Sending ssid: %@, password: %@", ssidString, passwordString];
    
    alert = [[UIAlertView alloc] initWithTitle:@"EasyLink"
                                message:message
                               delegate:(id)self
                      cancelButtonTitle:@"stop"
                      otherButtonTitles:nil];
    [alert show];
}




@end
