//
//  EasyLinkForAXZWifiLink.h
//  EasyLink
//
//  Created by William Xu on 13-9-28.
//  Copyright (c) 2015年 MXCHIP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyLink.h"

typedef NS_ENUM(NSInteger, MXCHIPAirlinkEvent) {
    MXCHIPAirlinkEventStart,
    MXCHIPAirlinkEventStop,
    MXCHIPAirlinkEventFound,
};

typedef void(^onEvent)(MXCHIPAirlinkEvent event);

@interface MXCHIPAirlink : NSObject<EasyLinkFTCDelegate>{
@private
    EASYLINK *_easylink_config;
    onEvent _callback;
}

- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout;
- (void)start:(NSString*)ssid key:(NSString*)key timeout:(int)timeout andCallback:(onEvent)callback;
- (void)stop;

@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, readonly) NSString* version;

@end


