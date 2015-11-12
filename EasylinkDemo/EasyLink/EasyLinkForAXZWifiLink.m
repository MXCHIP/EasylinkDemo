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

@interface EasyLinkForAXZWifiLink ()

-(void)searchForCell:(NSDictionary *)sectors;

@end

@implementation EasyLinkForAXZWifiLink

-(id)init{
    self = [super init];
    if (self) {
        
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
    _easylink_config = [[EASYLINK alloc]initForDebug:false WithDelegate:self];
    _aLinkDict = [NSMutableDictionary dictionaryWithCapacity:8];
    
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

-(void)searchForCell:(NSDictionary *)sectors
{
    for(NSDictionary *sector in sectors){
        for(NSDictionary *cell in [sector objectForKey:@"C"]){
            if([[cell objectForKey:@"C"] isKindOfClass:[NSArray class]]){ //This is a sun-menu
                [self searchForCell:[cell objectForKey:@"C"]];
                continue;
            }
            NSLog(@"found: %@",[cell description]);

            if([[cell objectForKey:@"N"] isEqualToString:@"mac"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"mac"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"manufacturer"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"manufacturer"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"model"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"model"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"name"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"name"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"sn"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"sn"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"type"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"type"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"uuid"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"uuid"];
                continue;
            }
            if([[cell objectForKey:@"N"] isEqualToString:@"version"]){
                [_aLinkDict setObject:[cell objectForKey:@"C"] forKey:@"version"];
                continue;
            }
        }
    }

}

#pragma mark - EasyLink delegate

- (void)onFoundByFTC:(NSNumber *)client withConfiguration: (NSDictionary *)configDict
{
    [self searchForCell:[configDict objectForKey:@"C"]];
    [_easylink_config configFTCClient:client withConfiguration:nil];
}


- (void)onFound:(NSNumber *)client withName:(NSString *)name mataData: (NSDictionary *)mataDataDict
{
    [_easylink_config stopTransmitting];
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



