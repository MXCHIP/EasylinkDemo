//
//  ViewController.m
//  Easlink send demo
//
//  Created by William Xu on 15/5/8.
//  Copyright (c) 2015年 MXCHIP Inc. All rights reserved.
//

#import "GizwitsViewController.h"
#import "AppDelegate.h"

@implementation GizwitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    ssidField.text = [EASYLINK ssidForConnectedNetwork];
    
    //监测Wi-Fi连接状态
    wifiReachability = [Reachability reachabilityForLocalWiFi];
    [wifiReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wifiStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterInforground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    airlink = [[MXCHIPAirlink alloc] init];
    ConsoleLog(@"Airlink version:%@.", airlink.version);
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    ConsoleLog(@"Stop EasyLink sending.");
    [airlinkButton setSelected:NO];
    [airlink stop];
    airlink = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)airlinkButtonPressed: (UIButton *)button
{
   
    if(airlink.isRunning == NO){
        [button setSelected:YES];
//        [airlink start:ssidField.text
//                   key:passwordField.text timeout:[timeOutField.text intValue]
//           andCallback:^(MXCHIPAirlinkEvent event){
//               if(event == MXCHIPAirlinkEventStop){
//                   [button setSelected:NO];
//                   ConsoleLog(@"Airlink stoped.");
//               }else if(event == MXCHIPAirlinkEventFound)
//                   ConsoleLog(@"Airlink find a new device.");
//               else
//                   ConsoleLog(@"Unknown event.");
//           }];
        [airlink start:ssidField.text key:passwordField.text timeout:30 andCallback:nil];
        ConsoleLog(@"Sending ssid: %@, password: %@", ssidField.text, passwordField.text);
    }else{
        [button setSelected:NO];
        [airlink stop];
        ConsoleLog(@"Stop airlink sending.");
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

- (void)appEnterInforground:(NSNotification*)notification{
    NetworkStatus netStatus = [wifiReachability currentReachabilityStatus];
    
    /* iOS has connect to a wireless router */
    if ( netStatus != NotReachable ) {
        ssidField.text = [EASYLINK ssidForConnectedNetwork];
    }
}


@end


