//
//  FCSMessageHandlerNewBeeDetector.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/17/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandlerNewBeeDetector.h"
#import "FCSMessageHandler_Private.h"

#import "FCSMAVLinkMessage.h"

#import "FCSWorkerBee.h"

@implementation FCSMessageHandlerNewBeeDetector


- (void)checkForNewBee:(NSNotification *)notification
{
    FCSMAVLinkMessage *msg = [notification.userInfo objectForKey:@"message"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    NSLog(@"Received: %@", msg);

    FCSWorkerBee *bee = [FCSWorkerBee beeWithSystemID:msg.theMessage->sysid componentID:msg.theMessage->compid];

    if(bee.mission == nil)
    {
        [bee getMissionFromBeeWithProtocol:protocol onLink:link];
    }
}


- (instancetype)init
{
    self = [super init];

    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_HEARTBEAT] withSelector:@selector(checkForNewBee:)];

    return self;
}

@end
