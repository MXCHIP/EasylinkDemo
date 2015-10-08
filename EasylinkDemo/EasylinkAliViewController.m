//
//  ViewController.m
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import "EasylinkAliViewController.h"
#import "AppDelegate.h"



@interface EasylinkAliViewController (private)

- (void)AXZWifiLinkCallback:(NSDictionary *)dict;

@end

@implementation EasylinkAliViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    ssidField.text = [EASYLINK ssidForConnectedNetwork];
    
    //监测Wi-Fi连接状态
    wifiReachability = [Reachability reachabilityForLocalWiFi];
    [wifiReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiStatusChanged:) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    ConsoleLog(@"Stop EasyLink ali sending.");
    [easylinkAliButton setSelected:NO];
    [easylink_ali stopLink];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) easyLinkAliButtonPressed: (UIButton *) button
{
    if(button.selected == NO){
        [button setSelected:YES];
        easylink_ali = [[EasyLinkForAXZWifiLink alloc] init];
        [easylink_ali startLinkWith:ssidField.text
                        andPassword:passwordField.text
                           andModel:moduleField.text
                        andCallback:^(NSDictionary *dict){
                            ConsoleLog(@"EasyLink ali config success, %@.", [dict description] );
                            [button setSelected:NO];
                            ConsoleLog(@"Stop EasyLink ali sending.");
                        }];
        
        ConsoleLog(@"Sending ssid: %@, password: %@", ssidField.text, passwordField.text);
    }else{
        [button setSelected:NO];
        [easylink_ali stopLink];
        ConsoleLog(@"Stop EasyLink ali sending.");
    }
}

#pragma mark - UITextField delegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
 Notification method handler when status of wifi changes
 @param the fired notification object
 */
- (void)wifiStatusChanged:(NSNotification*)notification{
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    
    /* iOS has connect to a wireless router */
    if ( netStatus != NotReachable ) {
        ssidField.text = [EASYLINK ssidForConnectedNetwork];
    }
}


@end


