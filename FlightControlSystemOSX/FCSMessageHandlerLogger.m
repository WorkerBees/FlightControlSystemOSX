//
//  FCSMessageHandlerLogger.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandlerLogger.h"
#import "FCSMessageHandler_Private.h"

#import "FCSMAVLinkMessage.h"

@implementation FCSMessageHandlerLogger

- (void)logMAVLinkMessage:(NSNotification *)notification
{
    FCSMAVLinkMessage *msg = [notification.userInfo objectForKey:@"message"];
    NSLog(@"Received: %@", msg);
}

- (instancetype)init
{
    self = [super init];

    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_HEARTBEAT] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_STATUSTEXT] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_SYS_STATUS] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_SYSTEM_TIME] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MEMINFO] withSelector:@selector(logMAVLinkMessage:)];

    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_REQUEST_LIST] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_REQUEST] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM] withSelector:@selector(logMAVLinkMessage:)];
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ACK] withSelector:@selector(logMAVLinkMessage:)];

    return self;
}

@end
