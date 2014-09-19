//
//  FCSPlane.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/10/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;
#import "FCSMission.h"
#import "FCSConnectionLink.h"
#import "FCSConnectionProtocol.h"

/**
 *  The FCSWorkerBee class represents a WorkerBee UAV
 *
 *  The device might be "connected", in which case changes to that instance will be sent to the device.  If disconnected, then on connection
 *  we can either read the state of the remote and us that, or send our state (as possibly edited offline) to the device.
 *
 */

@interface FCSWorkerBee : NSObject <FCSConnectionLinkStatusDelegate>

/**
 *  Bee factory method.  Get the bee with the specified systemID and componentID.  If that bee did not previously exist, then create it and return it.
 *
 *  @param systemID    The MAVLlink system ID for this bee
 *  @param componentID The MAVLink component ID for this bee
 *
 *  @return The initialized bee instance.  New instance if not seen before, otherwise, existing instance.
 */
+ (instancetype)beeWithSystemID:(uint8_t)systemID componentID:(uint8_t)componentID;

/**
 *  The system ID number for this Bee on the MAVlink bus
 */
@property uint8_t systemID;

/**
 *  The component ID number for this Bee on the MAVlink bus
 */
@property uint8_t componentID;

/**
 *  The user-edtiable name for this Bee.  This is not stored to the Bee right now, only stored locally.
 */
@property NSString *name;

/**
 *  The mission currently assigned to this Bee
 */
@property FCSMission *mission;

/**
 *  Add a connected link to this Bee
 *
 *  @param link The already-connected and active link to this Bee
 */
- (void)addConnection:(FCSConnectionLink *)link;

/**
 *  Read the mission from a connected Bee into this local representation.
 */
- (void)getMissionFromBeeWithProtocol:(FCSConnectionProtocol *)protocol onLink:(FCSConnectionLink *)link;

/**
 *  Send our local representation of the mission to the Bee.
 */
- (void)sendMissionToBeeWithProtocol:(FCSConnectionProtocol *)protocol onLink:(FCSConnectionLink *)link;

@end
