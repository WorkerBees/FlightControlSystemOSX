//
//  FCSMessageHandlerWaypointTranferor.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler.h"

#import "FCSMission.h"
#import "FCSMissionItem.h"

#import "FCSConnectionLink.h"
#import "FCSConnectionProtocol.h"

/**
 *  Handle the mission transfer protocol to get a list of mission items from the device or send a set of mission items to the device
 */
@interface FCSMessageHandlerMissionTranferor : FCSMessageHandler

- (instancetype)initWithMission:(FCSMission *)mission withProtocol:(FCSConnectionProtocol *)protocol forLink:(FCSConnectionLink *)link sysID:(uint8_t)sysID compID:(uint8_t)compID;

@end
