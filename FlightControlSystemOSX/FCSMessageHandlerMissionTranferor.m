//
//  FCSMessageHandlerWaypointTranferor.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandlerMissionTranferor.h"
#import "FCSMessageHandler_Private.h"

#import "FCSMission.h"

#import "FCSConnectionProtocol.h"
#import "FCSConnectionLink.h"
#import "FCSMAVLinkMessage.h"

#import "FCSGoogleElevation.h"

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
@property FCSMission *theMission;
@property FCSConnectionLink *theLink;
@property FCSConnectionProtocol *theProtocol;

@property uint8_t sysID;
@property uint8_t compID;

@end

@implementation FCSMessageHandlerMissionTranferor

- (void)receivedMissionItem:(NSNotification *)notification
{
    FCSMAVLinkMissionItemMessage *msg = [notification.userInfo objectForKey:@"message"];
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];

    // If it wasn't for us, then ignore
    if(link != self.theLink ||
       protocol != self.theProtocol ||
       msg.targetSystem != FCSGCSSystemID ||
       msg.targetComponent != FCSGCSComponentID) return;

    // For now just stick the message in the mission_items list
    [self.theMission makeMissionItemFromMessage:msg];
    if(msg.sequenceNumber+1 == self.item_count)
    {
        NSLog(@"Mission is complete: %@", self.theMission);
    }

    // Check if complete
    // TODO: handle errors that might have other ACK types
    if(msg.sequenceNumber+1 != self.item_count)
    {
        // Send next request
        FCSMAVLinkMissionRequestMessage *req = [[FCSMAVLinkMissionRequestMessage alloc] init];
        req.targetSystem = self.sysID;
        req.targetComponent = self.compID;
        req.sequenceNumber = msg.sequenceNumber+1;
        [self.theProtocol sendMessage:req onLink:self.theLink];
    }
    else
    {
        // Send ACK and be done
        [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM]];
        FCSMAVLinkMissionAcknowledgementMessage *req = [[FCSMAVLinkMissionAcknowledgementMessage alloc] init];
        req.targetSystem = self.sysID;
        req.targetComponent = self.compID;
        req.type = FCSMAVMissionAck_ACCEPTED;
        [self.theProtocol sendMessage:req onLink:self.theLink];
    }
}

- (void)receivedMissionCount:(NSNotification *)notification
{
    FCSConnectionProtocol *protocol = [notification.userInfo objectForKey:@"protocol"];
    FCSConnectionLink *link = [notification.userInfo objectForKey:@"link"];
    FCSMAVLinkMissionCountMessage *msg = [notification.userInfo objectForKey:@"message"];

    // If it wasn't for us, then ignore
    if(link != self.theLink ||
       protocol != self.theProtocol ||
       msg.targetSystem != FCSGCSSystemID ||
       msg.targetComponent != FCSGCSComponentID) return;

    // Cancel timeout
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(missionCountTimeout) object:nil];

    [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT]];

    self.item_count = msg.count;

    // Listen for reply
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_ITEM] withSelector:@selector(receivedMissionItem:)];

    // Send next request
    FCSMAVLinkMissionRequestMessage *req = [[FCSMAVLinkMissionRequestMessage alloc] init];
    req.targetSystem = self.sysID;
    req.targetComponent = self.compID;
    req.sequenceNumber = 0;
    [self.theProtocol sendMessage:req onLink:self.theLink];
}

- (void)missionCountTimeout
{
    // We didn't get a MISSION_COUNT message in time.  So assume something went wrong, and retry
    NSLog(@"TIMEOUT: no MISSION_COUNT in time; restarting dialog");
    [self stopHandlingMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT]];

    [self requestMission];
}

#pragma mark - Lifecycle

- (void)requestMission
{
    // Listen for reply
    [self handleMessage:[FCSMAVLinkMessage nameForMessageID:MAVLINK_MSG_ID_MISSION_COUNT] withSelector:@selector(receivedMissionCount:)];

    // Send the message
    FCSMAVLinkMissionRequestListMessage *req = [[FCSMAVLinkMissionRequestListMessage alloc] init];
    req.targetSystem = self.sysID;
    req.targetComponent = self.compID;
    [self.theProtocol sendMessage:req onLink:self.theLink];

    // Start timeout; if expires before being cleared, will restart the dialog.
    [self performSelector:@selector(missionCountTimeout) withObject:nil afterDelay:1.0];
}

- (instancetype)initWithMission:(FCSMission *)mission withProtocol:(FCSConnectionProtocol *)protocol forLink:(FCSConnectionLink *)link sysID:(uint8_t)sysID compID:(uint8_t)compID
{
    self = [super init];

    _theMission = mission;
    _theLink = link;
    _theProtocol = protocol;
    _sysID = sysID;
    _compID = compID;

    [self requestMission];

    return self;
}


@end
