//
//  EasyLinkForAXZWifiLink.h
//  EasyLink
//
//  Created by William Xu on 13-9-28.
//  Copyright (c) 2015年 MXCHIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyLink.h"
#import "AXZWifiLinkProtocol.h"

@interface EasyLinkForAXZWifiLink : NSObject<EasyLinkFTCDelegate, AXZWifiLinkProtocol>{
@private
    EASYLINK *_easylink_config;
    AXZWifiLinkCallback _callback;
    NSString *_model;
    NSMutableDictionary *_aLinkDict;
}

@end