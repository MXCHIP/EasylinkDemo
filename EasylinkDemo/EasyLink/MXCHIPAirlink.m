//
//  EasyLinkForAXZWifiLink.m
//  EasyLink
//
//  Created by William Xu on 13-9-28.
//  Copyright (c) 2015年 MXCHIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyLink.h"
#import "MXCHIPAirlink.h"

#define AIRLINK_VERSION  @"1.0.0"

@implementation MXCHIPAirlink

@synthesize isRunning = _isRunning;
@synthesize version = _version;

-(id)init{
    self = [super init];
    if (self) {
        _isRunning = false;
        _version = [[NSString alloc] initWithFormat:@"v%@ on Easylink %@", AIRLINK_VERSION, [EASYLINK version]];
        _callback = nil;
    }
    return self;
}

/**
 * 开始配网，发配网包（ssid+密码），设备连接路由器，发现设备，设备连接Alink云并获取设备uuid，APP得到uuid设备配网完成。
 *
 * @param ssid 家庭路由器ssid信息
 * @param password 家庭路由器密码
 * @param model 设备model信息
 * @param callback 当前配网进度回调,配网成功或失败都会回调
 */
- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout andCallback:(onEvent)callback
{
    if( _isRunning == true )
        return;
    
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    _easylink_config = [[EASYLINK alloc]initForDebug:false WithDelegate:self];
    _callback = callback;
    
    [wlanConfig setObject: [ssid dataUsingEncoding:NSUTF8StringEncoding] forKey:KEY_SSID];
    [wlanConfig setObject: key forKey:KEY_PASSWORD];
    [wlanConfig setObject: @YES forKey:KEY_DHCP];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(stop) withObject:nil afterDelay:timeout];
    
    [_easylink_config prepareEasyLink:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    [_easylink_config transmitSettings];
    _isRunning = true;
}

- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout{
    [self start:ssid key:key timeout:timeout andCallback:nil];
}

/**
 * 停止配网
 */
- (void)stop
{
    if( _isRunning == true ){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        _isRunning = false;
        [_easylink_config stopTransmitting];
        [_easylink_config unInit];
        if( _callback != nil ){
            _callback(MXCHIPAirlinkEventStop);
        }
        _callback = nil;
    }
}

/**
 @brief A new FTC client is found by bonjour in EasyLink
 @note  Available only on MiCO version after 2.3.0
 @param client:         Client identifier.
 @param name:           Client name.
 @param mataDataDict:   Txt record provided by device
 @return none.
 */
- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict{
    if( _callback != nil ){
        _callback(MXCHIPAirlinkEventFound);
    }
}


@end



