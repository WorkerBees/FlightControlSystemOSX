//
//  AppDelegate.m
//  dummy
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "AppDelegate.h"

#import "FCSMAVLinkMessage.h"

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"App delegate created and finished launching");
    self.connectionLinkManager = [[FCSConnectionLinkManager alloc] init];

    NSLog(@"Registering for notifications on certain message types");
    // Broadcast that we received this message
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_HEARTBEAT] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_STATUSTEXT] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_SYS_STATUS] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_SYSTEM_TIME] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MEMINFO] object:nil];

    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_REQUEST_LIST] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_REQUEST] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM] object:nil];
    [nc addObserver:self selector:@selector(logMAVLinkMessage:) name:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ACK] object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.connectionLinkManager = nil;
}

- (void)logMAVLinkMessage:(NSNotification *)notification
{
    FCSMAVLinkMessage *msg = [notification.userInfo objectForKey:@"message"];
    NSLog(@"Received: %@", msg);
}

@end
