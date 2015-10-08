//
//  EasyLinkForAXZWifiLink.m
//  EasyLink
//
//  Created by William Xu on 13-9-28.
//  Copyright (c) 2015年 MXCHIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyLink.h"
#import "EasyLinkForAXZWifiLink.h"
#import "EasyLink.h"

@implementation EasyLinkForAXZWifiLink

-(id)init{
    self = [super init];
    if (self) {
        _aLinkDict = [NSMutableDictionary dictionaryWithCapacity:8];
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
- (void)startLinkWith:(NSString*)ssid andPassword:(NSString*)password andModel:(NSString*)model andCallback:(AXZWifiLinkCallback)callback
{
    NSMutableDictionary *wlanConfig = [NSMutableDictionary dictionaryWithCapacity:20];
    _easylink_config = [[EASYLINK alloc]initForDebug:YES WithDelegate:self];
    
    [wlanConfig setObject: [ssid dataUsingEncoding:NSUTF8StringEncoding] forKey:KEY_SSID];
    [wlanConfig setObject: password forKey:KEY_PASSWORD];
    [wlanConfig setObject: @YES forKey:KEY_DHCP];
    
    _model = model;
    _callback = callback;

    [_easylink_config prepareEasyLink_withFTC:wlanConfig info:nil mode:EASYLINK_V2_PLUS];
    [_easylink_config transmitSettings];
}

/**
 * 停止配网
 */
-(void)stopLink
{
    [_easylink_config stopTransmitting];
    [_easylink_config unInit];
}


#pragma mark - EasyLink delegate

- (void)onFoundByFTC:(NSNumber *)client withConfiguration: (NSDictionary *)configDict
{
    [_easylink_config configFTCClient:client withConfiguration:nil];
    if([configDict objectForKey:@"mac"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"mac"] forKey:@"mac"];
    if([configDict objectForKey:@"manufacturer"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"manufacturer"] forKey:@"manufacturer"];
    if([configDict objectForKey:@"model"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"model"] forKey:@"model"];
    if([configDict objectForKey:@"name"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"name"] forKey:@"name"];
    if([configDict objectForKey:@"sn"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"sn"] forKey:@"sn"];
    if([configDict objectForKey:@"type"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"type"] forKey:@"type"];
    if([configDict objectForKey:@"uuid"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"uuid"] forKey:@"uuid"];
    if([configDict objectForKey:@"version"]!=nil)
        [_aLinkDict setObject:[configDict objectForKey:@"version"] forKey:@"version"];
}


- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict
{
    
}


- (void)onDisconnectFromFTC:(NSNumber *)client  withError:(bool)err
{
    if(err == 0){
        _callback(_aLinkDict);
    }else{
        _callback(nil);
    }
    [_easylink_config stopTransmitting];
    [_easylink_config unInit];
}

@end



