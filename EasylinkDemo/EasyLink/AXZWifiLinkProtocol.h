//
//  AXZWifiLinkProtocol.h
//  AlinkApp
//
//  Created by Wenji.lsl on 15/9/18.
//  Copyright © 2015年 Alink. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 配网回调
 *
 * @param dict 配网返回字典，
 *
 * 	成功返回例子：
 * 	 {
 * 	 mac = "AA:BB:CC:DD:EE:FF";
 * 	 manufacturer = GALANZ;
 * 	 model = "GALANZ_LIVING_AIRCONDITION_XXXX";
 * 	 name = "RDVdH19E(9BA3)";
 * 	 sn = 1234567890;
 * 	 type = AIRCONDITION;
 * 	 uuid = F0E1FF9350DB0C16E9CEF67873AABBCC;
 * 	 version = "ALINK_GALANZ_3162_AC_KFR@099";
 * 	 }
 *
 * 	失败返回例子：
 * 	{}
 */
typedef void(^AXZWifiLinkCallback)(NSDictionary *dict);

/**
 * 第三方配网协议
 */
@protocol AXZWifiLinkProtocol <NSObject>

@required

/**
 * 开始配网，发配网包（ssid+密码），设备连接路由器，发现设备，设备连接Alink云并获取设备uuid，APP得到uuid设备配网完成。
 *
 * @param ssid 家庭路由器ssid信息
 * @param password 家庭路由器密码
 * @param model 设备model信息
 * @param callback 当前配网进度回调,配网成功或失败都会回调
 */
-(void)startLinkWith:(NSString*)ssid andPassword:(NSString*)password andModel:(NSString*)model andCallback:(AXZWifiLinkCallback)callback;

/**
 * 停止配网
 */
-(void)stopLink;

@end
