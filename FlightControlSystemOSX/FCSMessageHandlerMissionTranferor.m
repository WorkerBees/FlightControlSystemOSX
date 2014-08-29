//
//  FCSMessageHandlerWaypointTranferor.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandlerMissionTranferor.h"
#import "FCSMessageHandler_Private.h"

#import "FCSConnectionProtocol.h"
#import "FCSConnectionLink.h"
#import "FCSMAVLinkMessage.h"

/*
 *
 * Protocol goes like:
 * GCS   --- MISSION_REQUEST_LIST --->  MAV
 * GCS   <-- MISSION_COUNT -----------  MAV
 * GCS   --- MISSION_REQUEST 0 ------>  MAV
 * GCS   <-- MISSION_ITEM ------------  MAV
 * GCS   --- MISSION_REQUEST 1 ------>  MAV
 *               ......
 * GCS   --- MISSION_ACK ------------>  MAV
 *
 *  ...with timeouts one each side waiting for the next message
 */

#import "FCSMAVLinkMissionRequestListMessage.h"
#import "FCSMAVLinkMissionCountMessage.h"
#import "FCSMAVLinkMissionRequestMessage.h"
#import "FCSMAVLinkMissionItemMessage.h"
#import "FCSMAVLinkMissionAcknowledgementMessage.h"

@interface FCSMessageHandlerMissionTranferor ()

@property NSUInteger item_count;
@property NSMutableArray *mission_items;

@end

@implementation FCSMessageHandlerMissionTranferor

- (void)receivedMissionItem:(NSNotification *)notification
{
    FCSMAVLinkMissionItemMessage *msg = [notification.userInfo objectForKey:@"message"];
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];

    // Check if it's for us; if not, then skip
    if(msg.targetSystem != FCSGCSSystemID || msg.targetComponent != FCSGCSComponentID)
    {
        NSLog(@"Not our mission item: %@", msg);
        return;
    }

    // For now just stick the message in the mission_items list
    [_mission_items addObject:msg];

    if(_delegate && [_delegate respondsToSelector:@selector(receivedMissionItem:)])
    {
        [_delegate receivedMissionItem:msg];
    }

    // Check if complete
    // TODO: handle errors that might have other ACK types
    if(_mission_items.count != _item_count)
    {
        // Send next request
        FCSMAVLinkMissionRequestMessage *req = [[FCSMAVLinkMissionRequestMessage alloc] init];
        req.targetSystem = msg.theMessage->sysid;
        req.targetComponent = msg.theMessage->compid;
        req.sequenceNumber = (uint16_t)_mission_items.count;
        [protocol sendMessage:req onLink:link];
    }
    else
    {
        // Send ACK and be done
        [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM]];
        FCSMAVLinkMissionAcknowledgementMessage *req = [[FCSMAVLinkMissionAcknowledgementMessage alloc] init];
        req.targetSystem = msg.theMessage->sysid;
        req.targetComponent = msg.theMessage->compid;
        req.type = FCSMAVMissionAck_ACCEPTED;
        [protocol sendMessage:req onLink:link];

        // Notify the delegate
        if(_delegate && [_delegate respondsToSelector:@selector(receivedMissionItems:)])
        {
            [_delegate receivedMissionItems:_mission_items];
        }
    }
}

- (void)receivedMissionCount:(NSNotification *)notification
{
    FCSMAVLinkMissionCountMessage *msg = [notification.userInfo objectForKey:@"message"];
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];

    // Check if it's for us; if not, then skip
    if(msg.targetSystem != FCSGCSSystemID || msg.targetComponent != FCSGCSComponentID)
    {
        NSLog(@"Not our mission count: %@", msg);
        return;
    }

    [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT]];

    _item_count = msg.count;
    _mission_items = [NSMutableArray arrayWithCapacity:_item_count];

    // Listen for reply
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM] withSelector:@selector(receivedMissionItem:)];

    // Send next request
    FCSMAVLinkMissionRequestMessage *req = [[FCSMAVLinkMissionRequestMessage alloc] init];
    req.targetSystem = msg.theMessage->sysid;
    req.targetComponent = msg.theMessage->compid;
    req.sequenceNumber = (uint16_t)_mission_items.count;
    [protocol sendMessage:req onLink:link];

    // Notify the delegate
    if(_delegate &&
       [_delegate respondsToSelector:@selector(receivedMissionItemCount:)])
    {
        [_delegate receivedMissionItemCount:_item_count];
    }
}

// When we get a heartbeat message, unregister for heartbeats, then send a request
- (void)requestListAfterHeartbeat:(NSNotification *)notification
{
    [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_HEARTBEAT]];

    FCSMAVLinkMessage *msg = [notification.userInfo objectForKey:@"message"];
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];

    // Listen for reply
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT] withSelector:@selector(receivedMissionCount:)];

    // Send the message
    FCSMAVLinkMissionRequestListMessage *req = [[FCSMAVLinkMissionRequestListMessage alloc] init];
    req.targetSystem = msg.theMessage->sysid;
    req.targetComponent = msg.theMessage->compid;
    [protocol sendMessage:req onLink:link];
}

- (instancetype)init
{
    self = [super init];

    // Start the dialog once we get a heartbeat
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_HEARTBEAT] withSelector:@selector(requestListAfterHeartbeat:)];

    return self;
}

- (instancetype)initWithDelegate:(id<FCSWaypointListReceivedHandler>)delegate
{
    self = [self init];

    _delegate = delegate;

    return self;
}


@end
