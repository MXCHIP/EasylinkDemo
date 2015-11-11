//
//  ViewController.m
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import "EasylinkViewController.h"
#import "AppDelegate.h"

@interface EasylinkViewController ()

@end

@implementation EasylinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    ssidField.text = [EASYLINK ssidForConnectedNetwork];
    _ssidData = [EASYLINK ssidDataForConnectedNetwork];
    
    //监测Wi-Fi连接状态
    wifiReachability = [Reachability reachabilityForLocalWiFi];
    [wifiReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiStatusChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    ConsoleLog(@"EasyLink library initialize.");
    easylink_config = [[EASYLINK alloc]initForDebug:true WithDelegate:self];
    [easylinkButton setSelected:NO];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    ConsoleLog(@"EasyLink library de-initialize.");
    [easylink_config unInit];
    easylink_config = nil;
    [easylinkButton setSelected:NO];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [easylink_config unInit];
}

- (IBAction) easyLinkButtonPressed: (UIButton *) button
{
    if(button.selected == NO){
        NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:5];
        
        [button setSelected:YES];
        [wlanConfig setObject:_ssidData forKey:KEY_SSID];
        [wlanConfig setObject:passwordField.text forKey:KEY_PASSWORD];
        [wlanConfig setObject:[NSNumber numberWithBool:YES] forKey:KEY_DHCP];
        
        [easylink_config prepareEasyLink_withFTC:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
        [easylink_config transmitSettings];
        
        ConsoleLog(@"Sending ssid: %@, password: %@", ssidField.text, passwordField.text);
    }else{
        [button setSelected:NO];
        [easylink_config stopTransmitting];
        ConsoleLog(@"Stop EasyLink sending.");
    }

}

#pragma mark - EasyLink delegate -

- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict
{
    /*Config is success*/
    ConsoleLog(@"Found by mDNS, client:%d, config success!", [client intValue]);
    [easylink_config stopTransmitting];
    [easylinkButton setSelected:NO];
}

- (void)onFoundByFTC:(NSNumber *)ftcClientTag withConfiguration: (NSDictionary *)configDict
{
    /*Config is not success, need to write config to client to finish*/
    ConsoleLog(@"Found by FTC, client:%d", [ftcClientTag intValue]);
    [easylink_config configFTCClient:ftcClientTag withConfiguration: [NSDictionary dictionary] ];
    [easylink_config stopTransmitting];
}

- (void)onDisconnectFromFTC:(NSNumber *)client  withError:(bool)err;
{
    if(err == NO)
        ConsoleLog(@"Device disconnected, config success!");
    else
        ConsoleLog(@"Device disconnected with error, config failed!");
    [easylinkButton setSelected:NO];
}

#pragma mark - UITextField delegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Wi-Fi status changed -
- (void)wifiStatusChanged:(NSNotification*)notification{
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    
    /* iOS has connect to a wireless router */
    if ( netStatus != NotReachable && ![[EASYLINK ssidForConnectedNetwork] hasPrefix:@"EasyLink_"] && easylink_config.softAPSending == false) {
        ssidField.text = [EASYLINK ssidForConnectedNetwork];
        _ssidData = [EASYLINK ssidDataForConnectedNetwork];
    }else{
        ConsoleLog(@"Not connected to a WiFi network.");
    }
}


@end
